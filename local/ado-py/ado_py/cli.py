"""CLI entry point for ado-py. JSON stdin/stdout interface."""
from __future__ import annotations

import argparse
import difflib
import json
import sys

from ado_py.models import UserStoryInput, ORG_TO_ADO_STATE
from ado_py.ado_client import AdoClient, AdoError, AdoPermissionError
from ado_py.work_items import (
    fetch_work_item,
    fetch_work_items_batch,
    create_user_story,
    update_work_item,
    link_work_items,
    fetch_my_items,
    fetch_children,
    fetch_current_iteration,
    fetch_next_iteration,
)


def _get_client() -> AdoClient:
    return AdoClient()


def _fail(kind: str, message: str, **extra: object) -> None:
    """Emit a structured error to stderr and exit non-zero."""
    payload = {"ok": False, "error_kind": kind, "error": message}
    payload.update(extra)
    json.dump(payload, sys.stderr, indent=2)
    sys.exit(1)


def _tag_suggestions(client: AdoClient, project: str, requested: str) -> list[str]:
    """Return existing tags similar to REQUESTED (for typo hints)."""
    try:
        existing = client.list_tags(project)
    except Exception:
        return []
    if not requested:
        return []
    # Split multi-value tag strings ("A; B") and match each part.
    parts = [p.strip() for p in requested.replace(";", ",").split(",") if p.strip()]
    suggestions: list[str] = []
    lower_map = {t.lower(): t for t in existing}
    for part in parts:
        pl = part.lower()
        if pl in lower_map:
            continue  # exists (case-insensitive) — not the culprit
        close = difflib.get_close_matches(part, existing, n=3, cutoff=0.5)
        # Also add substring matches
        substr = [t for t in existing if pl in t.lower() and t not in close]
        suggestions.extend(close + substr[:3])
    # De-dup preserving order
    seen = set()
    out = []
    for s in suggestions:
        if s not in seen:
            seen.add(s)
            out.append(s)
    return out[:5]


def cmd_validate(args: argparse.Namespace) -> None:
    """Validate a story from JSON stdin without pushing."""
    data = json.load(sys.stdin)
    try:
        story = UserStoryInput(**data)
        result = story.validate_for_push()
        json.dump({"ok": result.ok, "errors": result.errors, "parsed": story.model_dump()}, sys.stdout, indent=2)
    except Exception as e:
        json.dump({"ok": False, "errors": [str(e)]}, sys.stdout, indent=2)
        sys.exit(1)


def cmd_create(args: argparse.Namespace) -> None:
    """Create a User Story from JSON stdin."""
    data = json.load(sys.stdin)
    try:
        story = UserStoryInput(**data)
    except Exception as e:
        _fail("validation", str(e))

    client = _get_client()
    try:
        result = create_user_story(client, story, project=args.project)
    except AdoPermissionError as e:
        _handle_tag_permission(client, args.project, data.get("tags"), e)
    except AdoError as e:
        _fail(e.kind, str(e))
    json.dump({"ok": True, "id": result["id"], "item": result}, sys.stdout, indent=2)


def cmd_fetch(args: argparse.Namespace) -> None:
    """Fetch a work item by ID."""
    client = _get_client()
    result = fetch_work_item(client, args.id, include_relations=True)
    json.dump(result, sys.stdout, indent=2)


def cmd_fetch_batch(args: argparse.Namespace) -> None:
    """Fetch multiple work items by IDs."""
    client = _get_client()
    ids = [int(x) for x in args.ids.split(",")]
    results = fetch_work_items_batch(client, ids)
    json.dump(results, sys.stdout, indent=2)


def cmd_children(args: argparse.Namespace) -> None:
    """Fetch all children of a parent work item."""
    client = _get_client()
    results = fetch_children(client, args.id)
    json.dump(results, sys.stdout, indent=2)


def cmd_my_items(args: argparse.Namespace) -> None:
    """Fetch my current-iteration items."""
    client = _get_client()
    items = fetch_my_items(client, project=args.project, team=args.team,
                           tag=getattr(args, "tag", None))
    json.dump(items, sys.stdout, indent=2)


def _handle_tag_permission(client: AdoClient, project: str,
                           requested_tags: object, err: AdoPermissionError) -> None:
    """Emit a tag-permission error enriched with typo suggestions, then exit."""
    if err.kind == "permission" and "tag" in str(err).lower():
        tags = requested_tags if isinstance(requested_tags, str) else ""
        suggestions = _tag_suggestions(client, project, tags) if tags else []
        msg = (
            "Tag creation is not permitted for your account. The tag you requested "
            f"({tags!r}) does not exist yet, and you lack permission to create new tags. "
            "This is a permissions issue, NOT an auth or network problem."
        )
        if suggestions:
            msg += " Did you mean one of these existing tags: " + ", ".join(suggestions) + "?"
        else:
            msg += " Please pick an existing tag (check spelling)."
        _fail("tag_permission", msg, requested_tags=tags, suggestions=suggestions)
    # Non-tag permission error
    _fail(err.kind, str(err))


def cmd_update(args: argparse.Namespace) -> None:
    """Update a work item from JSON stdin."""
    data = json.load(sys.stdin)
    if "state" in data and data["state"] in ORG_TO_ADO_STATE:
        data["state"] = ORG_TO_ADO_STATE[data["state"]]
    client = _get_client()
    try:
        result = update_work_item(client, args.id, data, project=args.project)
    except AdoPermissionError as e:
        _handle_tag_permission(client, args.project, data.get("tags"), e)
    except AdoError as e:
        _fail(e.kind, str(e))
    json.dump({"ok": True, "id": result["id"], "item": result}, sys.stdout, indent=2)


def cmd_current_iteration(args: argparse.Namespace) -> None:
    """Fetch the current iteration for the team."""
    client = _get_client()
    result = fetch_current_iteration(client, project=args.project, team=args.team)
    if result is None:
        json.dump({"error": "No current iteration configured for this team"}, sys.stderr, indent=2)
        sys.exit(1)
    json.dump(result, sys.stdout, indent=2)


def cmd_next_iteration(args: argparse.Namespace) -> None:
    """Fetch the iteration following the current one for the team."""
    client = _get_client()
    current = fetch_current_iteration(client, project=args.project, team=args.team)
    if current is None:
        json.dump({"error": "No current iteration configured for this team"}, sys.stderr, indent=2)
        sys.exit(1)
    result = fetch_next_iteration(client, project=args.project, team=args.team)
    if result is None:
        json.dump({"error": "No next iteration scheduled after the current one"}, sys.stderr, indent=2)
        sys.exit(1)
    json.dump(result, sys.stdout, indent=2)


def cmd_tags(args: argparse.Namespace) -> None:
    """List existing tags for the project (optionally filtered by substring)."""
    client = _get_client()
    try:
        tags = client.list_tags(args.project)
    except AdoError as e:
        _fail(e.kind, str(e))
    if getattr(args, "filter", None):
        f = args.filter.lower()
        tags = [t for t in tags if f in t.lower()]
    json.dump(sorted(tags), sys.stdout, indent=2)


def cmd_link(args: argparse.Namespace) -> None:
    """Link two work items."""
    client = _get_client()
    result = link_work_items(client, args.source, args.target, link_type=args.type, project=args.project)
    json.dump({"ok": True, "id": result["id"]}, sys.stdout, indent=2)


def main() -> None:
    parser = argparse.ArgumentParser(prog="ado-py", description="ADO User Story CLI")
    parser.add_argument("--project", default="OperationsResearch_AdvancedAnalytics")
    parser.add_argument("--team", default="Muscle Shoals")
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser("validate", help="Validate story JSON from stdin")
    sub.add_parser("create", help="Create story from JSON stdin")

    fetch_p = sub.add_parser("fetch", help="Fetch work item by ID")
    fetch_p.add_argument("--id", type=int, required=True)

    batch_p = sub.add_parser("fetch-batch", help="Fetch multiple work items by comma-separated IDs")
    batch_p.add_argument("--ids", required=True, help="Comma-separated IDs")

    children_p = sub.add_parser("children", help="Fetch children of a parent work item")
    children_p.add_argument("--id", type=int, required=True)

    my_items_p = sub.add_parser("my-items", help="Fetch my current-iteration items")
    my_items_p.add_argument("--tag", default=None, help="Filter by existing System.Tags value")
    sub.add_parser("current-iteration", help="Fetch current iteration path and dates")
    sub.add_parser("next-iteration", help="Fetch next iteration path and dates")

    tags_p = sub.add_parser("tags", help="List existing project tags")
    tags_p.add_argument("--filter", default=None, help="Case-insensitive substring filter")

    update_p = sub.add_parser("update", help="Update work item from JSON stdin")
    update_p.add_argument("--id", type=int, required=True)

    link_p = sub.add_parser("link", help="Link two work items")
    link_p.add_argument("--source", type=int, required=True)
    link_p.add_argument("--target", type=int, required=True)
    link_p.add_argument("--type", default="parent", choices=["parent", "child", "related"])

    args = parser.parse_args()
    cmds = {
        "validate": cmd_validate,
        "create": cmd_create,
        "fetch": cmd_fetch,
        "fetch-batch": cmd_fetch_batch,
        "children": cmd_children,
        "my-items": cmd_my_items,
        "current-iteration": cmd_current_iteration,
        "next-iteration": cmd_next_iteration,
        "tags": cmd_tags,
        "update": cmd_update,
        "link": cmd_link,
    }
    cmds[args.command](args)


if __name__ == "__main__":
    main()

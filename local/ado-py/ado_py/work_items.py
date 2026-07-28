"""Deterministic fetch/create/update operations for User Stories."""
from __future__ import annotations

from typing import Any

from ado_py.models import UserStoryInput, DEFAULT_PROJECT, ORG_URL
from ado_py.ado_client import AdoClient


def _extract_id_from_url(url: str) -> int | None:
    """Extract work item ID from an ADO API URL."""
    try:
        return int(url.rstrip("/").split("/")[-1])
    except (ValueError, IndexError):
        return None


def work_item_to_dict(wi: dict[str, Any], include_relations: bool = False) -> dict[str, Any]:
    """Convert ADO REST API work item response to a flat dict."""
    fields = wi.get("fields", {})
    assigned = fields.get("System.AssignedTo")
    if isinstance(assigned, dict):
        assigned = assigned.get("displayName", str(assigned))

    result = {
        "id": wi.get("id"),
        "title": fields.get("System.Title"),
        "state": fields.get("System.State"),
        "type": fields.get("System.WorkItemType"),
        "description": fields.get("System.Description"),
        "acceptance_criteria": fields.get("Microsoft.VSTS.Common.AcceptanceCriteria"),
        "notes": fields.get("AAIT.Notes"),
        "story_points": fields.get("Microsoft.VSTS.Scheduling.StoryPoints"),
        "work_type": fields.get("AAIT.WorkType"),
        "assigned_to": assigned,
        "area_path": fields.get("System.AreaPath"),
        "iteration_path": fields.get("System.IterationPath"),
        "tags": fields.get("System.Tags"),
        "parent_id": fields.get("System.Parent"),
        "url": wi.get("url"),
    }

    if include_relations and wi.get("relations"):
        children = []
        related = []
        parent = None
        for rel in wi["relations"]:
            rel_type = rel.get("rel", "")
            item_id = _extract_id_from_url(rel.get("url", ""))
            if rel_type == "System.LinkTypes.Hierarchy-Forward":
                if item_id:
                    children.append(item_id)
            elif rel_type == "System.LinkTypes.Hierarchy-Reverse":
                parent = item_id
            elif rel_type == "System.LinkTypes.Related":
                if item_id:
                    related.append(item_id)
        result["children"] = children
        result["parent_id"] = parent or result["parent_id"]
        result["related"] = related

    return result


def fetch_work_item(
    client: AdoClient,
    item_id: int,
    include_relations: bool = True,
) -> dict[str, Any]:
    """Fetch a single work item by ID."""
    wi = client.get_work_item(item_id, expand="All")
    return work_item_to_dict(wi, include_relations=include_relations)


def fetch_work_items_batch(
    client: AdoClient,
    ids: list[int],
    include_relations: bool = True,
) -> list[dict[str, Any]]:
    """Fetch multiple work items by IDs."""
    if not ids:
        return []
    results = []
    for i in range(0, len(ids), 200):
        batch = ids[i:i+200]
        wis = client.get_work_items(batch, expand="All")
        for wi in wis:
            results.append(work_item_to_dict(wi, include_relations=include_relations))
    return results


def create_user_story(
    client: AdoClient,
    story: UserStoryInput,
    project: str = DEFAULT_PROJECT,
    team: str = "Muscle Shoals",
) -> dict[str, Any]:
    """Push a validated User Story to ADO. Returns created item dict.

    If story.iteration_path is None, auto-resolves the current iteration
    for the given project/team and injects it.
    """
    validation = story.validate_for_push()
    if not validation.ok:
        raise ValueError(f"Validation failed: {validation.errors}")

    # Auto-resolve iteration if not explicitly set
    if not story.iteration_path:
        current_iter = fetch_current_iteration(client, project, team)
        if current_iter:
            story = story.model_copy(update={"iteration_path": current_iter["path"]})

    ops = story.to_patch_operations()
    wi = client.create_work_item(project=project, wit_type="User Story", operations=ops)
    return work_item_to_dict(wi, include_relations=True)


def update_work_item(
    client: AdoClient,
    item_id: int,
    updates: dict[str, Any],
    project: str = DEFAULT_PROJECT,
) -> dict[str, Any]:
    """Update fields on an existing work item."""
    field_map = {
        "title": "/fields/System.Title",
        "description": "/fields/System.Description",
        "acceptance_criteria": "/fields/Microsoft.VSTS.Common.AcceptanceCriteria",
        "notes": "/fields/AAIT.Notes",
        "story_points": "/fields/Microsoft.VSTS.Scheduling.StoryPoints",
        "work_type": "/fields/AAIT.WorkType",
        "assigned_to": "/fields/System.AssignedTo",
        "state": "/fields/System.State",
        "area_path": "/fields/System.AreaPath",
        "iteration_path": "/fields/System.IterationPath",
        "tags": "/fields/System.Tags",
    }
    document = []
    for key, value in updates.items():
        path = field_map.get(key)
        if path:
            document.append({"op": "add", "path": path, "value": value})

    if not document:
        raise ValueError("No valid fields to update")

    wi = client.update_work_item(item_id=item_id, operations=document, project=project)
    return work_item_to_dict(wi)


def link_work_items(
    client: AdoClient,
    source_id: int,
    target_id: int,
    link_type: str = "parent",
    project: str = DEFAULT_PROJECT,
) -> dict[str, Any]:
    """Link two work items. link_type: parent, child, related."""
    rel_types = {
        "parent": "System.LinkTypes.Hierarchy-Reverse",
        "child": "System.LinkTypes.Hierarchy-Forward",
        "related": "System.LinkTypes.Related",
    }
    rel = rel_types.get(link_type)
    if not rel:
        raise ValueError(f"Unknown link_type: {link_type}. Use: {list(rel_types.keys())}")

    document = [{
        "op": "add",
        "path": "/relations/-",
        "value": {
            "rel": rel,
            "url": f"{ORG_URL}/_apis/wit/workItems/{target_id}",
        },
    }]
    wi = client.update_work_item(item_id=source_id, operations=document, project=project)
    return work_item_to_dict(wi)


def _iteration_to_dict(it: dict[str, Any]) -> dict[str, Any]:
    """Normalize an ADO iteration API entry to a flat dict."""
    attrs = it.get("attributes", {})
    return {
        "id": it.get("id"),
        "name": it.get("name"),
        "path": it.get("path"),
        "start_date": (attrs.get("startDate") or "")[:10],   # YYYY-MM-DD
        "finish_date": (attrs.get("finishDate") or "")[:10],
    }


def fetch_current_iteration(
    client: AdoClient,
    project: str = DEFAULT_PROJECT,
    team: str = "Muscle Shoals",
) -> dict[str, Any] | None:
    """Fetch the current iteration for a team.

    Returns dict with id, name, path, start_date, finish_date, or None if
    no current iteration is configured.
    """
    resp = client._api(
        f"{project}/{team}/_apis/work/teamsettings/iterations",
        params={"$timeframe": "current"},
    )
    iterations = resp.get("value", [])
    if not iterations:
        return None
    return _iteration_to_dict(iterations[0])


def fetch_next_iteration(
    client: AdoClient,
    project: str = DEFAULT_PROJECT,
    team: str = "Muscle Shoals",
) -> dict[str, Any] | None:
    """Fetch the iteration immediately following the current one.

    Returns dict with id, name, path, start_date, finish_date, or None if
    there is no current iteration or no iteration scheduled after it.
    """
    current = fetch_current_iteration(client, project, team)
    if not current:
        return None
    # Full ordered iteration list for the team (no timeframe filter).
    resp = client._api(f"{project}/{team}/_apis/work/teamsettings/iterations")
    iterations = resp.get("value", [])
    ids = [it.get("id") for it in iterations]
    try:
        idx = ids.index(current["id"])
    except ValueError:
        return None
    if idx + 1 >= len(iterations):
        return None
    return _iteration_to_dict(iterations[idx + 1])


def fetch_my_items(
    client: AdoClient,
    project: str = DEFAULT_PROJECT,
    team: str = "Muscle Shoals",
    assigned_to: str = "Yun, Jonghyun",
    tag: str | None = None,
) -> list[dict[str, Any]]:
    """Fetch work items assigned to a user in the current iteration.

    If TAG is given, only items whose System.Tags contains it are returned.
    """
    tag_clause = f"AND [System.Tags] CONTAINS '{tag}' " if tag else ""
    query = (
        "SELECT [System.Id] FROM workitems "
        "WHERE [System.WorkItemType] = 'User Story' "
        f"AND [System.AssignedTo] = '{assigned_to}' "
        "AND [System.IterationPath] = @CurrentIteration "
        f"AND [System.TeamProject] = '{project}' "
        f"{tag_clause}"
        "ORDER BY [System.ChangedDate] DESC"
    )
    result = client.query_wiql(query, project=project, team=team)
    ids = [wi["id"] for wi in (result.get("workItems") or [])]
    return fetch_work_items_batch(client, ids)


def fetch_children(
    client: AdoClient,
    parent_id: int,
) -> list[dict[str, Any]]:
    """Fetch all child work items of a parent."""
    parent = fetch_work_item(client, parent_id, include_relations=True)
    child_ids = parent.get("children", [])
    if not child_ids:
        return []
    return fetch_work_items_batch(client, child_ids)

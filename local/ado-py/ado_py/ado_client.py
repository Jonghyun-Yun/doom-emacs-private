"""Auth + REST client for Azure DevOps. Uses requests directly (no azure-devops SDK)."""
from __future__ import annotations

import os
from pathlib import Path
from typing import Any, Optional
import requests

ENV_FILE = Path.home() / "Dropbox" / "emacs" / ".doom.d" / ".local.env"
ORG_URL = "https://dev.azure.com/americanairlines"
API_VERSION = "7.1"


class AdoError(Exception):
    """Base error for ADO client failures with a classified kind."""

    def __init__(self, message: str, kind: str = "unknown"):
        super().__init__(message)
        self.kind = kind  # one of: auth, permission, network, notfound, api, unknown


class AdoAuthError(AdoError):
    def __init__(self, message: str):
        super().__init__(message, kind="auth")


class AdoPermissionError(AdoError):
    def __init__(self, message: str):
        super().__init__(message, kind="permission")


class AdoNetworkError(AdoError):
    def __init__(self, message: str):
        super().__init__(message, kind="network")


def load_env_file(path: str | Path = ENV_FILE) -> None:
    """Load KEY=VALUE lines from env file into os.environ."""
    p = Path(path)
    if not p.exists():
        return
    for line in p.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if "=" in line:
            key, _, value = line.partition("=")
            os.environ.setdefault(key.strip(), value.strip())


def get_session() -> requests.Session:
    """Return an authenticated requests.Session for ADO REST API.

    Strategy:
    1. PAT from ADO_PAT env var → Basic auth
    2. Fallback → azure.identity.DefaultAzureCredential → Bearer token
    """
    load_env_file()
    session = requests.Session()

    pat = os.environ.get("ADO_PAT")
    if pat:
        session.auth = ("", pat)
        return session

    # Fallback: az login / managed identity
    try:
        from azure.identity import DefaultAzureCredential
        cred = DefaultAzureCredential()
        token = cred.get_token("499b84ac-1321-427f-aa17-267ca6975798/.default")
    except Exception as e:
        raise AdoAuthError(
            "No ADO_PAT set and Azure credential lookup failed. "
            f"Set ADO_PAT or run 'az login'. Details: {e}"
        ) from e
    session.headers["Authorization"] = f"Bearer {token.token}"
    return session


class AdoClient:
    """Lightweight ADO REST API client."""

    def __init__(self, org_url: str = ORG_URL, session: Optional[requests.Session] = None):
        self.org_url = org_url.rstrip("/")
        self.session = session or get_session()

    def _api(self, path: str, method: str = "GET",
             json_body: Any = None, params: Optional[dict] = None,
             content_type: str = "application/json") -> Any:
        """Make an API call and return JSON response."""
        url = f"{self.org_url}/{path}"
        p = {"api-version": API_VERSION}
        if params:
            p.update(params)

        headers = {}
        if content_type == "application/json-patch+json":
            headers["Content-Type"] = "application/json-patch+json"

        try:
            resp = self.session.request(
                method, url, json=json_body, params=p, headers=headers
            )
        except requests.exceptions.RequestException as e:
            raise AdoNetworkError(
                f"Network error contacting Azure DevOps: {e}"
            ) from e

        if resp.status_code >= 400:
            self._raise_for_status(resp)
        return resp.json() if resp.content else {}

    @staticmethod
    def _raise_for_status(resp: requests.Response) -> None:
        """Classify an HTTP error response into a specific AdoError."""
        status = resp.status_code
        try:
            body = resp.json()
            msg = body.get("message") or body.get("value", {}).get("Message") or resp.text
        except Exception:
            msg = resp.text or ""
        lower = (msg or "").lower()

        # Tag creation permission: ADO returns 403 (sometimes 401) with a
        # message mentioning tag definition create permission.
        tag_perm = (
            "tagdefinition" in lower
            or ("tag" in lower and "permission" in lower)
            or ("create" in lower and "tag" in lower)
        )
        if status == 401:
            raise AdoAuthError(
                f"Authentication failed (HTTP 401). Check your ADO_PAT / az login. Details: {msg}"
            )
        if status == 403:
            if tag_perm:
                raise AdoPermissionError(
                    "Tag creation denied: you lack permission to create a NEW tag. "
                    "The tag likely does not exist yet. Use an existing tag, or fix a possible "
                    f"typo. Details: {msg}"
                )
            raise AdoPermissionError(
                f"Permission denied (HTTP 403). Details: {msg}"
            )
        if status == 404:
            raise AdoError(f"Not found (HTTP 404). Details: {msg}", kind="notfound")
        raise AdoError(f"Azure DevOps API error (HTTP {status}). Details: {msg}", kind="api")

    # ── Work Items ──────────────────────────────────────────────────

    def get_work_item(self, item_id: int, expand: str = "All",
                      project: Optional[str] = None) -> dict[str, Any]:
        """GET a single work item."""
        prefix = f"{project}/" if project else ""
        return self._api(f"{prefix}_apis/wit/workItems/{item_id}",
                         params={"$expand": expand})

    def get_work_items(self, ids: list[int], expand: str = "All",
                       project: Optional[str] = None) -> list[dict[str, Any]]:
        """GET multiple work items (max 200 per call)."""
        prefix = f"{project}/" if project else ""
        id_str = ",".join(str(i) for i in ids)
        resp = self._api(f"{prefix}_apis/wit/workItems",
                         params={"ids": id_str, "$expand": expand})
        return resp.get("value", [])

    def create_work_item(self, project: str, wit_type: str,
                         operations: list[dict]) -> dict[str, Any]:
        """POST to create a work item using JSON Patch."""
        path = f"{project}/_apis/wit/workItems/${wit_type}"
        return self._api(path, method="POST", json_body=operations,
                         content_type="application/json-patch+json")

    def update_work_item(self, item_id: int, operations: list[dict],
                         project: Optional[str] = None) -> dict[str, Any]:
        """PATCH to update a work item using JSON Patch."""
        prefix = f"{project}/" if project else ""
        return self._api(f"{prefix}_apis/wit/workItems/{item_id}",
                         method="PATCH", json_body=operations,
                         content_type="application/json-patch+json")

    def query_wiql(self, query: str, project: str,
                   team: Optional[str] = None) -> dict[str, Any]:
        """POST a WIQL query."""
        prefix = f"{project}/{team}/" if team else f"{project}/"
        return self._api(f"{prefix}_apis/wit/wiql",
                         method="POST",
                         json_body={"query": query})

    def list_tags(self, project: str) -> list[str]:
        """List existing tag names for a project."""
        resp = self._api(f"{project}/_apis/wit/tags")
        return [t.get("name") for t in resp.get("value", []) if t.get("name")]

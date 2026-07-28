"""Tests for work item fetch/push operations (mocked REST client)."""
import pytest
from unittest.mock import MagicMock, patch
from ado_py.models import UserStoryInput
from ado_py.ado_client import AdoClient
from ado_py.work_items import (
    fetch_work_item,
    create_user_story,
    fetch_my_items,
    work_item_to_dict,
    fetch_children,
    fetch_current_iteration,
)


def _mock_wi_response(item_id=42, title="Test Story", state="Backlog"):
    return {
        "id": item_id,
        "fields": {
            "System.Title": title,
            "System.State": state,
            "System.Description": "<p>desc</p>",
            "Microsoft.VSTS.Common.AcceptanceCriteria": "<p>ac</p>",
            "AAIT.Notes": "<p>notes</p>",
            "Microsoft.VSTS.Scheduling.StoryPoints": 2,
            "AAIT.WorkType": "4. Software / UX",
            "System.AssignedTo": {"displayName": "Yun, Jonghyun"},
            "System.AreaPath": "OperationsResearch_AdvancedAnalytics\\Muscle Shoals",
            "System.IterationPath": "ORAA\\Sprint 10",
            "System.WorkItemType": "User Story",
            "System.Parent": 100,
        },
        "relations": [
            {"rel": "System.LinkTypes.Hierarchy-Forward", "url": "https://dev.azure.com/x/_apis/wit/workItems/201"},
            {"rel": "System.LinkTypes.Hierarchy-Reverse", "url": "https://dev.azure.com/x/_apis/wit/workItems/100"},
        ],
        "url": f"https://dev.azure.com/x/_apis/wit/workItems/{item_id}",
    }


class TestFetchWorkItem:
    def test_fetch_returns_dict(self):
        client = MagicMock(spec=AdoClient)
        client.get_work_item.return_value = _mock_wi_response()
        result = fetch_work_item(client, 42)
        assert result["id"] == 42
        assert result["title"] == "Test Story"
        assert result["children"] == [201]
        assert result["parent_id"] == 100
        client.get_work_item.assert_called_once_with(42, expand="All")


class TestWorkItemToDict:
    def test_extracts_fields(self):
        d = work_item_to_dict(_mock_wi_response(), include_relations=True)
        assert d["id"] == 42
        assert d["title"] == "Test Story"
        assert d["state"] == "Backlog"
        assert d["story_points"] == 2
        assert d["assigned_to"] == "Yun, Jonghyun"
        assert d["children"] == [201]
        assert d["parent_id"] == 100


class TestCreateUserStory:
    def test_create_calls_client(self):
        client = MagicMock(spec=AdoClient)
        client.org_url = "https://dev.azure.com/americanairlines"
        # Mock _api for iteration lookup
        client._api.return_value = {"value": []}
        # Mock create
        client.create_work_item.return_value = _mock_wi_response(item_id=99)

        story = UserStoryInput(
            title="New Story", description="<p>D</p>",
            acceptance_criteria="<p>AC</p>", parent_id=50,
        )
        result = create_user_story(client, story, project="P", team="T")
        assert result["id"] == 99
        client.create_work_item.assert_called_once()
        ops = client.create_work_item.call_args.kwargs["operations"]
        paths = [op["path"] for op in ops]
        assert "/fields/System.Title" in paths


class TestFetchMyItems:
    def test_returns_list(self):
        client = MagicMock(spec=AdoClient)
        client.query_wiql.return_value = {"workItems": [{"id": 42}]}
        client.get_work_items.return_value = [_mock_wi_response()]

        items = fetch_my_items(client)
        assert len(items) == 1
        assert items[0]["id"] == 42


class TestFetchChildren:
    def test_returns_children(self):
        client = MagicMock(spec=AdoClient)
        parent = _mock_wi_response(item_id=100)
        parent["relations"] = [
            {"rel": "System.LinkTypes.Hierarchy-Forward", "url": "https://x/_apis/wit/workItems/201"},
            {"rel": "System.LinkTypes.Hierarchy-Forward", "url": "https://x/_apis/wit/workItems/202"},
        ]
        client.get_work_item.return_value = parent
        client.get_work_items.return_value = [
            _mock_wi_response(item_id=201),
            _mock_wi_response(item_id=202),
        ]
        results = fetch_children(client, 100)
        assert len(results) == 2
        assert results[0]["id"] == 201

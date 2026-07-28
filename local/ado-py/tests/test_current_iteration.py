"""Tests for current-iteration fetch and auto-injection into create."""
import pytest
from unittest.mock import MagicMock, patch
from ado_py.ado_client import AdoClient
from ado_py.work_items import fetch_current_iteration, create_user_story
from ado_py.models import UserStoryInput


class TestFetchCurrentIteration:
    """Unit tests for fetch_current_iteration (mocked HTTP)."""

    def _mock_client(self, response: dict) -> AdoClient:
        client = MagicMock(spec=AdoClient)
        client._api.return_value = response
        client.org_url = "https://dev.azure.com/americanairlines"
        return client

    def test_returns_current_iteration_path(self):
        client = self._mock_client({
            "value": [{
                "id": "abc-123",
                "name": "2Q26 - Iteration 4 (05.18-05.29)",
                "path": "OperationsResearch_AdvancedAnalytics\\Muscle Shoals\\2026\\Q2 2026\\2Q26 - Iteration 4 (05.18-05.29)",
                "attributes": {
                    "startDate": "2026-05-18T00:00:00Z",
                    "finishDate": "2026-05-29T00:00:00Z",
                    "timeFrame": "current",
                },
            }]
        })
        result = fetch_current_iteration(client, "OperationsResearch_AdvancedAnalytics", "Muscle Shoals")
        assert result["path"] == "OperationsResearch_AdvancedAnalytics\\Muscle Shoals\\2026\\Q2 2026\\2Q26 - Iteration 4 (05.18-05.29)"
        assert result["name"] == "2Q26 - Iteration 4 (05.18-05.29)"

    def test_returns_start_and_finish_dates(self):
        client = self._mock_client({
            "value": [{
                "id": "abc-123",
                "name": "Iter 1",
                "path": "Proj\\Team\\Iter 1",
                "attributes": {
                    "startDate": "2026-05-18T00:00:00Z",
                    "finishDate": "2026-05-29T00:00:00Z",
                    "timeFrame": "current",
                },
            }]
        })
        result = fetch_current_iteration(client, "Proj", "Team")
        assert result["start_date"] == "2026-05-18"
        assert result["finish_date"] == "2026-05-29"

    def test_returns_none_when_no_current_iteration(self):
        client = self._mock_client({"value": []})
        result = fetch_current_iteration(client, "Proj", "Team")
        assert result is None

    def test_api_called_with_correct_path(self):
        client = self._mock_client({"value": []})
        fetch_current_iteration(client, "MyProject", "MyTeam")
        client._api.assert_called_once_with(
            "MyProject/MyTeam/_apis/work/teamsettings/iterations",
            params={"$timeframe": "current"},
        )


class TestCreateAutoIteration:
    """Create should auto-inject iteration_path when not provided."""

    def test_create_sets_iteration_path_from_current(self):
        """When iteration_path is None, create_user_story fetches and injects it."""
        client = MagicMock(spec=AdoClient)
        client.org_url = "https://dev.azure.com/americanairlines"

        # Mock _api for iteration lookup
        iter_response = {
            "value": [{
                "id": "x",
                "name": "Iter 4",
                "path": "ORAA\\MS\\2026\\Q2\\Iter 4",
                "attributes": {
                    "startDate": "2026-05-18T00:00:00Z",
                    "finishDate": "2026-05-29T00:00:00Z",
                    "timeFrame": "current",
                },
            }]
        }
        client._api.return_value = iter_response

        # Mock create_work_item
        created_wi = {
            "id": 999,
            "fields": {
                "System.Title": "T",
                "System.State": "Backlog",
                "System.IterationPath": "ORAA\\MS\\2026\\Q2\\Iter 4",
            },
            "relations": [],
        }
        client.create_work_item.return_value = created_wi

        story = UserStoryInput(
            title="T", description="D", acceptance_criteria="AC", parent_id=1,
        )
        assert story.iteration_path is None

        result = create_user_story(client, story, project="ORAA", team="MS")
        assert result["iteration_path"] == "ORAA\\MS\\2026\\Q2\\Iter 4"
        # Verify iteration was looked up
        client._api.assert_called_once()
        # Verify create included iteration_path in operations
        ops = client.create_work_item.call_args.kwargs.get("operations") or client.create_work_item.call_args[1].get("operations", [])
        iter_ops = [op for op in ops if op.get("path") == "/fields/System.IterationPath"]
        assert len(iter_ops) == 1
        assert iter_ops[0]["value"] == "ORAA\\MS\\2026\\Q2\\Iter 4"

    def test_create_preserves_explicit_iteration_path(self):
        """When iteration_path is explicitly set, don't override it."""
        client = MagicMock(spec=AdoClient)
        client.org_url = "https://dev.azure.com/americanairlines"

        created_wi = {
            "id": 888,
            "fields": {
                "System.Title": "T",
                "System.State": "Backlog",
                "System.IterationPath": "Explicit\\Path",
            },
            "relations": [],
        }
        client.create_work_item.return_value = created_wi

        story = UserStoryInput(
            title="T", description="D", acceptance_criteria="AC",
            parent_id=1, iteration_path="Explicit\\Path",
        )
        result = create_user_story(client, story, project="P", team="T")
        # Should NOT call _api for iteration since iteration_path is set
        # (create_work_item is called directly, not _api for iteration)
        assert result["iteration_path"] == "Explicit\\Path"

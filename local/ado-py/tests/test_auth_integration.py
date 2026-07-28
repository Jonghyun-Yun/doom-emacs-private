"""Integration test: real auth against ADO (REST client)."""
import pytest
from ado_py.ado_client import AdoClient, load_env_file
from ado_py.work_items import fetch_work_item, fetch_my_items, fetch_current_iteration


@pytest.fixture(autouse=True)
def _load_env():
    load_env_file()


class TestRealAuth:
    def test_pat_connects_and_fetches(self):
        """PAT from .local.env can reach ADO and fetch a work item."""
        client = AdoClient()
        result = fetch_work_item(client, 2655846)
        assert result["id"] == 2655846
        assert result["title"] is not None

    def test_fetch_my_items_runs(self):
        """WIQL query executes without error."""
        client = AdoClient()
        items = fetch_my_items(client)
        assert isinstance(items, list)
        for item in items[:3]:
            assert "id" in item
            assert "title" in item
            print(f"  #{item['id']}: {item['title']}")

    def test_current_iteration(self):
        """Current iteration is fetched with path and dates."""
        client = AdoClient()
        result = fetch_current_iteration(client)
        assert result is not None
        assert "path" in result
        assert "finish_date" in result
        assert "start_date" in result
        print(f"  Current iteration: {result['name']} ({result['start_date']} → {result['finish_date']})")

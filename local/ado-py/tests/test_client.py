"""Tests for auth client logic (REST-based)."""
import os
import pytest
from unittest.mock import patch, MagicMock
from ado_py.ado_client import get_session, load_env_file, AdoClient
from azure.identity import DefaultAzureCredential


class TestLoadEnvFile:
    def test_load_env_file_sets_vars(self, tmp_path):
        env_file = tmp_path / ".local.env"
        env_file.write_text("TEST_ADO_VAR=test-val-123\nOTHER_VAR=hello\n# comment\n")
        with patch.dict(os.environ, {}, clear=False):
            os.environ.pop("TEST_ADO_VAR", None)
            os.environ.pop("OTHER_VAR", None)
            load_env_file(str(env_file))
            assert os.environ.get("TEST_ADO_VAR") == "test-val-123"
            assert os.environ.get("OTHER_VAR") == "hello"

    def test_load_env_file_missing_no_error(self):
        load_env_file("/nonexistent/.local.env")


class TestGetSession:
    def test_pat_auth(self):
        with patch.dict(os.environ, {"ADO_PAT": "my-pat"}):
            session = get_session()
            assert session.auth == ("", "my-pat")

    def test_fallback_to_azure_identity(self):
        with patch.dict(os.environ, {}, clear=True), \
             patch("ado_py.ado_client.load_env_file"), \
             patch("azure.identity.DefaultAzureCredential") as mock_cred:
            os.environ.pop("ADO_PAT", None)
            mock_token = MagicMock()
            mock_token.token = "fake-bearer-token"
            mock_cred.return_value.get_token.return_value = mock_token
            session = get_session()
            assert "Authorization" in session.headers
            assert session.headers["Authorization"] == "Bearer fake-bearer-token"


class TestAdoClient:
    def test_client_creation(self):
        with patch.dict(os.environ, {"ADO_PAT": "fake-pat"}):
            client = AdoClient()
            assert client.org_url == "https://dev.azure.com/americanairlines"
            assert client.session is not None

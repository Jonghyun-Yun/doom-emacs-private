"""Tests for UserStory guardrail validation (TDD)."""
import pytest
from ado_py.models import UserStoryInput, ValidationResult


class TestUserStoryInputDefaults:
    """Default values are applied correctly."""

    def test_defaults_applied(self):
        s = UserStoryInput(
            title="Do something",
            description="<p>Details</p>",
            acceptance_criteria="<p>AC</p>",
            parent_id=100,
        )
        assert s.story_points == 1
        assert s.work_type == "4. Software / UX"
        assert s.assigned_to == "Yun, Jonghyun"
        assert s.area_path == "OperationsResearch_AdvancedAnalytics\\Muscle Shoals"
        assert s.state == "Backlog"

    def test_override_defaults(self):
        s = UserStoryInput(
            title="T", description="D", acceptance_criteria="AC",
            parent_id=1, story_points=3, work_type="1. Operational",
            assigned_to="Someone Else",
            area_path="Other\\Path",
            state="Defined",
        )
        assert s.story_points == 3
        assert s.work_type == "1. Operational"
        assert s.state == "Defined"


class TestUserStoryInputValidation:
    """Guardrails reject incomplete stories."""

    def test_missing_title_raises(self):
        with pytest.raises(Exception):
            UserStoryInput(
                title="", description="D", acceptance_criteria="AC", parent_id=1,
            )

    def test_missing_description_raises(self):
        with pytest.raises(Exception):
            UserStoryInput(
                title="T", description="", acceptance_criteria="AC", parent_id=1,
            )

    def test_missing_acceptance_criteria_raises(self):
        with pytest.raises(Exception):
            UserStoryInput(
                title="T", description="D", acceptance_criteria="", parent_id=1,
            )

    def test_missing_parent_id_raises(self):
        with pytest.raises(Exception):
            UserStoryInput(
                title="T", description="D", acceptance_criteria="AC",
                parent_id=None,
            )

    def test_invalid_state_raises(self):
        with pytest.raises(Exception):
            UserStoryInput(
                title="T", description="D", acceptance_criteria="AC",
                parent_id=1, state="InvalidState",
            )

    def test_story_points_must_be_positive(self):
        with pytest.raises(Exception):
            UserStoryInput(
                title="T", description="D", acceptance_criteria="AC",
                parent_id=1, story_points=0,
            )


class TestValidationResult:
    """Validate method returns structured errors."""

    def test_valid_story(self):
        s = UserStoryInput(
            title="T", description="D", acceptance_criteria="AC", parent_id=1,
        )
        result = s.validate_for_push()
        assert result.ok is True
        assert result.errors == []

    def test_to_patch_operations(self):
        s = UserStoryInput(
            title="T", description="D", acceptance_criteria="AC", parent_id=1,
        )
        ops = s.to_patch_operations()
        paths = [op["path"] for op in ops]
        assert "/fields/System.Title" in paths
        assert "/fields/System.Description" in paths
        assert "/fields/Microsoft.VSTS.Common.AcceptanceCriteria" in paths
        assert "/fields/Microsoft.VSTS.Scheduling.StoryPoints" in paths
        assert "/fields/AAIT.WorkType" in paths
        assert "/fields/System.AreaPath" in paths
        assert "/fields/System.AssignedTo" in paths
        assert "/fields/System.State" in paths
        # Parent link
        parent_ops = [op for op in ops if op["path"] == "/relations/-"]
        assert len(parent_ops) == 1
        assert "Hierarchy-Reverse" in parent_ops[0]["value"]["rel"]

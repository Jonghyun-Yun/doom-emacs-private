"""Pydantic models for User Story guardrail validation."""
from __future__ import annotations

from dataclasses import dataclass
from typing import Any, Optional

from pydantic import BaseModel, Field, field_validator, model_validator

VALID_STATES = ("Backlog", "Defined", "In-Progress", "Completed", "Accepted")

ORG_TO_ADO_STATE = {
    "BKLG": "Backlog",
    "DEFN": "Defined",
    "PROG": "In-Progress",
    "CMPL": "Completed",
    "ACPT": "Accepted",
}

ADO_TO_ORG_STATE = {v: k for k, v in ORG_TO_ADO_STATE.items()}

# Defaults
DEFAULT_PROJECT = "OperationsResearch_AdvancedAnalytics"
DEFAULT_TEAM = "Muscle Shoals"
DEFAULT_AREA_PATH = f"{DEFAULT_PROJECT}\\{DEFAULT_TEAM}"
DEFAULT_ASSIGNED_TO = "Yun, Jonghyun"
DEFAULT_WORK_TYPE = "4. Software / UX"
DEFAULT_STORY_POINTS = 1
DEFAULT_STATE = "Backlog"
ORG_URL = "https://dev.azure.com/americanairlines"


@dataclass
class ValidationResult:
    ok: bool
    errors: list[str]


class UserStoryInput(BaseModel):
    """Validated User Story ready for ADO push.

    Acts as a guardrail: refuses construction if required fields are
    missing or invalid. The LLM must provide all required content
    before this model will accept it.
    """

    title: str = Field(..., min_length=1)
    description: str = Field(..., min_length=1)
    acceptance_criteria: str = Field(..., min_length=1)
    parent_id: int = Field(..., gt=0)
    story_points: int = Field(default=DEFAULT_STORY_POINTS, gt=0)
    work_type: str = Field(default=DEFAULT_WORK_TYPE)
    assigned_to: str = Field(default=DEFAULT_ASSIGNED_TO)
    area_path: str = Field(default=DEFAULT_AREA_PATH)
    state: str = Field(default=DEFAULT_STATE)
    iteration_path: Optional[str] = None
    notes: Optional[str] = None
    tags: Optional[str] = None  # ADO System.Tags, semicolon-separated existing tags

    @field_validator("state")
    @classmethod
    def validate_state(cls, v: str) -> str:
        # Accept org keywords too
        if v in ORG_TO_ADO_STATE:
            return ORG_TO_ADO_STATE[v]
        if v not in VALID_STATES:
            raise ValueError(
                f"Invalid state \'{v}\'. Must be one of {VALID_STATES} "
                f"or org keywords {list(ORG_TO_ADO_STATE.keys())}"
            )
        return v

    def validate_for_push(self) -> ValidationResult:
        """Extra business-rule checks beyond pydantic field validation."""
        errors: list[str] = []
        # All pydantic checks already passed if we got here.
        # Add any soft warnings as needed.
        return ValidationResult(ok=len(errors) == 0, errors=errors)

    def to_patch_operations(self) -> list[dict[str, Any]]:
        """Convert to ADO JsonPatchOperation dicts."""
        ops = [
            {"op": "add", "path": "/fields/System.Title", "value": self.title},
            {"op": "add", "path": "/fields/System.Description", "value": self.description},
            {"op": "add", "path": "/fields/Microsoft.VSTS.Common.AcceptanceCriteria", "value": self.acceptance_criteria},
            {"op": "add", "path": "/fields/Microsoft.VSTS.Scheduling.StoryPoints", "value": self.story_points},
            {"op": "add", "path": "/fields/AAIT.WorkType", "value": self.work_type},
            {"op": "add", "path": "/fields/System.AreaPath", "value": self.area_path},
            {"op": "add", "path": "/fields/System.AssignedTo", "value": self.assigned_to},
            {"op": "add", "path": "/fields/System.State", "value": self.state},
        ]
        if self.iteration_path:
            ops.append({"op": "add", "path": "/fields/System.IterationPath", "value": self.iteration_path})
        if self.notes:
            ops.append({"op": "add", "path": "/fields/AAIT.Notes", "value": self.notes})
        if self.tags:
            ops.append({"op": "add", "path": "/fields/System.Tags", "value": self.tags})
        # Parent link
        ops.append({
            "op": "add",
            "path": "/relations/-",
            "value": {
                "rel": "System.LinkTypes.Hierarchy-Reverse",
                "url": f"{ORG_URL}/_apis/wit/workItems/{self.parent_id}",
            },
        })
        return ops

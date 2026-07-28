# ado-py — Standalone ADO User Story Module

## Purpose

Deterministic Python module for auth → fetch → validate → push User Stories
to Azure DevOps. Designed as the programmatic backend for `ado-org.el`,
called via `shell-command` / `call-process` from Emacs gptel workflows.

The LLM generates content (title, description, acceptance criteria).
This module handles everything else deterministically: authentication,
guardrail validation, API calls.

## Architecture

```
~/.doom.d/local/ado-py/
├── PLAN.md              ← this file
├── ado_client.py        ← auth (PAT → az login fallback)
├── models.py            ← UserStory pydantic model + guardrails
├── work_items.py        ← fetch / create / update operations
├── cli.py               ← CLI entry point (JSON stdin/stdout)
├── tests/
│   ├── __init__.py
│   ├── test_models.py   ← guardrail validation tests
│   ├── test_client.py   ← auth logic tests
│   └── test_work_items.py ← fetch/push tests (mocked)
└── __init__.py
```

## Auth Strategy

1. **PAT** (primary): Read `ADO_PAT` from env. Load
   `~/Dropbox/emacs/.doom.d/.local.env` if present.
2. **az login** (fallback): Use `azure.identity.DefaultAzureCredential`
   → `AzureCliCredential` chain when PAT is absent.

## Guardrails (User Story)

Required fields — module refuses to push if any are missing/empty:

| Field | ADO Reference Name | Default |
|-------|-------------------|---------|
| Title | `System.Title` | — (required, no default) |
| Description | `System.Description` | — (required, no default) |
| Acceptance Criteria | `Microsoft.VSTS.Common.AcceptanceCriteria` | — (required, no default) |
| Story Points | `Microsoft.VSTS.Scheduling.StoryPoints` | `1` |
| Work Type | `AAIT.WorkType` | `4. Software / UX` |
| Area Path | `System.AreaPath` | `{project}\{team}` |
| Assigned To | `System.AssignedTo` | `Yun, Jonghyun` |
| Parent Feature ID | parent link | — (required, no default) |

Validation errors return structured JSON so the caller (gptel/elisp)
knows exactly which fields are missing.

## CLI Interface

```bash
# Validate a story (dry-run, no push)
echo '{"title": "...", ...}' | mamba run -n gptel python -m ado_py.cli validate

# Create a story
echo '{"title": "...", ...}' | mamba run -n gptel python -m ado_py.cli create

# Fetch a work item
mamba run -n gptel python -m ado_py.cli fetch --id 12345

# Fetch my work items (current iteration)
mamba run -n gptel python -m ado_py.cli my-items
```

All output is JSON to stdout. Errors to stderr.

## ADO Org Defaults

- Organization: `americanairlines`
- Org URL: `https://dev.azure.com/americanairlines`
- Project: `OperationsResearch_AdvancedAnalytics`
- Team: `Muscle Shoals`
- Area Path: `OperationsResearch_AdvancedAnalytics\Muscle Shoals`

## Required Fields (from ADO schema, `alwaysRequired: true`)

- `System.Title`
- `System.State` (default: Backlog)
- `Microsoft.VSTS.Scheduling.StoryPoints`
- `AAIT.WorkType`
- `Microsoft.VSTS.Common.ValueArea` (default: Business)

## State Mapping

| Org Keyword | ADO State |
|-------------|-----------|
| BKLG | Backlog |
| DEFN | Defined |
| PROG | In-Progress |
| CMPL | Completed |
| ACPT | Accepted |

## Dependencies

- `azure-devops` (SDK)
- `azure-identity` (fallback auth)
- `pydantic` (validation)
- All already in mamba env `gptel`.

## Emacs Integration

`ado-org.el` calls this module via `call-process` or `shell-command`.
The flow:

1. gptel LLM generates story content → populates org heading
2. `ado/heading-context` extracts structured data from heading
3. Elisp serializes to JSON, pipes to `ado_py.cli create`
4. Module validates (guardrails), pushes to ADO, returns `{id: 12345}`
5. Elisp sets `:ADO_ID:` property on the heading

# Task checkpoint contract

Location: <project>/.agent-runs/YYYYMMDD-HHMMSS-<slug>-<short-id>/checkpoint.md. Use portable alphanumeric and hyphen characters; keep the task ID stable across versions and platforms. This directory is untracked temporary state, never a Git deliverable.

The single checkpoint.md is authoritative for current state. Start it with exact single-line fields Task ID: <directory name> and Phase: NEW | DISCOVERY | PLAN_READY | APPROVED | GIT_PREP | IMPLEMENTING | REVIEW_READY | REVIEW_DECISION | FIXING | BLOCKED | PAUSED | COMPLETE | CANCELLED. Record original request, project path, mode, next action, confirmed decisions and open questions, current plan version/status/path/fingerprint, approval message and source session, branch/default branch/pull outcome, diff baseline, review count (0..3), open finding IDs, key validation results, and last update time with zone. Do not store credentials, full logs, or duplicate full conversation history.

Keep the complete versioned plan in a separate file in this task directory; preserve the exact approved content through implementation and review. Optional reviews/round-N.md files hold detailed findings or evidence when needed. The checkpoint points to them. Use one state file rather than one per role or phase.

On every resume, inspect the actual project and compare it with checkpoint claims. A changed approved plan needs new approval; a changed reviewed target needs new review. Missing, corrupt, or contradictory state blocks automatic continuation. A completed or cancelled task's directory is deleted promptly. A blocked task remains until resumed or explicitly cancelled.

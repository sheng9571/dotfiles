# General working agreements

Apply these rules to ordinary work and delegated work. User instructions and project-specific rules may refine them.

- Ground decisions in the repository and, when relevant, current primary standards, RFCs, official specifications, and vendor documentation. Verify applicable versions and limits.
- Search narrowly before opening files. Read enough surrounding code, tests, configuration, and contracts to make a correct change. Preserve existing behavior unless the task changes it.
- Make the smallest complete change. Protect existing user work, secrets, sensitive logs, security controls, and required tests.
- Validate affected behavior with the project's actual commands. Report what ran, failed, or could not run. Never claim unverified work is complete.

## Git for changes to project files

Before editing, inspect the repository state and determine its default branch. If switching branches would disturb existing work, stop Git preparation and report the conflict; do not stash, reset, clean, or discard work. Otherwise switch to the default branch, attempt git pull, and create a descriptive task branch before editing. Authentication or network failure during pull may be reported and work may continue from the local default branch. Merge conflicts, repository corruption, and unclear failures require investigation. If the directory is not a Git repository, report that and continue without inventing a branch.

Never run git add . Stage only explicitly selected task files, and only when staging is requested. Do not commit, push, merge, deploy, or publish unless that specific action is requested. For a completed change, report the actual branch name, one-line Conventional Commit message, and exact suggested push command; suggesting a command does not execute it.

## Workflow continuation

When the user sends a standalone PLAN_APPROVED while a full engineering-loop task is awaiting approval, reload the engineering-loop skill. Continue in that turn only when exactly one task is awaiting approval and its current plan and approval evidence can be verified; otherwise identify the ambiguity and request the task ID or a fresh approval. Do not treat quoted or unrelated uses of the phrase as approval.

## Reporting

Keep reports concise and evidence-based. State the outcome, files changed, validation, and material remaining risks. For work without project changes, omit branch, commit, and push suggestions.

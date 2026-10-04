# Engineering Loop: Beginner's Guide

Engineering Loop lets you start a Planner -> plan approval -> Coder -> Reviewer workflow with one request. You review the plan; after approval, implementation and review continue automatically within the task. The Reviewer completes at most two reviews per explicitly authorized review cycle. The configuration is installed for your user account, so you do not need to copy agent files into each project.

## 1. Install once

Keep the entire dotfiles folder in a permanent location. Open a terminal in the `agent-workflow` directory that contains this README, then run the installer for your operating system.

**Windows:** Open **Command Prompt (CMD)**, not PowerShell:

```cmd
cd /d C:\path\to\dotfiles\agent-workflow
install\install.cmd
```

**Linux:** Open a terminal:

```sh
cd /path/to/dotfiles/agent-workflow
sh install/install.sh
```

The Windows installer uses `%USERPROFILE%`; the Linux installer uses `$HOME`. Both install global guidance, skills, and agent definitions for Codex and Claude Code. They do not modify a project or start a task. On first install, an existing nonempty configuration file causes the installer to stop instead of overwriting it. Back up and merge that configuration before retrying.

Edit the files in this dotfiles source, then rerun the same installer to refresh the managed copies. Do not edit installed copies directly: a reinstall replaces them.

## 2. Start a task in your project

Open Codex or Claude Code in the project you want to change. In Codex, invoke the skill with `$engineering-loop`:

```text
$engineering-loop Add a report export feature. Show me the complete plan first; after I approve it, implement it, run relevant checks, and have Reviewer review it.
```

In Claude Code, replace `$engineering-loop` with `/engineering-loop`. Ordinary prompts do not start the full workflow.

Planner examines the project and relevant official specifications. It asks you only about decisions that could materially change the design. When the plan is ready, you receive its version, scope, implementation steps, acceptance criteria, testing, security considerations, and required documentation.

## 3. Approve the plan

After reviewing the current plan, send this **as its own message**:

```text
PLAN_APPROVED
```

Do not place it inside a quote or a longer message. The Orchestrator verifies the plan version, prepares a task branch, then delegates implementation to Coder and independent review to Reviewer. Major findings go back to Coder within the two-review limit. A material change to the plan requires a new version and another approval. If several tasks are awaiting approval, identify the task first so the approval cannot be assigned to the wrong plan.

At completion, you receive the changed files, validation results, actual branch name, a one-line Conventional Commit message, and a suggested push command. The workflow does not automatically commit or push and never runs `git add .`.

## 4. Other useful requests

Use the same prefix, `$engineering-loop` in Codex or `/engineering-loop` in Claude Code:

- **Plan only:** `$engineering-loop plan-only: Plan feature X. Do not implement it.`
- **Audit documentation:** `$engineering-loop docs-only: Find documentation gaps that would prevent a new maintainer from taking over. Do not edit files.`
- **Update documentation:** `$engineering-loop docs-only: Update documentation against the actual code and deployment configuration. Do not change product code.`
- **Resume:** `$engineering-loop resume: Continue task <task-id>.`
- **Pause:** `$engineering-loop stop: Pause the current task.`
- **Cancel:** Explicitly say `Cancel task <task-id>`. Cancellation does not undo project changes already made.
- **Use one role:** Ask to use only Planner or to have Reviewer examine a specific diff. Coder still requires a complete, approved plan before editing.

### Copy-and-paste examples for Codex and Claude Code

Open either tool **in the project directory** after installing. Replace the example task and `<task-id>` with your own. The prefix starts the workflow; the words after it select a mode. For Claude Code, use `/engineering-loop` wherever these examples show `$engineering-loop`.

| What you want | In Codex | In Claude Code |
| --- | --- | --- |
| Full loop | `$engineering-loop Build feature X. Show me the plan for approval, then implement and review it.` | `/engineering-loop Build feature X. Show me the plan for approval, then implement and review it.` |
| Plan without implementation | `$engineering-loop plan-only: Plan feature X. Do not edit the project.` | `/engineering-loop plan-only: Plan feature X. Do not edit the project.` |
| Review a specific change | `$engineering-loop review-only: Review the current branch diff against <approved-plan-path>. Report findings; do not edit.` | `/engineering-loop review-only: Review the current branch diff against <approved-plan-path>. Report findings; do not edit.` |
| Check documentation | `$engineering-loop docs-only: Audit the project documentation against the code and configuration. Report gaps; do not edit.` | `/engineering-loop docs-only: Audit the project documentation against the code and configuration. Report gaps; do not edit.` |
| Update documentation | `$engineering-loop docs-only: Update documentation needed to maintain and operate this project.` | `/engineering-loop docs-only: Update documentation needed to maintain and operate this project.` |
| Resume interrupted work | `$engineering-loop resume: Continue task <task-id>.` | `/engineering-loop resume: Continue task <task-id>.` |
| Continue after the two-review limit | `$engineering-loop resume: Continue task <task-id>; I explicitly authorize a new review cycle of at most two reviews to fix the remaining findings.` | `/engineering-loop resume: Continue task <task-id>; I explicitly authorize a new review cycle of at most two reviews to fix the remaining findings.` |
| Pause at a safe boundary | `$engineering-loop stop: Pause task <task-id>.` | `/engineering-loop stop: Pause task <task-id>.` |
| Cancel and remove task state | `$engineering-loop cancel: Cancel task <task-id>. Report remaining project changes.` | `/engineering-loop cancel: Cancel task <task-id>. Report remaining project changes.` |

For a **single role without the full loop**, ask the main assistant directly. The installed agent definition is an entry point; `roles/*.md` contains its shared instructions. You can ask for Planner or Reviewer without creating an implementation task. Coder needs a complete approved plan and its normal handoff before changing project files.

| Role | Example request to either tool | Expected result |
| --- | --- | --- |
| Planner | `Use the installed planner agent only. Plan feature X in this project, including acceptance criteria and relevant official specifications. Do not implement.` | A read-only plan for your review. |
| Coder | `Use the installed coder agent only for approved plan <path>, version <version>. Implement its scope and run the required checks; do not start an independent review.` | Changes and validation against that approved plan. Supply the approval and task context so the handoff can be verified. |
| Reviewer | `Use the installed reviewer agent only. Review the current branch diff against approved plan <path>. Report findings with evidence; do not edit.` | An independent verdict for the specified stable change. |

These are requests to **delegate** to the installed roles, not commands named `$planner`, `$coder`, or `$reviewer`. If a tool cannot start the specified role, it should tell you instead of presenting an ordinary assistant response as an independent review. For a small ordinary request, omit the engineering-loop prefix and describe the task normally; that does not start plan approval or the two-review cycle.

### What each workflow status means

The Orchestrator writes the current `Phase` to `<project>/.agent-runs/<task-id>/checkpoint.md`. The statuses below are internal progress markers; you normally use the requests above rather than manually setting a status.

| Status | What happens | What you do |
| --- | --- | --- |
| `NEW` | Creates a task ID and temporary checkpoint; reports the task ID to you. | Save the task ID for later resume. |
| `DISCOVERY` | Planner examines the project, requirements, and applicable standards. | Answer only material design questions if asked. |
| `PLAN_READY` | You receive the complete versioned plan. Revisions stay here with a new version. | Review the current version; request changes or send `PLAN_APPROVED` as a standalone message. |
| `APPROVED` | Orchestrator verifies and records approval of that exact plan. | No extra prompt is needed. |
| `GIT_PREP` | Checks existing work, switches to the default branch when safe, attempts pull, and creates a task branch. | Resolve a reported Git conflict if one prevents safe preparation. |
| `IMPLEMENTING` | Coder implements the approved plan, tests it, and updates relevant documentation. | No action unless a new material decision is needed. |
| `REVIEW_READY` | Orchestrator fixes a stable diff target and sends it to Reviewer. | No action. |
| `REVIEW_DECISION` | Records Reviewer's verdict and completed review count. | Read a reported blocker if the workflow cannot continue. |
| `FIXING` | Coder addresses assigned major findings; the change returns for review. | No action unless the fix changes the approved plan materially. |
| `BLOCKED` | Stops automatic progress and preserves the checkpoint and project changes. | Resolve the stated blocker. If the two-review limit was reached, explicitly authorize a new cycle; plain resume does not restart review. |
| `PAUSED` | Stops at a safe boundary while preserving task state. | Use `resume: Continue task <task-id>` when ready. |
| `COMPLETE` | Reports validated results and removes this task's temporary directory. | Review the result; commit or push yourself if wanted. |
| `CANCELLED` | Reports any remaining project changes and removes this task's temporary directory. | No resume is possible for this task ID. |

The loop allows **at most two completed Reviewer reviews per explicitly authorized cycle**. If the first review is `PASS`, the task completes without a second review. The second review runs only after Coder fixes assigned major findings. Unresolved BLOCKER/MAJOR findings after the second review leave the task `BLOCKED`; plain resume does not reset the limit. To keep working on the same task, explicitly request a new cycle of at most two reviews, using the example above. The Orchestrator keeps the same task ID and cumulative review count, rechecks the plan, approval, branch, diff and findings, then sends remaining Coder-owned findings to Coder. A material plan change returns to planning and requires a new approval. Do not edit `Phase` by hand to skip a gate. The Orchestrator reports the task ID when it creates the checkpoint and in later task-state updates; PAUSED and BLOCKED reports also include a copyable recovery command. To find it yourself, look at the direct child folder name under `<project>/.agent-runs/`; the checkpoint repeats it on its `Task ID:` line. You can also ask the Orchestrator to list resumable task IDs and phases. A usage limit or closed session does not automatically restart work: reopen the project in either tool and request `resume` with that ID. If approval evidence cannot be verified across sessions or tools, the Orchestrator will ask for a fresh standalone `PLAN_APPROVED`.

## 5. Interruptions and project documentation

An active task stores its plan, checkpoint, and any needed review notes under `<project>/.agent-runs/<task-id>/`. This directory must never enter Git; it is deleted when the task completes or is cancelled. If the tool stops or your usage limit is reached, return to the project and use `resume`. The workflow checks the actual files, approved plan version, review-cycle budget, and cumulative review count before continuing. It does not restart itself in the background when a usage limit resets.

Planner identifies the long-lived documentation relevant to the change, Coder updates it alongside the implementation, and Reviewer checks it against actual behavior. File names depend on the project. The goal is for a person or agent who did not participate in development to understand, verify, diagnose, change, and operate the system using project documentation and verifiable contracts. Document external access and infrastructure requirements; do not claim that an unverified production deployment succeeded.

## 6. Where the files live

There are three different locations. **The dotfiles folder is the source you edit.** The installer copies its contents into your user home so Codex and Claude Code can discover them. A project gets only its own code, long-lived documentation, and temporary task checkpoints.

### A. Editable dotfiles source

```text
dotfiles/
└── agent-workflow/
    ├── README.md                         This beginner's guide
    ├── AGENTS.md                         General rules for ordinary and delegated work
    ├── roles/
    │   ├── planner.md                    What Planner investigates and must hand off
    │   ├── coder.md                      What Coder may implement and must verify
    │   └── reviewer.md                   How Reviewer independently checks the result
    ├── session-handover/
    │   └── SKILL.md                       Cross-session handover instructions
    ├── engineering-loop/
    │   ├── SKILL.md                       Entry point for the complete workflow
    │   ├── workflow.md                    States, handoffs, review limit, and documentation gate
    │   └── checkpoint-format.md          Fields and safety rules for resumable task state
    ├── adapters/
    │   ├── codex/
    │   │   ├── planner.toml               Codex entry point for Planner
    │   │   ├── coder.toml                 Codex entry point for Coder
    │   │   └── reviewer.toml              Codex entry point for Reviewer
    │   └── claude/
    │       ├── planner.md                 Claude Code entry point for Planner
    │       ├── coder.md                   Claude Code entry point for Coder
    │       └── reviewer.md                Claude Code entry point for Reviewer
    └── install/
        ├── install.cmd                    Windows CMD installer
        └── install.sh                     Linux shell installer
```

The three files in `roles/` are the **single maintained source** of role behavior. `session-handover/SKILL.md` is the single maintained source for cross-session handovers. Files in `adapters/` use each product's required format to register a role and point it at those shared rules. `engineering-loop/SKILL.md` tells the main agent when to run the workflow; `workflow.md` contains the longer procedure. Edit these source files, then rerun the installer.

### B. Installed global files

The same layout is installed under `%USERPROFILE%` on Windows or `$HOME` on Linux. The tree below uses `<home>` for either location.

```text
<home>/
├── .agent-workflow/
│   ├── .installed-by-engineering-loop    Marks files managed by this installer
│   ├── AGENTS.md                         Copy of the general rules
│   ├── roles/
│   │   ├── planner.md                    Installed shared role rules
│   │   ├── coder.md
│   │   └── reviewer.md
│   └── engineering-loop/
│       ├── SKILL.md
│       ├── workflow.md
│       └── checkpoint-format.md
├── .agents/skills/session-handover/
│   └── SKILL.md                          Codex discovers the handover skill here
├── .agents/skills/engineering-loop/
│   ├── SKILL.md                          Codex discovers the skill here
│   ├── workflow.md
│   └── checkpoint-format.md
├── .codex/
│   ├── AGENTS.md                         Codex loads these global rules
│   └── agents/
│       ├── planner.toml                  Codex registers its three roles here
│       ├── coder.toml
│       └── reviewer.toml
└── .claude/
    ├── CLAUDE.md                         Claude Code loads these global rules
    ├── skills/session-handover/
    │   └── SKILL.md                      Claude Code discovers the handover skill here
    ├── skills/engineering-loop/
    │   ├── SKILL.md                      Claude Code discovers the skill here
    │   ├── workflow.md
    │   └── checkpoint-format.md
    └── agents/
        ├── planner.md                    Claude Code registers its three roles here
        ├── coder.md
        └── reviewer.md
```

These are **installed copies**, not a second set to maintain. The shared role files under `<home>/.agent-workflow/roles/` are read by the product-specific agent entry points. A reinstall refreshes managed copies from the dotfiles source. The installer does not put its `README.md` in your home directory.

### C. Files inside a project

The global workflow works in any project. It creates or updates project files only when the task needs them. This is an **example**, not a required list of document names:

```text
<project>/
├── README.md                              Project overview and documentation links, if needed
├── AGENTS.md                              Optional Codex rules specific to this project
├── CLAUDE.md                              Optional Claude Code rules specific to this project
├── docs/                                  Long-lived, task-relevant documentation
│   ├── architecture.md                   Components, dependencies, and data flow, if relevant
│   ├── development.md                    Build, tests, and local debugging, if relevant
│   ├── operations.md                     Deployment, production diagnosis, and rollback, if relevant
│   ├── contracts/                        API, MCP, CLI, mobile, or other behavior contracts, if relevant
│   ├── data/                             Data models and migration rules, if relevant
│   └── specs/                            Only specifications with long-term value
├── .gitignore                             Includes .agent-runs/ after task branch creation
└── .agent-runs/                           Temporary task state; NEVER commit this directory
    └── <task-id>/
        ├── checkpoint.md                 Current phase, plan version, review cycle, cycle and cumulative review counts, next action
        ├── handover.md                   Optional temporary cross-session guide
        ├── plan-draft.md                 Complete versioned plan, including approved content
        └── reviews/                      Detailed review notes only when needed
            └── round-1.md
```

The project may have a different structure. Planner chooses which documentation is needed for the actual system and change; Coder keeps it consistent with implementation; Reviewer checks it. Long-lived project documentation and an applicable `.gitignore` rule belong in the project Git repository. `.agent-runs/` does **not**: it exists only while a task is active or blocked, and its task directory is removed after completion or cancellation. A plan stays there during the task; only decisions or contracts that remain useful are moved into long-lived project documentation.

Project-level `AGENTS.md` and `CLAUDE.md` are optional and can add more specific rules for that project. They are separate from the global role files installed in your home directory.

## 7. The maintainable handoff standard

**Goal:** Enable a person or agent with no prior involvement in development to take over maintaining, modifying, migrating, or redeploying the system using only the project's documentation and verifiable contracts. This workflow README explains how to request that result; it is **not** the project documentation itself. A generated document is useful only when it matches the code, schemas, infrastructure configuration, and observed behavior. More pages alone do not meet this goal.

For each task, Planner identifies which handoff information the changed scope needs and writes **observable documentation acceptance criteria** into the plan. Coder updates the relevant project documents and executable contracts alongside implementation. Reviewer independently checks the documents against the changed code, tests, configuration, and deployment definitions. Missing or inaccurate required information is a review finding and prevents a `PASS` verdict.

Use this table as a scope-dependent handoff checklist, not a demand to create every named file. Keep the durable result in the **project Git repository**, with links from its README where useful.

| A new maintainer needs to... | Project evidence to provide when applicable | How to check it |
| --- | --- | --- |
| Understand the system | Purpose, supported behavior, component and dependency map, data flow, entry points, trust boundaries, important design decisions, and known limits. | Trace a representative request or operation from entry to result in the actual code and configuration. |
| Understand external behavior | Versioned API, MCP, CLI, event, mobile, or other contracts; request and response examples; errors; compatibility rules; applicable official specifications. | Compare with routes, schemas, protocol handlers, contract tests, and relevant standard versions. |
| Understand data and state | Data model, storage ownership, retention, migrations, compatibility, backup and restore assumptions where relevant. | Compare with schemas, migration files, and tests; verify the documented migration path when feasible. |
| Run and change it locally | Prerequisites, dependency versions, configuration names and meanings, setup, build, tests, representative local debug commands, and where code changes belong. | Execute documented local steps or representative commands in a suitable isolated environment; record any unavailable prerequisite. |
| Diagnose and operate it | Log and error formats, useful metrics/traces, failure and recovery paths, production diagnosis, access prerequisites and owners, and safe rollback. | Match instructions to actual logging, monitoring, runbooks, deployment configuration, and available evidence. Do not store secret values. |
| Deploy or migrate it | Environment topology, CI/CD flow, artifacts, environment variables and secret *names*, external services, certificates and network dependencies where relevant, release/migration order, health checks, rollback, and post-deployment verification. | Reconcile with checked-in Docker, Compose, Kubernetes, pipeline, infrastructure, and application configuration; exercise non-production steps when feasible. Mark live-environment steps unverified unless actually performed. |

This applies to any stack or interface. For example, a mobile application may need screen/navigation behavior, offline and sync rules, signing and store-release steps instead of server API documentation. A data pipeline may need input schemas, scheduling, replay, and data recovery. Document what the **actual system** needs, not a fixed technology template.

The handoff is strongest when a new maintainer can follow the project README to locate the relevant contracts, reproduce a local run and key tests, explain a representative data flow, diagnose a sample failure, and identify the exact deployment and rollback path. Reviewer should attempt that independent check for the changed scope. If credentials, production infrastructure, signing keys, private registries, or another external prerequisite are unavailable, document their purpose, access owner, and verification status. A repository alone cannot prove an unperformed production deployment or guarantee a future rewrite or migration will be effortless; the workflow must state the remaining uncertainty rather than claim success.

You can request this separately with `docs-only` (see section 4). A read-only audit reports gaps; a documentation update verifies the relevant facts before editing and follows plan approval and review for a nontrivial change. The full implementation loop includes the same documentation work when the task changes behavior or operations.

## 8. Hand over work to a new session

Use `session-handover` when another person or agent needs to understand unfinished work. It also works outside the engineering loop. The handover captures the goal, verified state, decisions and reasons, important constraints and pitfalls, unresolved questions, and next actions without reproducing the chat transcript. It distinguishes verified facts from user statements and unknowns.

| Situation | Codex request | Claude Code request |
| --- | --- | --- |
| Standalone handover in this chat | `$session-handover Prepare a handover for a new session to continue this work.` | `/session-handover Prepare a handover for a new session to continue this work.` |
| Save a handover file | `$session-handover Prepare a handover and save it at <path>.` | `/session-handover Prepare a handover and save it at <path>.` |
| Handover an active engineering-loop task | `$engineering-loop Prepare a session handover for task <task-id>. Include the next gate and where to verify it.` | `/engineering-loop Prepare a session handover for task <task-id>. Include the next gate and where to verify it.` |
| Continue that task in a new session | `$engineering-loop resume: Continue task <task-id>. Read its handover if present, then verify the checkpoint and project state.` | `/engineering-loop resume: Continue task <task-id>. Read its handover if present, then verify the checkpoint and project state.` |

By default, handover appears **in the current session only**. A Markdown copy is optional. For an active loop task, a requested saved copy goes to `<project>/.agent-runs/<task-id>/handover.md`; it is temporary, ignored by Git, and removed when the task completes or is cancelled. For standalone work, specify where to save it if you need a file. Put information that must survive the task in the project's durable documentation and contracts instead.

The handover is a **reading guide**, while `checkpoint.md` is the workflow's state record. The checkpoint tracks the exact phase, plan/version/approval evidence, branch, review cycle, cycle and cumulative review counts, findings, and next gate. Planner-to-Coder and Coder-to-Reviewer handoffs still use the full approved plan and actual diff, not a handover summary. A new session may read a handover first, but `resume` must independently verify the checkpoint, approval, Git state, and files. A handover cannot approve a plan or skip a review. If the two conflict, stop the dependent work and resolve the discrepancy.

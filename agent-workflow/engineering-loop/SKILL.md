---
name: engineering-loop
description: Run or resume an explicitly requested Planner-Coder-Reviewer engineering workflow, including a pending standalone PLAN_APPROVED reply, bounded fix rounds, checkpoints, and documentation review. Do not trigger for ordinary coding or questions.
---

# Engineering loop

Use this skill when the user explicitly requests the engineering loop or invokes it by name. The main agent is the Orchestrator. Use the installed Planner, Coder, and Reviewer roles when available; if a role cannot be started, report the limitation instead of silently impersonating an independent reviewer. Do not spawn roles for unrelated tasks.

Read [workflow.md](workflow.md) before starting or resuming the full loop. Read [checkpoint-format.md](checkpoint-format.md) when creating, updating, resuming, or cleaning a checkpoint. Do not preload these references for a standalone role request that does not need them.

Full mode: obtain a complete versioned plan, present it for the user's standalone PLAN_APPROVED reply, then automatically prepare Git, delegate implementation, delegate independent review, and cycle on Coder-owned major findings for at most three completed Reviewer reviews. A material plan change requires a new version and another PLAN_APPROVED. Do not ask for redundant permission for work already approved in the plan.

Support explicit plan-only, docs-only, review-only, resume, stop, and single-role requests. Docs-only work should audit actual behavior and produce only relevant, accurate project documents; a nontrivial docs-only change follows the same plan approval and independent review unless the user explicitly requests a narrower ordinary task. Stopping pauses the workflow without deleting active state. Cancellation deletes checkpoint state only after recording any remaining project changes for the user.

For an explicit cross-session handover, use the installed `session-handover` skill when available and follow the cross-session handover rules in [workflow.md](workflow.md). Keep its narrative separate from the authoritative checkpoint and full role handoffs.

When a standalone PLAN_APPROVED arrives for an active pending full-mode task, reload the current checkpoint and plan candidate and continue in the same turn only if exactly one task and the approval evidence are unambiguous. Otherwise request the task ID or fresh approval. Never treat quoted or discussed PLAN_APPROVED as approval. Never commit, push, deploy, or publish without specific user authorization. Never run git add . Keep project checkpoints out of Git.


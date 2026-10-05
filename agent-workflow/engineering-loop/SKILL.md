---
name: engineering-loop
description: Run or resume an explicitly requested Planner-Coder-Reviewer engineering workflow, including a pending standalone PLAN_APPROVED reply, bounded fix rounds, checkpoints, and documentation review. Do not trigger for ordinary coding or questions.
---

# Engineering loop

Use this skill when the user explicitly requests the engineering loop or invokes it by name. The main agent is the Orchestrator. Use the installed Planner, Coder, and Reviewer roles when available; if a role cannot be started, report the limitation instead of silently impersonating an independent reviewer. Do not spawn roles for unrelated tasks.

Read [workflow.md](workflow.md) and [work-plan.md](work-plan.md) before starting or resuming the full loop. Read [checkpoint-format.md](checkpoint-format.md) when creating, updating, resuming, or cleaning a checkpoint. Do not preload these references for a standalone role request that does not need them.

Full mode: obtain a complete versioned plan with work IDs, dependencies, staged validation, and planned review gates; present it for the user's standalone PLAN_APPROVED reply. Then prepare Git once and delegate implementation/testing in dependency order, with concentrated or milestone review as approved. Each gate has at most two completed reviews per authorized cycle; first PASS ends that gate's cycle. A milestone PASS permits its dependent work, not whole-task completion; only the final full-task gate can complete the task. Exhausted gates block dependent work and require an explicit new-cycle request, while independent approved work may proceed when safe. Plain resume never resets budgets. Material plan changes need a new version and PLAN_APPROVED; routine work items need no redundant permission.

Support explicit plan-only, docs-only, review-only, resume, stop, and single-role requests. Docs-only work should audit actual behavior and produce only relevant, accurate project documents; a nontrivial docs-only change follows the same plan approval and independent review unless the user explicitly requests a narrower ordinary task. Stopping pauses the workflow without deleting active state. Cancellation deletes checkpoint state only after recording any remaining project changes for the user.

For an explicit cross-session handover, use the installed `session-handover` skill when available and follow the cross-session handover rules in [workflow.md](workflow.md). Keep its narrative separate from the authoritative checkpoint and full role handoffs.

When a standalone PLAN_APPROVED arrives for an active pending full-mode task, reload the current checkpoint and plan candidate and continue in the same turn only if exactly one task and the approval evidence are unambiguous. Otherwise request the task ID or fresh approval. Never treat quoted or discussed PLAN_APPROVED as approval. Never commit, push, deploy, or publish without specific user authorization. Never run git add . Keep project checkpoints out of Git.

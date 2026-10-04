---
name: session-handover
description: Prepare a concise, evidence-aware handover so a new session, person, or agent can continue an ongoing task. Use when explicitly asked for a handover or when the engineering loop needs a cross-session handoff; do not use for routine role-to-role handoffs or project documentation.
---

# Session handover

Produce a self-contained working handover, not a chat transcript. Preserve the user's confirmed goals, constraints, decisions and reasons, important changes in direction, current state, known pitfalls, unresolved questions, and next executable actions. Include implicit knowledge only when losing it could change future work. Omit repeated discussion, empty sections, and details that do not affect continuation. Do not invent facts or silently turn a proposal into a completed decision.

## Evidence and scope

Distinguish facts verified from files or tools, user statements, and items still unverified. Cite paths, task IDs, or commands when they help the next session check a claim; do not paste entire files, full logs, secrets, or sensitive values. If project access is available, inspect only the evidence needed to establish the current state. State any important evidence that could not be checked.

For an engineering-loop task, read its existing checkpoint and referenced plan/review files when available. Include task ID, phase, approved plan version and path, branch, review-cycle number, cycle and cumulative review counts, open finding IDs, and exact next gate, with verification status. Point to the authoritative files instead of duplicating the complete plan. A handover does not authorize implementation, prove approval, replace a role handoff, or alter checkpoint state. On resume, the Orchestrator must revalidate the checkpoint, approval evidence, and actual project state. If the handover and those sources disagree, report the conflict and stop dependent continuation.

## Output

Default to a response in the current session. Write a Markdown file only when the user asks for a persistent artifact or the coordinating workflow explicitly requests one. For an active engineering-loop task, store that file in the task's ignored `.agent-runs/<task-id>/` directory; otherwise use the user-specified location, or ask for a location if persistence is required but none is available. Never stage a temporary handover. Do not treat it as a substitute for durable project documentation or verifiable contracts.

Use concise sections chosen for the actual task: goal and success criteria; verified current state; requirements and constraints; decisions and reasons (including consequential rejected alternatives); critical context and pitfalls; open questions and risks; next actions with prerequisites; and where to verify. Include a short starting point for the next session. Cover the user's original and current goals when they differ. Mark tentative decisions and blocked or unverified actions explicitly. Put each fact in one primary place rather than repeating it under several headings. Perform a final completeness check against the source conversation and available evidence, then output the handover without hidden reasoning or a separate quality-check transcript.

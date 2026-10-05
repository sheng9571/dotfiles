# Work decomposition and staged validation

Use this contract for any task domain. Decompose the entire confirmed scope before approval, at the depth needed to implement without guessing material requirements or design decisions. A small task may have one item; do not split work merely to fill a template. Resolve consequential choices with repository evidence and applicable official contracts, not a fixed technology checklist.

## Approved plan

Give work items stable IDs such as W1 and map them to numbered requirements or acceptance criteria. For each item record purpose, observable deliverable, dependencies, necessary design decisions, validation method and expected result, and evidence needed for completion. Specify inputs/outputs or behavior contracts where they matter. Detail material contracts and choices where applicable: data structures and field types/constraints, supported formats and parsing/error behavior, decision rules and evaluation criteria, model/prompt/output contracts, interface versions/encoding, and operational behavior. These are conditional examples, not required technologies. Keep routine implementation details with Coder; identify exact files or clearly labeled candidates as usual.

Cover the confirmed scope, important data/behavior flow, normal/error/boundary paths, applicable safety and security controls, external prerequisites, and durable documentation. Check dependency order and ensure every required outcome has an implementation and verification path. Do not assume a technology, storage layer, interface, or external service merely because an example mentioned it.

Choose and explain the review schedule in the plan:
- Concentrated review: implement and validate items in dependency order, then review the complete task at the final gate.
- Milestone review: group independently verifiable outcomes into gates with stable IDs such as G1; identify the covered items, stable review target, acceptance evidence, and dependencies. A dependent item waits for its prerequisite gate to pass. Do not review every function or small step by default.

Both schedules require staged validation and a final gate such as GF covering the full original request, accumulated implementation, cross-stage integration, required tests, and documentation. The last milestone may serve as GF if that full scope is explicit; do not add a redundant final review. The approved plan authorizes the initial review cycle at each planned gate. Routine item execution needs no separate user approval.

## Validation stages

Define observable expected results, not just an OK label. Choose validation appropriate to the deliverable; a documentation or other non-code task may use inspection or a reproducible manual check instead of inventing redundant automated tests. Use proportionate component, contract, integration, and end-to-end checks, including relevant failure/boundary/abuse cases and partial failure, retry, concurrency, or recovery behavior. Distinguish fixtures/mocks, test-environment checks, and real external-system checks; record which claims each can support. For consequential external effects, specify preview/test steps and the authorization needed for a real action. A plan approval does not authorize an otherwise unrequested production deployment, publication, or external write.

Validate at useful implementation boundaries rather than waiting until all coding is done. Record input or fixture, expected outcome, actual outcome, command/check, and evidence reference concisely. Keep secrets and full logs out of reports/checkpoints. Required unavailable checks block the acceptance they support; simulated success does not prove a live integration. A revised criterion needs explicit plan approval and still reports any unverified scope.

If feasibility is unresolved, plan a bounded investigation/prototype with a question, evidence to collect, success/failure criteria, and a decision gate before dependent implementation. Such an investigation may be approved while downstream design is explicitly conditional; its approval does not approve an unknown material design. If the result materially changes requirements, architecture, controls, scope, or acceptance, return to Planner for a revised plan and approval before dependent work.

## Progress and changes

Track work as PENDING, IN_PROGRESS, VERIFIED, BLOCKED, or INVALIDATED. VERIFIED means the item's required checks and deliverable were verified; it does not mean an independent review passed. Track review gates separately as PENDING, READY, PASS, BLOCKED, or INVALIDATED. The Orchestrator owns persistent progress; roles return concise results and evidence keyed by work/gate IDs.

A failed prerequisite blocks dependent items. Unrelated work may proceed only when the approved dependency graph allows it and proceeding does not share the failed prerequisite or risk. Changing previously verified or reviewed work invalidates affected evidence, gate PASS, and dependent claims; preserve history and revalidate the affected scope. Do not reset review budgets merely because a target changed. Final completion requires all required items and gates, including GF, to satisfy current approved criteria with current evidence; local PASS results alone are insufficient.

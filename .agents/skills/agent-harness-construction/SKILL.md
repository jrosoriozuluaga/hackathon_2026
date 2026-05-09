---
name: agent-harness-construction
description: Design and optimize AI agent action spaces, tool definitions, and observation formatting for higher completion rates.
origin: ECC
---

# Agent Harness Construction

Use this skill when you are improving how an agent plans, calls tools, recovers from errors, and converges on completion.

## Instructions

1. Define the agent's action space before writing prompts or tools.
2. Keep tool inputs schema-first, narrow, and explicit.
3. Design observations with status, summary, next actions, and artifacts.
4. Add recovery contracts for validation errors, missing scope, failed tool calls, and unsafe actions.
5. Budget context by moving stable guidance into skills and loading references only when needed.
6. Benchmark completion quality with pass rate, retries, and cost per successful task.

## Core Model

Agent output quality is constrained by:
1. Action space quality
2. Observation quality
3. Recovery quality
4. Context budget quality

## Action Space Design

1. Use stable, explicit tool names.
2. Keep inputs schema-first and narrow.
3. Return deterministic output shapes.
4. Avoid catch-all tools unless isolation is impossible.

## Granularity Rules

- Use micro-tools for high-risk operations (deploy, migration, permissions).
- Use medium tools for common edit/read/search loops.
- Use macro-tools only when round-trip overhead is the dominant cost.

## Observation Design

Every tool response should include:
- `status`: success|warning|error
- `summary`: one-line result
- `next_actions`: actionable follow-ups
- `artifacts`: file paths / IDs

## Error Recovery Contract

For every error path, include:
- root cause hint
- safe retry instruction
- explicit stop condition

## Context Budgeting

1. Keep system prompt minimal and invariant.
2. Move large guidance into skills loaded on demand.
3. Prefer references to files over inlining long documents.
4. Compact at phase boundaries, not arbitrary token thresholds.

## Architecture Pattern Guidance

- ReAct: best for exploratory tasks with uncertain path.
- Function-calling: best for structured deterministic flows.
- Hybrid (recommended): ReAct planning + typed tool execution.

## Benchmarking

Track:
- completion rate
- retries per task
- pass@1 and pass@3
- cost per successful task

## Examples

- Design a lead Architect agent that routes Harness work to specialist subagents and validates handoffs.
- Refactor a broad "do everything" tool into smaller read, write, execute, and diagnose actions.
- Improve a tool response so it includes root cause hints and safe retry instructions.

## Performance Notes

- Prefer hybrid orchestration: ReAct for exploration and typed tools for execution.
- Keep prompts small and stable; move large operational knowledge into load-on-demand skills.
- Measure retries and validation failures after each orchestration change.

## Anti-Patterns

- Too many tools with overlapping semantics.
- Opaque tool output with no recovery hints.
- Error-only output without next steps.
- Context overloading with irrelevant references.

## Troubleshooting

- If an agent loops, narrow its action space and add explicit stop conditions.
- If a tool result is hard to use, add `status`, `summary`, `next_actions`, and `artifacts`.
- If prompts become too large, split invariant policy from task-specific references.

# Harness Orchestration Tasks

This file tracks implementation and operational work for the Harness subagent system.

## Statuses

- `TODO`: Defined but not started.
- `IN_PROGRESS`: Owned by Architect or a specialist subagent.
- `BLOCKED`: Waiting for user input, credentials, scope, or decision.
- `REVIEW`: Ready for Tester validation.
- `DONE`: Validated and recorded in `CHANGELOG.md`.

## Task Template

```markdown
| ID | Status | Owner | Skill | Created | Updated | Acceptance Criteria |
| --- | --- | --- | --- | --- | --- | --- |
| HARNESS-000 | TODO | Architect | n/a | YYYY-MM-DD | YYYY-MM-DD | Concrete, testable criteria. |
```

## Active Tasks

| ID | Status | Owner | Skill | Created | Updated | Acceptance Criteria |
| --- | --- | --- | --- | --- | --- | --- |
| HARNESS-001 | DONE | Architect | agent-harness-construction | 2026-05-08 | 2026-05-08 | Four canonical subagents exist with frontmatter, responsibilities, boundaries, routing, and handoff format. |
| HARNESS-002 | DONE | Architect | n/a | 2026-05-08 | 2026-05-08 | `.agents/skills/` is canonical and `skills/` remains as compatibility symlinks. |
| HARNESS-003 | DONE | Tester | n/a | 2026-05-08 | 2026-05-08 | Validation script checks subagents, project-management docs, skill consistency, and runtime symlinks. |
| HARNESS-004 | DONE | Architect | n/a | 2026-05-08 | 2026-05-08 | Project-management docs exist for tasks, changelog, decisions, and roadmap. |
| HARNESS-007 | DONE | Architect | n/a | 2026-05-08 | 2026-05-08 | Claude and Codex runtime views exist for both subagents and skills through relative symlinks. |
| HARNESS-008 | DONE | Architect | n/a | 2026-05-08 | 2026-05-08 | Harness skills and subagents use a local artifact workflow with no external tool-server dependency references. |
| HARNESS-009 | DONE | Architect | n/a | 2026-05-08 | 2026-05-08 | README documents harness architecture, repository structure, subagent flow, and local issue/task management. |

## Backlog

| ID | Status | Owner | Skill | Created | Updated | Acceptance Criteria |
| --- | --- | --- | --- | --- | --- | --- |
| HARNESS-005 | TODO | Architect | n/a | 2026-05-08 | 2026-05-08 | Add Cursor and Windsurf agent views if those runtimes are enabled in this workspace. |
| HARNESS-006 | TODO | Tester | n/a | 2026-05-08 | 2026-05-08 | Add dry-run fixtures for React CI/CD, backend Kubernetes deploy, failed pipeline debug, and full microservice onboarding. |

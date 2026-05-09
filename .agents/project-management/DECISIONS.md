# Architecture Decisions

## ADR-001: Use `.agents/` As The Canonical Source

- Date: 2026-05-08
- Status: Accepted

Keep reusable skills, subagents, and project-management docs under `.agents/` so Claude, Codex, Cursor, Windsurf, and future runtimes can consume the same source through thin adapter views.

## ADR-002: Architect Is The Entry Point

- Date: 2026-05-08
- Status: Accepted

All Harness work enters through Architect. Specialist subagents provide domain analysis, while Architect owns scope, dependency order, skill loading, and final integration.

## ADR-003: Tester Gates Completion

- Date: 2026-05-08
- Status: Accepted

Tester validates YAML, dependency checks, placeholders, risk, and tracking before work is marked done or handed off for any external Harness apply step.

## ADR-004: Preserve `skills/` As Compatibility View

- Date: 2026-05-08
- Status: Accepted

Existing workflows may reference `skills/<name>/SKILL.md`, so `skills/` remains available as relative symlinks to `.agents/skills/<name>`.

## ADR-005: Local Artifact Workflow

- Date: 2026-05-08
- Status: Accepted

Skills generate, validate, and document local Harness artifacts. External application to Harness remains a user-controlled step and is not tied to a specific tool server.

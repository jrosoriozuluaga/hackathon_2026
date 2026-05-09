# Changelog

All notable improvements to the Harness subagent orchestration layer are recorded here.

## [Unreleased]

### Added

- Added canonical Harness subagents for Architect, Frontend, Backend, and Tester. [HARNESS-001]
- Added project-management tracking files for tasks, changelog, decisions, and roadmap. [HARNESS-004]
- Added validation script for subagent contracts, project-management docs, skill consistency, and runtime symlinks. [HARNESS-003]
- Added Claude and Codex runtime views for subagents and skills using relative symlinks. [HARNESS-007]
- Added README documentation for harness architecture, repository structure, subagent routing, and task/issue management. [HARNESS-009]

### Changed

- Moved Harness skills to `.agents/skills/` as the canonical source and kept `skills/` as compatibility symlinks. [HARNESS-002]
- Reworked Harness skills and subagents from a server-tool workflow to a local artifact workflow. [HARNESS-008]

### Validated

- Verified subagent definitions include frontmatter, responsibilities, boundaries, handoff contract, and routing or acceptance sections. [HARNESS-003]
- Added validation guard against external tool-server references in local orchestration files. [HARNESS-008]

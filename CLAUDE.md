# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repository is a **harness-engineering template** — a starter scaffold for projects that consume AI-coding-agent capabilities (Skills, Subagents, Slash Commands) in an **agent-agnostic** way. The goal is that one project tree can be opened by Claude Code, Cursor, Windsurf, Codex, or any future agent, and they all see the same skill/agent set without duplicated copies.

The design pattern is copied from the sibling `../CONCAT/` workspace, where it has been validated.

## Architecture: agent-agnostic skill layout

A single canonical directory holds all skill content. Each agent gets a thin "view" directory containing only **symlinks** back into the canonical store. There is exactly one source of truth on disk.

```
harness/
├── .agents/
│   ├── skills/                  # CANONICAL — real skill files live here
│       └── <skill-name>/
│           ├── SKILL.md         # YAML frontmatter (name, description, license, metadata) + body
│           ├── references/      # supporting markdown the skill loads on demand
│           ├── scripts/         # optional helper scripts
│           └── data/            # optional datasets / CSVs
│   ├── subagents/               # CANONICAL — reusable role definitions
│   │   ├── architect.md
│   │   ├── frontend.md
│   │   ├── backend.md
│   │   └── tester.md
│   └── project-management/      # task tracking, changelog, decisions, roadmap
│       ├── TASKS.md
│       ├── CHANGELOG.md
│       ├── DECISIONS.md
│       └── ROADMAP.md
│
├── .claude/
│   ├── settings.local.json      # Claude Code permissions allowlist (gitignored variant of settings.json)
│   └── skills/
│       └── <skill-name>  ──►  ../../.agents/skills/<skill-name>   (symlink)
│   └── agents/
│       └── <agent-name>.md ──►  ../../.agents/subagents/<agent-name>.md (symlink)
│
├── .codex/
│   └── agents/
│       └── <agent-name>.md ──►  ../../.agents/subagents/<agent-name>.md (symlink)
│
└── skills-lock.json             # manifest pinning each skill to its upstream source + content hash
```

Adding support for another agent (e.g. Cursor or Windsurf) means creating one more sibling directory (`.cursor/skills/`, `.cursor/agents/`, `.windsurf/skills/`, `.windsurf/agents/`, ...) full of symlinks into `.agents/skills/` and `.agents/subagents/`. Never copy canonical content into an agent-specific folder.

## Adding or updating a skill

1. Place / extract the upstream skill into `.agents/skills/<name>/`. The folder must contain a `SKILL.md` with the standard frontmatter:
   ```yaml
   ---
   name: <skill-name>
   description: <one-line trigger description used by the agent to decide when to load it>
   license: <SPDX id>
   metadata:
     author: <upstream>
     version: "<x.y>"
   ---
   ```
2. From each agent dir, create the symlink (relative, so the tree stays portable):
   ```bash
   ln -s ../../.agents/skills/<name> .claude/skills/<name>
   ln -s ../../.agents/skills/<name> .windsurf/skills/<name>
   ```
3. Record provenance in `skills-lock.json`:
   ```json
   "<name>": {
     "source": "<owner>/<repo>",
     "sourceType": "github",
     "computedHash": "<sha256 of skill contents>"
   }
   ```
4. Verify symlinks resolve: `ls -L .claude/skills/<name>/SKILL.md` should print without error.

## Conventions

- **Single source of truth**: real files only in `.agents/`. Agent-side directories must contain *only* symlinks. If you find a real file under `.claude/skills/` or `.windsurf/skills/`, that is a bug — move it back to `.agents/` and replace it with a symlink.
- **Relative symlinks**: use `../../.agents/skills/<name>`, never absolute paths. Keeps the repo portable across machines and clones.
- **`skills-lock.json` is the manifest**: every directory under `.agents/skills/` should have a matching entry. Treat drift as a lint failure.
- **Permissions live per-agent**: Claude-specific allowlists belong in `.claude/settings.local.json`; equivalent files for other agents go in their own dirs. Don't put permission rules in `.agents/`.
- **Architect-first orchestration**: route Harness work through `.agents/subagents/architect.md`; use Frontend or Backend for app-specific analysis and Tester before completion or any external Harness apply step.
- **Traceability**: every repository improvement should have a task in `.agents/project-management/TASKS.md` and a corresponding entry in `.agents/project-management/CHANGELOG.md`.

## What this repo is NOT

- Not an application or service — there is no build, test, or runtime to invoke yet. No package.json, no language toolchain. Add those at the project layer that consumes this template.
- Not a place to store project source code. The harness only carries agent configuration; downstream projects mount their own code alongside.

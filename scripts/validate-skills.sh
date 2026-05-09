#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 1
}

require_file() {
  local file="$1"
  [ -f "$file" ] || fail "Missing file: $file"
}

require_dir() {
  local dir="$1"
  [ -d "$dir" ] || fail "Missing directory: $dir"
}

require_text() {
  local file="$1"
  local text="$2"
  grep -Fq -- "$text" "$file" || fail "Missing required text in $file: $text"
}

cd "$ROOT_DIR"

require_dir ".agents/skills"
require_dir ".agents/subagents"
require_dir ".agents/project-management"
require_dir ".claude/agents"
require_dir ".codex/agents"
require_dir ".claude/skills"
require_dir ".codex/skills"
require_file "skills-lock.json"

for doc in TASKS.md CHANGELOG.md DECISIONS.md ROADMAP.md; do
  require_file ".agents/project-management/$doc"
done

for agent in architect frontend backend tester; do
  file=".agents/subagents/$agent.md"
  require_file "$file"
  require_text "$file" "---"
  require_text "$file" "name:"
  require_text "$file" "description:"
  require_text "$file" "## Purpose"
  require_text "$file" "## Responsibilities"
  require_text "$file" "## Handoff Format"
  require_text "$file" "status: success | warning | blocked"

  [ -L ".claude/agents/$agent.md" ] || fail "Missing Claude symlink for $agent"
  [ -L ".codex/agents/$agent.md" ] || fail "Missing Codex symlink for $agent"
  [ -f ".claude/agents/$agent.md" ] || fail "Broken Claude symlink for $agent"
  [ -f ".codex/agents/$agent.md" ] || fail "Broken Codex symlink for $agent"
done

for skill_dir in .agents/skills/*; do
  [ -d "$skill_dir" ] || continue
  skill="$(basename "$skill_dir")"
  require_file "$skill_dir/SKILL.md"
  require_text "$skill_dir/SKILL.md" "name:"
  require_text "$skill_dir/SKILL.md" "description:"
  require_text "$skill_dir/SKILL.md" "## Instructions"
  require_text "$skill_dir/SKILL.md" "## Examples"
  require_text "$skill_dir/SKILL.md" "## Performance Notes"
  require_text "$skill_dir/SKILL.md" "## Troubleshooting"

  if [ "$skill" != "agent-harness-construction" ]; then
    [ -L "skills/$skill" ] || fail "Missing compatibility symlink: skills/$skill"
    [ -f "skills/$skill/SKILL.md" ] || fail "Broken compatibility symlink: skills/$skill"
  fi

  [ -L ".claude/skills/$skill" ] || fail "Missing Claude skill symlink: $skill"
  [ -L ".codex/skills/$skill" ] || fail "Missing Codex skill symlink: $skill"
  [ -f ".claude/skills/$skill/SKILL.md" ] || fail "Broken Claude skill symlink: $skill"
  [ -f ".codex/skills/$skill/SKILL.md" ] || fail "Broken Codex skill symlink: $skill"

  grep -Fq "\"$skill\"" skills-lock.json || fail "Missing skills-lock entry for $skill"
done

require_text ".agents/project-management/TASKS.md" "HARNESS-001"
require_text ".agents/project-management/CHANGELOG.md" "[HARNESS-001]"

legacy_pattern="$(
  printf '%s|%s|%s' \
    'M''CP|m''cp' \
    'harness_''(list|get|create|update|delete|execute|search|describe|diagnose|status)' \
    'harness-''m''cp'
)"

if grep -R -n -E "$legacy_pattern" AGENTS.md CLAUDE.md .agents/skills .agents/subagents .agents/project-management >/tmp/harness-local-workflow-grep.txt; then
  cat /tmp/harness-local-workflow-grep.txt >&2
  fail "Found disallowed tool-server references in local workflow files"
fi

printf 'Harness skill and subagent validation passed.\n'

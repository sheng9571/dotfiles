#!/bin/sh
set -eu

src=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
target=${AI_WORKFLOW_HOME:-${HOME:?HOME is required}}
managed="$target/.agent-workflow"
marker="$managed/.installed-by-engineering-loop"

if [ ! -f "$marker" ]; then
  for path in "$managed" "$target/.codex/AGENTS.md" "$target/.claude/CLAUDE.md" \
    "$target/.agents/skills/engineering-loop" "$target/.claude/skills/engineering-loop" \
    "$target/.agents/skills/session-handover" "$target/.claude/skills/session-handover" \
    "$target/.codex/agents/planner.toml" "$target/.codex/agents/coder.toml" "$target/.codex/agents/reviewer.toml" \
    "$target/.claude/agents/planner.md" "$target/.claude/agents/coder.md" "$target/.claude/agents/reviewer.md"; do
    if [ "$path" = "$target/.codex/AGENTS.md" ] || [ "$path" = "$target/.claude/CLAUDE.md" ]; then
      [ -s "$path" ] || continue
    fi
    if [ -e "$path" ]; then
      printf 'Existing configuration; no files changed: %s\n' "$path" >&2
      exit 1
    fi
  done
fi

mkdir -p "$managed/roles" "$managed/engineering-loop" \
  "$target/.codex/agents" "$target/.claude/agents" \
  "$target/.agents/skills/engineering-loop" "$target/.claude/skills/engineering-loop" \
  "$target/.agents/skills/session-handover" "$target/.claude/skills/session-handover"

cp "$src/AGENTS.md" "$managed/AGENTS.md"
cp "$src"/roles/*.md "$managed/roles/"
cp "$src"/engineering-loop/*.md "$managed/engineering-loop/"
cp "$src/AGENTS.md" "$target/.codex/AGENTS.md"
cp "$src/AGENTS.md" "$target/.claude/CLAUDE.md"
cp "$src"/adapters/codex/*.toml "$target/.codex/agents/"
cp "$src"/adapters/claude/*.md "$target/.claude/agents/"
cp "$src"/engineering-loop/*.md "$target/.agents/skills/engineering-loop/"
cp "$src"/engineering-loop/*.md "$target/.claude/skills/engineering-loop/"
cp "$src/session-handover/SKILL.md" "$target/.agents/skills/session-handover/SKILL.md"
cp "$src/session-handover/SKILL.md" "$target/.claude/skills/session-handover/SKILL.md"
printf 'Managed by agent-workflow dotfiles. Reinstall updates these files.\n' > "$marker"
printf 'Installed engineering-loop and session-handover for Codex and Claude Code in %s\n' "$target"


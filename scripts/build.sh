#!/usr/bin/env bash
# Generates every distributable file from the single source persona/trump.md.
#
#   scripts/build.sh          write the generated files
#   scripts/build.sh --check  exit 1 if any generated file is out of date (used by CI)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/persona/trump.md"
REPO_URL="https://github.com/DongHyunTedKim/trump-style"
NOTICE="<!-- Generated from persona/trump.md by scripts/build.sh. Edit the source, not this file. ${REPO_URL} -->"
DESCRIPTION="Tremendous Trump-style voice. Code, commits, and facts stay professional. (트럼프식 말투 — 말투만 바뀌고 코드·커밋·사실은 그대로)"

MODE="write"
if [[ "${1:-}" == "--check" ]]; then
  MODE="check"
elif [[ $# -gt 0 ]]; then
  echo "usage: scripts/build.sh [--check]" >&2
  exit 2
fi

[[ -f "$SRC" ]] || { echo "error: missing $SRC" >&2; exit 1; }

OUT="$(mktemp -d)"
trap 'rm -rf "$OUT"' EXIT

body() { cat "$SRC"; }

emit() { # emit <relative path>  (reads content from stdin)
  local rel="$1"
  mkdir -p "$OUT/$(dirname "$rel")"
  cat > "$OUT/$rel"
}

# Claude Code output style (also picked up by the plugin from output-styles/)
{
  printf -- '---\n'
  printf 'name: trump\n'
  printf 'description: "%s"\n' "$DESCRIPTION"
  printf 'keep-coding-instructions: true\n'
  printf -- '---\n\n'
  printf '%s\n\n' "$NOTICE"
  body
} | emit "output-styles/trump.md"

# Codex CLI, OpenCode, Amp, Jules, and anything else that reads AGENTS.md
{ printf '%s\n\n' "$NOTICE"; body; } | emit "adapters/AGENTS.md"

# Gemini CLI
{ printf '%s\n\n' "$NOTICE"; body; } | emit "adapters/GEMINI.md"

# GitHub Copilot (.github/copilot-instructions.md)
{ printf '%s\n\n' "$NOTICE"; body; } | emit "adapters/copilot-instructions.md"

# Cursor project rule
{
  printf -- '---\n'
  printf 'description: Trump-style voice for chat replies. Code and commits stay professional.\n'
  printf 'alwaysApply: true\n'
  printf -- '---\n\n'
  printf '%s\n\n' "$NOTICE"
  body
} | emit "adapters/cursor/trump-style.mdc"

# Plain system prompt for Claude.ai, ChatGPT, the Agent SDK, or any API
body | emit "adapters/system-prompt.md"

GENERATED=(
  output-styles/trump.md
  adapters/AGENTS.md
  adapters/GEMINI.md
  adapters/copilot-instructions.md
  adapters/cursor/trump-style.mdc
  adapters/system-prompt.md
)

if [[ "$MODE" == "check" ]]; then
  stale=0
  for rel in "${GENERATED[@]}"; do
    if ! cmp -s "$OUT/$rel" "$ROOT/$rel"; then
      echo "stale: $rel" >&2
      stale=1
    fi
  done
  if [[ $stale -ne 0 ]]; then
    echo "Generated files are out of date. Run scripts/build.sh and commit the result." >&2
    exit 1
  fi
  echo "All generated files are up to date."
else
  for rel in "${GENERATED[@]}"; do
    mkdir -p "$ROOT/$(dirname "$rel")"
    cp "$OUT/$rel" "$ROOT/$rel"
    echo "wrote $rel"
  done
fi

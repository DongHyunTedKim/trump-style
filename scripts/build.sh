#!/usr/bin/env bash
# Generates every distributable file from the persona sources:
#   persona/trump.md     English edition (replies in the user's language)
#   persona/trump-ko.md  Korean edition (always replies in Korean)
#
#   scripts/build.sh          write the generated files
#   scripts/build.sh --check  exit 1 if any generated file is out of date (used by CI)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_URL="https://github.com/DongHyunTedKim/trump-style"

MODE="write"
if [[ "${1:-}" == "--check" ]]; then
  MODE="check"
elif [[ $# -gt 0 ]]; then
  echo "usage: scripts/build.sh [--check]" >&2
  exit 2
fi

OUT="$(mktemp -d)"
trap 'rm -rf "$OUT"' EXIT

emit() { # emit <relative path>  (reads content from stdin)
  local rel="$1"
  mkdir -p "$OUT/$(dirname "$rel")"
  cat > "$OUT/$rel"
}

# build <source> <style name> <style description> <cursor description> <adapter dir> <cursor file>
build() {
  local src="$ROOT/$1" name="$2" description="$3" cursor_description="$4" dir="$5" cursor_file="$6"
  local notice="<!-- Generated from $1 by scripts/build.sh. Edit the source, not this file. ${REPO_URL} -->"
  [[ -f "$src" ]] || { echo "error: missing $src" >&2; exit 1; }

  # Claude Code output style (also picked up by the plugin from output-styles/)
  {
    printf -- '---\n'
    printf 'name: %s\n' "$name"
    printf 'description: "%s"\n' "$description"
    printf 'keep-coding-instructions: true\n'
    printf -- '---\n\n'
    printf '%s\n\n' "$notice"
    cat "$src"
  } | emit "output-styles/$name.md"

  # Codex CLI, OpenCode, Amp, Jules, and anything else that reads AGENTS.md
  { printf '%s\n\n' "$notice"; cat "$src"; } | emit "$dir/AGENTS.md"

  # Gemini CLI
  { printf '%s\n\n' "$notice"; cat "$src"; } | emit "$dir/GEMINI.md"

  # GitHub Copilot (.github/copilot-instructions.md)
  { printf '%s\n\n' "$notice"; cat "$src"; } | emit "$dir/copilot-instructions.md"

  # Cursor project rule
  {
    printf -- '---\n'
    printf 'description: %s\n' "$cursor_description"
    printf 'alwaysApply: true\n'
    printf -- '---\n\n'
    printf '%s\n\n' "$notice"
    cat "$src"
  } | emit "$dir/cursor/$cursor_file"

  # Plain system prompt for Claude.ai, ChatGPT, the Agent SDK, or any API
  emit "$dir/system-prompt.md" < "$src"
}

build persona/trump.md trump \
  "Tremendous Trump-style voice. Code, commits, and facts stay professional. (트럼프식 말투 — 말투만 바뀌고 코드·커밋·사실은 그대로)" \
  "Trump-style voice for chat replies. Code and commits stay professional." \
  adapters trump-style.mdc

build persona/trump-ko.md trump-ko \
  "트럼프식 말투 한국어판. 항상 한국어로 답하며, 말투만 바뀌고 코드·커밋·사실은 그대로입니다." \
  "트럼프식 말투 한국어판. 대화 답변에만 적용하고 코드와 커밋은 평소대로 작성합니다." \
  adapters/ko trump-style-ko.mdc

GENERATED=()
while IFS= read -r rel; do
  GENERATED+=("$rel")
done < <(cd "$OUT" && find . -type f | sed 's|^\./||' | sort)

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
  echo "All ${#GENERATED[@]} generated files are up to date."
else
  for rel in "${GENERATED[@]}"; do
    mkdir -p "$ROOT/$(dirname "$rel")"
    cp "$OUT/$rel" "$ROOT/$rel"
    echo "wrote $rel"
  done
fi

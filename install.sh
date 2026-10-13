#!/usr/bin/env bash
# trump-style installer for Claude Code (manual install, no plugin system needed).
# Installs both styles by default: trump (English edition) and trump-ko (Korean edition).
#
#   curl -fsSL https://raw.githubusercontent.com/DongHyunTedKim/trump-style/main/install.sh | bash
#   curl -fsSL .../install.sh | bash -s -- --style trump-ko   # Korean edition only
#   curl -fsSL .../install.sh | bash -s -- --project          # this project only
#   curl -fsSL .../install.sh | bash -s -- --uninstall        # remove them again
set -euo pipefail

REPO="DongHyunTedKim/trump-style"
ALL_STYLES=(trump trump-ko)
MARKER="by scripts/build.sh. Edit the source, not this file."
SCOPE="user"
ACTION="install"
REF="${TRUMP_STYLE_REF:-main}"
STYLES=()

usage() {
  cat <<'EOF'
Usage: install.sh [--user | --project] [--style <name>] [--uninstall] [--ref <branch-or-tag>]

  --user          install to ~/.claude/output-styles (default)
  --project       install to ./.claude/output-styles
  --style <name>  only this style: trump (English edition) or trump-ko (Korean edition).
                  Repeat to pick several. Default: both.
  --uninstall     remove the styles from the chosen scope
  --ref <ref>     git branch or tag to install from (default: main)
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --user) SCOPE="user" ;;
    --project) SCOPE="project" ;;
    --uninstall) ACTION="uninstall" ;;
    --style)
      shift
      case "${1:-}" in
        trump|trump-ko) STYLES+=("$1") ;;
        *) echo "Unknown style: ${1:-} (choose trump or trump-ko)" >&2; exit 2 ;;
      esac
      ;;
    --ref) shift; REF="${1:?--ref needs a value}" ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1 (try --help)" >&2; exit 2 ;;
  esac
  shift
done
[[ ${#STYLES[@]} -gt 0 ]] || STYLES=("${ALL_STYLES[@]}")

if [[ "$SCOPE" == "user" ]]; then
  DEST_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/output-styles"
else
  DEST_DIR="$PWD/.claude/output-styles"
fi

if [[ "$ACTION" == "uninstall" ]]; then
  status=0
  for style in "${STYLES[@]}"; do
    dest="$DEST_DIR/$style.md"
    if [[ -f "$dest" ]] && grep -qF "$MARKER" "$dest"; then
      rm "$dest"
      echo "Removed $dest"
    elif [[ -f "$dest" ]]; then
      echo "$dest was not installed by trump-style, so it was left alone." >&2
      status=1
    else
      echo "Nothing to remove at $dest"
    fi
  done
  echo "If your settings still point to a removed style, run /output-style default in Claude Code."
  exit "$status"
fi

mkdir -p "$DEST_DIR"
TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

# Use the local copies when run from a clone; otherwise download them.
SCRIPT_DIR=""
if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

for style in "${STYLES[@]}"; do
  dest="$DEST_DIR/$style.md"
  if [[ -n "$SCRIPT_DIR" && -f "$SCRIPT_DIR/output-styles/$style.md" ]]; then
    cp "$SCRIPT_DIR/output-styles/$style.md" "$TMP"
  else
    url="https://raw.githubusercontent.com/$REPO/$REF/output-styles/$style.md"
    if ! curl -fsSL "$url" -o "$TMP"; then
      echo "Download failed: $url" >&2
      exit 1
    fi
  fi

  if ! grep -qF "$MARKER" "$TMP"; then
    echo "$style.md doesn't look like a trump-style output style. Aborting." >&2
    exit 1
  fi

  if [[ -f "$dest" ]] && ! grep -qF "$MARKER" "$dest"; then
    cp "$dest" "$dest.bak"
    echo "Backed up your existing $style.md to $dest.bak"
  fi

  cp "$TMP" "$dest"
  chmod 644 "$dest"
  echo "Installed: $dest"
done

cat <<'EOF'

Next, in Claude Code:
  /output-style trump        English edition (replies in your language)
  /output-style trump-ko     한국어판 (항상 한국어로 답합니다)
  /output-style default      switch back

You can also pick them in /config > Output style.

Tremendous. Believe me.
EOF

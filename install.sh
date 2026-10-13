#!/usr/bin/env bash
# trump-style installer for Claude Code (manual install, no plugin system needed).
#
#   curl -fsSL https://raw.githubusercontent.com/DongHyunTedKim/trump-style/main/install.sh | bash
#   curl -fsSL .../install.sh | bash -s -- --project      # this project only
#   curl -fsSL .../install.sh | bash -s -- --uninstall    # remove it again
#
# Options:
#   --user        install to ~/.claude/output-styles (default)
#   --project     install to ./.claude/output-styles
#   --uninstall   remove the style from the chosen scope
#   --ref <ref>   git branch or tag to install from (default: main)
#   -h, --help    show this help
set -euo pipefail

REPO="DongHyunTedKim/trump-style"
FILE="trump.md"
MARKER="Generated from persona/trump.md by scripts/build.sh"
SCOPE="user"
ACTION="install"
REF="${TRUMP_STYLE_REF:-main}"

usage() {
  cat <<'EOF'
Usage: install.sh [--user | --project] [--uninstall] [--ref <branch-or-tag>]

  --user        install to ~/.claude/output-styles (default)
  --project     install to ./.claude/output-styles
  --uninstall   remove the style from the chosen scope
  --ref <ref>   git branch or tag to install from (default: main)
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --user) SCOPE="user" ;;
    --project) SCOPE="project" ;;
    --uninstall) ACTION="uninstall" ;;
    --ref) shift; REF="${1:?--ref needs a value}" ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1 (try --help)" >&2; exit 2 ;;
  esac
  shift
done

if [[ "$SCOPE" == "user" ]]; then
  DEST_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/output-styles"
else
  DEST_DIR="$PWD/.claude/output-styles"
fi
DEST="$DEST_DIR/$FILE"

if [[ "$ACTION" == "uninstall" ]]; then
  if [[ -f "$DEST" ]] && grep -q "$MARKER" "$DEST"; then
    rm "$DEST"
    echo "Removed $DEST"
    echo "If your settings still say \"outputStyle\": \"trump\", run /output-style default in Claude Code."
  elif [[ -f "$DEST" ]]; then
    echo "$DEST was not installed by trump-style, so it was left alone." >&2
    exit 1
  else
    echo "Nothing to remove at $DEST"
  fi
  exit 0
fi

mkdir -p "$DEST_DIR"
TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

# Use the local copy when run from a clone; otherwise download it.
SCRIPT_DIR=""
if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi
if [[ -n "$SCRIPT_DIR" && -f "$SCRIPT_DIR/output-styles/$FILE" ]]; then
  cp "$SCRIPT_DIR/output-styles/$FILE" "$TMP"
else
  URL="https://raw.githubusercontent.com/$REPO/$REF/output-styles/$FILE"
  if ! curl -fsSL "$URL" -o "$TMP"; then
    echo "Download failed: $URL" >&2
    exit 1
  fi
fi

if ! grep -q "$MARKER" "$TMP"; then
  echo "The downloaded file doesn't look like the trump-style output style. Aborting." >&2
  exit 1
fi

if [[ -f "$DEST" ]] && ! grep -q "$MARKER" "$DEST"; then
  cp "$DEST" "$DEST.bak"
  echo "Backed up your existing $FILE to $DEST.bak"
fi

mv "$TMP" "$DEST"
trap - EXIT
chmod 644 "$DEST"

cat <<EOF
Installed: $DEST

Next, in Claude Code:
  /output-style trump        switch to it (or pick "trump" in /config > Output style)
  /output-style default      switch back

Tremendous. Believe me.
EOF

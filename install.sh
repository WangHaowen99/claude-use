#!/usr/bin/env bash
# install.sh — Install claude-use to your shell
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="${1:-$HOME/.bashrc}"

echo "Installing claude-use…"

# 1. Add source line to bashrc if not already present
if grep -q 'claude-use.sh' "$TARGET" 2>/dev/null; then
    echo "  [skip] $TARGET already sources claude-use.sh"
else
    echo "source $SCRIPT_DIR/claude-use.sh" >> "$TARGET"
    echo "  [done] Added source line to $TARGET"
fi

# 2. Copy env template if user doesn't have one yet
ENV_FILE="$HOME/.claude-code-providers.env"
if [ -f "$ENV_FILE" ]; then
    echo "  [skip] $ENV_FILE already exists"
else
    cp "$SCRIPT_DIR/claude-code-providers.example.env" "$ENV_FILE"
    chmod 600 "$ENV_FILE"
    echo "  [done] Created $ENV_FILE (edit it with your API keys)"
fi

echo ""
echo "Install complete. Run 'source $TARGET' or open a new terminal."
echo "Then try: claude-use --help"

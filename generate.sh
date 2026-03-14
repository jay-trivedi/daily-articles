#!/usr/bin/env bash
# Generate daily article using Claude, save it, commit, push, and send via Telegram
set -euo pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
PROMPT_FILE="$SCRIPT_DIR/generate-article.md"
NOTIFY="$HOME/bin/notify"

export PATH="$HOME/bin:$PATH"

# Read the prompt
PROMPT=$(cat "$PROMPT_FILE")

# Run Claude with the prompt
OUTPUT=$(unset CLAUDECODE; claude -p "$PROMPT" --max-turns 15 2>&1)
RC=$?

if [ $RC -ne 0 ] || [ -z "$OUTPUT" ]; then
    echo "Daily article generation FAILED (exit $RC). Output: $OUTPUT" | $NOTIFY ubuntu --stdin
    exit 1
fi

# Send article via Telegram
echo "$OUTPUT" | $NOTIFY ubuntu --stdin

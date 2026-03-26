#!/bin/bash

# Stop Hook - Auto-commit and push changes on session exit

set -euo pipefail

if git rev-parse --is-inside-work-tree &>/dev/null; then
    if [[ -n "$(git status --porcelain)" ]]; then
        echo "📦 Auto-committing and pushing changes..."
        git add -A
        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
        git commit -m "auto-commit: $TIMESTAMP" --no-verify 2>/dev/null || true
        git push 2>/dev/null && echo "✅ Changes pushed successfully." || echo "⚠️  Push failed."
    else
        echo "📦 No changes to push."
    fi
fi

exit 0

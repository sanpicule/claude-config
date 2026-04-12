#!/bin/bash
# 現在のライブ設定をリポジトリに取り込むスクリプト
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
CLAUDE_DIR="$HOME/.claude"

echo "=== ライブ設定をリポジトリに同期 ==="

# グローバル設定を取り込み
cp "$CLAUDE_DIR/CLAUDE.md" "$REPO_DIR/global/CLAUDE.md" 2>/dev/null && echo "同期: CLAUDE.md" || true
cp "$CLAUDE_DIR/settings.json" "$REPO_DIR/global/settings.json" 2>/dev/null && echo "同期: settings.json" || true
cp "$CLAUDE_DIR/statusline.sh" "$REPO_DIR/global/statusline.sh" 2>/dev/null && echo "同期: statusline.sh" || true

# スキルを取り込み
if [ -d "$CLAUDE_DIR/skills" ]; then
    for skill_dir in "$CLAUDE_DIR/skills"/*/; do
        skill_name=$(basename "$skill_dir")
        mkdir -p "$REPO_DIR/global/skills/$skill_name"
        cp "$skill_dir"SKILL.md "$REPO_DIR/global/skills/$skill_name/" 2>/dev/null && echo "同期: skills/$skill_name" || true
    done
fi

echo "同期完了。git diff で差分を確認してください"

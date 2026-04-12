#!/bin/bash
# グローバル.claude設定をホームディレクトリに反映するスクリプト
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
CLAUDE_DIR="$HOME/.claude"

echo "=== Claude Code グローバル設定セットアップ ==="

# バックアップ
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    BACKUP_DIR="$CLAUDE_DIR/backups/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    cp "$CLAUDE_DIR/CLAUDE.md" "$BACKUP_DIR/" 2>/dev/null || true
    cp "$CLAUDE_DIR/settings.json" "$BACKUP_DIR/" 2>/dev/null || true
    cp "$CLAUDE_DIR/statusline.sh" "$BACKUP_DIR/" 2>/dev/null || true
    echo "既存設定をバックアップしました: $BACKUP_DIR"
fi

# グローバル設定をコピー
cp "$REPO_DIR/global/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
cp "$REPO_DIR/global/settings.json" "$CLAUDE_DIR/settings.json"
cp "$REPO_DIR/global/statusline.sh" "$CLAUDE_DIR/statusline.sh"
chmod +x "$CLAUDE_DIR/statusline.sh"

# スキルをコピー
if [ -d "$REPO_DIR/global/skills" ]; then
    mkdir -p "$CLAUDE_DIR/skills"
    for skill_dir in "$REPO_DIR/global/skills"/*/; do
        skill_name=$(basename "$skill_dir")
        mkdir -p "$CLAUDE_DIR/skills/$skill_name"
        cp "$skill_dir"* "$CLAUDE_DIR/skills/$skill_name/" 2>/dev/null || true
    done
    echo "スキルを反映しました"
fi

echo "グローバル設定を反映しました"

#!/bin/bash
# プロジェクトに.claudeディレクトリをセットアップするスクリプト
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

if [ $# -lt 1 ]; then
    echo "使い方: $0 <プロジェクトパス>"
    exit 1
fi

PROJECT_DIR="$1"

if [ ! -d "$PROJECT_DIR" ]; then
    echo "エラー: プロジェクトディレクトリ '$PROJECT_DIR' が見つかりません"
    exit 1
fi

CLAUDE_DIR="$PROJECT_DIR/.claude"
mkdir -p "$CLAUDE_DIR"

echo "=== プロジェクト .claude セットアップ ==="
echo "対象: $PROJECT_DIR"

# CLAUDE.md はプロジェクトルートに配置
copy_if_absent() {
    local src="$1"
    local dst="$2"
    local name
    name=$(basename "$src")
    if [ -f "$dst" ]; then
        echo "スキップ（既存）: $name"
    else
        cp "$src" "$dst"
        echo "作成: $dst"
    fi
}

copy_if_absent "$REPO_DIR/CLAUDE.md" "$PROJECT_DIR/CLAUDE.md"
copy_if_absent "$REPO_DIR/.claude/settings.json" "$CLAUDE_DIR/settings.json"
copy_if_absent "$REPO_DIR/.claude/settings.local.json" "$CLAUDE_DIR/settings.local.json"

echo "セットアップ完了"

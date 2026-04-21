#!/bin/bash
# プロジェクトに Claude Code 設定を配置するスクリプト
# ローカル実行・curl 経由実行のどちらにも対応
set -euo pipefail

REPO="${CLAUDE_CONFIG_REPO:-sanpicule/claude-config}"
BRANCH="${CLAUDE_CONFIG_BRANCH:-main}"
RAW_BASE="https://raw.githubusercontent.com/${REPO}/${BRANCH}"

if [ $# -lt 1 ]; then
    echo "使い方: $0 <プロジェクトパス>"
    echo ""
    echo "例: bash $0 ~/Documents/my-app"
    echo "curl: curl -fsSL ${RAW_BASE}/scripts/setup-project.sh | bash -s ~/Documents/my-app"
    exit 1
fi

PROJECT_DIR="$1"

if [ ! -d "$PROJECT_DIR" ]; then
    echo "エラー: プロジェクトディレクトリ '$PROJECT_DIR' が見つかりません"
    exit 1
fi

CLAUDE_DIR="$PROJECT_DIR/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills"
mkdir -p "$CLAUDE_DIR"
mkdir -p "$SKILLS_DIR"

echo "=== プロジェクト .claude セットアップ ==="
echo "対象: $PROJECT_DIR"
echo "ソース: ${REPO}@${BRANCH}"

# ローカル実行か curl 実行かを判定（スクリプト自身のディレクトリにテンプレートがあるか）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || echo "")"
REPO_DIR="$(dirname "$SCRIPT_DIR" 2>/dev/null || echo "")"
USE_LOCAL=false
if [ -n "$REPO_DIR" ] && [ -f "$REPO_DIR/CLAUDE.md" ] && [ -f "$REPO_DIR/.claude/settings.json" ]; then
    USE_LOCAL=true
fi

fetch_if_absent() {
    local rel_path="$1"
    local dst="$2"
    local name
    name=$(basename "$dst")

    if [ -f "$dst" ]; then
        echo "スキップ（既存）: $name"
        return
    fi

    if [ "$USE_LOCAL" = true ] && [ -f "$REPO_DIR/$rel_path" ]; then
        cp "$REPO_DIR/$rel_path" "$dst"
    else
        curl -fsSL "${RAW_BASE}/${rel_path}" -o "$dst"
    fi
    echo "作成: $dst"
}

fetch_if_absent "CLAUDE.md" "$PROJECT_DIR/CLAUDE.md"
fetch_if_absent ".claude/settings.json" "$CLAUDE_DIR/settings.json"
fetch_if_absent ".claude/settings.local.json" "$CLAUDE_DIR/settings.local.json"
fetch_if_absent ".claude/skills/example-code-reviewer.md" "$SKILLS_DIR/example-code-reviewer.md"
fetch_if_absent ".claude/skills/example-test-writer.md" "$SKILLS_DIR/example-test-writer.md"

echo "セットアップ完了"

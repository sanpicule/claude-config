#!/bin/bash
# プロジェクトに.claudeディレクトリをセットアップするスクリプト
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# 引数チェック
if [ $# -lt 1 ]; then
    echo "使い方: $0 <プロジェクトパス> [テンプレート名]"
    echo ""
    echo "利用可能なテンプレート:"
    for dir in "$REPO_DIR/templates"/*/; do
        echo "  - $(basename "$dir")"
    done
    exit 1
fi

PROJECT_DIR="$1"
TEMPLATE="${2:-general}"
TEMPLATE_DIR="$REPO_DIR/templates/$TEMPLATE"

if [ ! -d "$TEMPLATE_DIR" ]; then
    echo "エラー: テンプレート '$TEMPLATE' が見つかりません"
    echo "利用可能なテンプレート:"
    for dir in "$REPO_DIR/templates"/*/; do
        echo "  - $(basename "$dir")"
    done
    exit 1
fi

if [ ! -d "$PROJECT_DIR" ]; then
    echo "エラー: プロジェクトディレクトリ '$PROJECT_DIR' が見つかりません"
    exit 1
fi

CLAUDE_DIR="$PROJECT_DIR/.claude"
mkdir -p "$CLAUDE_DIR"

echo "=== プロジェクト .claude セットアップ ==="
echo "テンプレート: $TEMPLATE"
echo "対象: $PROJECT_DIR"

# テンプレートファイルをコピー
for file in "$TEMPLATE_DIR"/*; do
    filename=$(basename "$file")
    target="$CLAUDE_DIR/$filename"

    # CLAUDE.mdとAGENTS.mdはプロジェクトルートに配置
    if [ "$filename" = "CLAUDE.md" ] || [ "$filename" = "AGENTS.md" ]; then
        target="$PROJECT_DIR/$filename"
    fi

    if [ -f "$target" ]; then
        echo "スキップ（既存）: $filename"
    else
        cp "$file" "$target"
        echo "作成: $filename"
    fi
done

echo "セットアップ完了"

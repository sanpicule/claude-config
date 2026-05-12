#!/usr/bin/env bash
# =============================================================================
# .claude/skills/review/scripts/collect-diff.sh
# -----------------------------------------------------------------------------
# 役割:
#   review スキルから呼ばれる補助スクリプト。
#   現在のブランチと main の差分・変更ファイル一覧を整形して標準出力に出す。
#   Claude はこの出力を入力としてレビューする。
#
# 使い方:
#   1. 実行権限を付与:
#        chmod +x .claude/skills/review/scripts/collect-diff.sh
#   2. スキル内から呼び出す:
#        bash .claude/skills/review/scripts/collect-diff.sh [base_branch]
#      base_branch を省略すると "main" を使う。
#
# 出力:
#   - 変更ファイル一覧 (`git diff --name-status`)
#   - 完全な unified diff (`git diff`)
#
# 注意:
#   - 巨大な差分でも全部出すので、コンテキスト消費に注意。
#   - リモート追跡ブランチが古い場合は、呼ぶ前に `git fetch origin` 推奨。
# =============================================================================

set -euo pipefail

BASE="${1:-main}"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  printf 'Error: not a git repository\n' >&2
  exit 1
fi

# main がリモートにしか無い場合に備えて origin/main にもフォールバック
if ! git rev-parse --verify --quiet "$BASE" >/dev/null; then
  if git rev-parse --verify --quiet "origin/$BASE" >/dev/null; then
    BASE="origin/$BASE"
  else
    printf 'Error: base branch %s not found\n' "$BASE" >&2
    exit 1
  fi
fi

printf '## Changed files (vs %s)\n' "$BASE"
git diff --name-status "$BASE"...HEAD
printf '\n## Full diff\n'
git diff "$BASE"...HEAD

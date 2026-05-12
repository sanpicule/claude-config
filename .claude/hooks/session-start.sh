#!/usr/bin/env bash
# =============================================================================
# session-start.sh
# -----------------------------------------------------------------------------
# 役割:
#   Claude Code のセッション開始時に一度だけ実行されるフック。
#   現在の Git ブランチ名、Node/Python のバージョン、機微なメモなどを
#   「追加コンテキスト」としてモデルに注入したい場合に使う。
#   Web 版 / IDE 版で動作を変えたいときの環境セットアップにも向く。
#
# 使い方:
#   1. 実行権限を付与:
#        chmod +x .claude/hooks/session-start.sh
#   2. .claude/settings.json の "hooks" に SessionStart として登録:
#        "hooks": {
#          "SessionStart": [
#            { "hooks": [
#                { "type": "command", "command": ".claude/hooks/session-start.sh" }
#            ] }
#          ]
#        }
#
# 入力 (stdin):
#   - session_id, cwd, source (例: "startup" / "resume" / "compact")
#
# 出力 / 戻り値:
#   - stdout に出した文字列が、そのセッションの追加コンテキストとして
#     モデルへ渡される (system reminder 相当)。
#   - 終了コード 0 で続行。
#
# 注意:
#   - 重い処理は避ける (ユーザーが起動を待つ時間に直結する)。
#   - 秘匿情報を stdout に出すとモデルに渡るため厳禁。
# =============================================================================

set -euo pipefail

# 1. 現在のブランチ名を出す (Git リポジトリでない場合は無視)
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch="$(git symbolic-ref --short -q HEAD || echo 'DETACHED')"
  printf 'Current git branch: %s\n' "$branch"
fi

# 2. 主要ツールのバージョンを軽く知らせる
if command -v node >/dev/null 2>&1; then
  printf 'Node: %s\n' "$(node --version)"
fi
if command -v python3 >/dev/null 2>&1; then
  printf 'Python: %s\n' "$(python3 --version)"
fi

# 3. 注意事項を 1 行で伝える例
printf 'Reminder: never commit .env or secrets.\n'

exit 0

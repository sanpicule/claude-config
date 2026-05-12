#!/usr/bin/env bash
# =============================================================================
# stop.sh
# -----------------------------------------------------------------------------
# 役割:
#   Claude のターン応答が「終了する直前」に呼ばれるフック。
#   応答完了を一度キャンセルして自動ループさせる、最後にテストを走らせる、
#   通知を送るなどに使う。長時間ジョブの自動化や「Stop してもまだ続けて
#   ほしい」系のワークフローで利用する。
#
# 使い方:
#   1. 実行権限を付与:
#        chmod +x .claude/hooks/stop.sh
#   2. .claude/settings.json の "hooks" に Stop として登録:
#        "hooks": {
#          "Stop": [
#            { "hooks": [
#                { "type": "command", "command": ".claude/hooks/stop.sh" }
#            ] }
#          ]
#        }
#
# 入力 (stdin):
#   - session_id, cwd, stop_hook_active (true なら既に自分が起動した二度目)
#
# 出力 / 戻り値:
#   - 終了コード 0: 通常の停止を許可。
#   - 終了コード 2: stop を阻止して継続させる (stdout/stderr で次の指示を渡せる)。
#   - stdout に JSON `{ "decision": "block", "reason": "..." }` を出すと細かく制御可。
#
# 注意:
#   - 無限ループを防ぐため、`stop_hook_active` を必ずチェックすること。
#   - 通常はここでは何もせず、ユーザー通知用途などに留めるのが安全。
# =============================================================================

set -euo pipefail

input="$(cat || true)"

# 既に stop フックが連鎖して動いている場合はそのまま終了し、ループを防ぐ
if command -v jq >/dev/null 2>&1; then
  active="$(printf '%s' "$input" | jq -r '.stop_hook_active // false')"
  if [ "$active" = "true" ]; then
    exit 0
  fi
fi

# 例: macOS なら通知センターに「ターン完了」を送る
if command -v osascript >/dev/null 2>&1; then
  osascript -e 'display notification "Claude finished a turn" with title "Claude Code"' >/dev/null 2>&1 || true
fi

exit 0

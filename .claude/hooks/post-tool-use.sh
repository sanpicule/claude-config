#!/usr/bin/env bash
# =============================================================================
# post-tool-use.sh
# -----------------------------------------------------------------------------
# 役割:
#   Claude Code が「ツールを実行した直後」に呼び出されるフック。
#   ファイル編集後の自動フォーマット (Prettier / Black / gofmt)、Linter 実行、
#   生成物の検証、変更通知などの後処理に使う。
#
# 使い方:
#   1. 実行権限を付与:
#        chmod +x .claude/hooks/post-tool-use.sh
#   2. .claude/settings.json の "hooks" に PostToolUse として登録:
#        "hooks": {
#          "PostToolUse": [
#            {
#              "matcher": "Edit|Write",
#              "hooks": [
#                { "type": "command", "command": ".claude/hooks/post-tool-use.sh" }
#              ]
#            }
#          ]
#        }
#
# 入力 (stdin):
#   - tool_name        : 実行されたツール名
#   - tool_input       : ツールへの入力
#   - tool_response    : ツールの実行結果 (成功/失敗、出力など)
#   - session_id, cwd  : セッション情報
#
# 出力 / 戻り値:
#   - 終了コード 0: 通常終了
#   - 終了コード 2: モデルに stderr の内容をフィードバック (例: Lint エラーを伝えて修正させる)
#
# 注意:
#   - ファイル変更後に走るため I/O が多い。重複実行や無限ループに注意。
#   - 編集対象のパスは tool_input.file_path などから取得できる。
# =============================================================================

set -euo pipefail

input="$(cat || true)"

# 例: 編集された TypeScript ファイルに対して型チェックを行う
if command -v jq >/dev/null 2>&1; then
  file_path="$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')"

  case "$file_path" in
    *.ts|*.tsx)
      if command -v npx >/dev/null 2>&1 && [ -f "tsconfig.json" ]; then
        if ! npx --no-install tsc --noEmit "$file_path" >/dev/null 2>&1; then
          printf 'Type check failed for %s\n' "$file_path" >&2
          # 終了コード 2 にするとモデルに再修正を促せる。ここでは警告にとどめる。
          exit 0
        fi
      fi
      ;;
  esac
fi

exit 0

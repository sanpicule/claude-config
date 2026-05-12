#!/usr/bin/env bash
# =============================================================================
# pre-tool-use.sh
# -----------------------------------------------------------------------------
# 役割:
#   Claude Code が「ツールを実行する直前」に呼び出されるフック。
#   たとえば Bash / Edit / Write などを実行する前に、許可・拒否や入力の書き換え、
#   ログ取得、秘匿情報スキャンといった介入処理を挟むために使う。
#
# 使い方:
#   1. このスクリプトに実行権限を付与する:
#        chmod +x .claude/hooks/pre-tool-use.sh
#   2. .claude/settings.json の "hooks" セクションで PreToolUse として登録する:
#        "hooks": {
#          "PreToolUse": [
#            {
#              "matcher": "Bash",                       // 任意: ツール名で絞り込み
#              "hooks": [
#                { "type": "command", "command": ".claude/hooks/pre-tool-use.sh" }
#              ]
#            }
#          ]
#        }
#
# 入力 (stdin):
#   Claude Code は JSON を標準入力で渡してくる。代表的なフィールド:
#     - tool_name      : 実行しようとしているツール名 (例: "Bash", "Write")
#     - tool_input     : ツールに渡される入力 (例: Bash なら { "command": "..." })
#     - session_id     : セッション識別子
#     - cwd            : 現在の作業ディレクトリ
#
# 出力 / 戻り値:
#   - 終了コード 0: 続行 (ツール実行を許可)
#   - 終了コード 2: ツール実行をブロックし、stderr をモデルに返す
#   - stdout に JSON を出すと decision/feedback を細かく制御できる:
#       { "decision": "block", "reason": "理由をここに" }
#
# 注意:
#   - フックは同期で実行されるため重い処理は避ける (タイムアウト推奨)。
#   - 秘匿情報 (.env, *.pem 等) はここでもガードできるが、第一防衛線は
#     settings.json の permissions.deny に書く方が確実。
# =============================================================================

set -euo pipefail

# stdin から JSON を受け取る (jq が無い環境では grep などで代替する)
input="$(cat || true)"

# 例: 危険なコマンドが含まれる Bash 呼び出しをブロックする
if command -v jq >/dev/null 2>&1; then
  tool_name="$(printf '%s' "$input" | jq -r '.tool_name // empty')"
  command_str="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"

  if [ "$tool_name" = "Bash" ]; then
    case "$command_str" in
      *"rm -rf /"*|*":(){ :|:& };:"*|*"mkfs"*)
        printf 'Refused: dangerous command detected\n' >&2
        exit 2
        ;;
    esac
  fi
fi

# 何もしない場合は終了コード 0 で抜ければよい
exit 0

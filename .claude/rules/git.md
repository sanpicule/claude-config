<!--
=============================================================================
.claude/rules/git.md
-----------------------------------------------------------------------------
役割:
  Git の運用ルール (ブランチ戦略 / コミット規約 / PR ルール)。
  CLAUDE.md にべた書きしていた内容を共有ルールとしてここに集約した。

使い方:
  - 各プロジェクトの CLAUDE.md から `@.claude/rules/git.md` で参照する。
  - 共有リポジトリとして使う場合は `@~/.claude-config/.claude/rules/git.md` の
    ようにユーザー配下を直接参照する。
  - プロジェクト個別に逸脱したい場合は、そのプロジェクト直下に
    `.claude/rules/git.md` を作って上書きする (近い側が優先される)。

カスタマイズ:
  - GitHub Flow ではなく GitFlow にしたい等、戦略ごと変えたい場合は
    このファイルを丸ごと差し替える。
  - Conventional Commits の type を増減する場合は本文の type 一覧を編集。
=============================================================================
-->

# Git ルール

> GitHub Flow + Conventional Commits をベースとしたデフォルトルール。
> プロジェクトの事情に合わせて本ファイルをコピー or 上書きしてカスタマイズする。

## ブランチ戦略: GitHub Flow

- `main` は常にリリース可能な状態を保ち、直接 push は禁止 (Pull Request 経由のみ)。
- すべての変更は `main` から作業ブランチを切って行う。ブランチ名は種別を prefix にする:
  - 新機能: `feature/<short-description>` 例: `feature/add-hooks-template`
  - バグ修正: `fix/<short-description>` 例: `fix/setup-script-path`
  - ドキュメント: `docs/<short-description>`
  - CI / ビルド: `ci/<short-description>`
  - リファクタ・雑務: `refactor/<...>` / `chore/<...>`
- 作業ブランチは 1 つの PR で完結させ、マージ後は削除する。長命ブランチは作らない。

## コミットメッセージ: Conventional Commits

- フォーマット: `<type>: <subject>` または `<type>(<scope>): <subject>` (scope は任意。必要に応じて本文で理由や背景を記述)
  - 例: `feat: add search filters`, `fix(api): handle timeout`, `chore(main): release 1.2.3`
- 主な `type`:
  - `feat:` 新機能追加
  - `fix:` バグ修正
  - `docs:` ドキュメントのみの変更
  - `refactor:` 挙動を変えないコード整理
  - `test:` テスト追加・修正
  - `ci:` CI / GitHub Actions 関連
  - `chore:` 上記に当てはまらない雑務
- 破壊的変更は `<type>!:` または `<type>(<scope>)!:`、もしくは本文に `BREAKING CHANGE:` を明記する。
- このルールは `release-please` 等の自動リリースツールと連動して、バージョン番号と `CHANGELOG.md` の決定に使われる。

## Pull Request

- タイトルは代表コミット同様 Conventional Commits 形式で書く。
- 本文に「変更の目的 / 主な変更点 / テスト観点」を記載する。
- CI (`lint` / `typecheck` / `test` など) が green であること。
- マージ方式は **squash merge** を推奨 (`main` をリニアに保つため)。
- 直接 `main` への push・force push は禁止。作業ブランチへの force push は自分のブランチのみ許可。

## その他

- `.env` / 鍵・トークン等のシークレットは絶対にコミットしない。
- 一時ファイル・個人設定 (`.claude/settings.local.json` など) は `.gitignore` で除外する。

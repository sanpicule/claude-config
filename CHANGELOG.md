# 変更履歴

本ファイルはこのリポジトリの主要な変更を記録します。

フォーマットは [Keep a Changelog 1.1.0](https://keepachangelog.com/ja/1.1.0/) に、
バージョニングは [Semantic Versioning 2.0.0](https://semver.org/lang/ja/) に準拠します。

## [Unreleased]

## [0.2.0] - 2026-04-21

### Added
- `.claude/skills/` カスタムスキルテンプレートを追加
  - `example-code-reviewer/SKILL.md`（コードレビュースキルのサンプル）
  - `example-test-writer/SKILL.md`（テスト作成スキルのサンプル）
- `scripts/setup-project.sh`: スキルファイルのセットアップ処理を追加
- `scripts/setup-project.sh`: ローカル実行時にテンプレートが欠損していれば curl でリモート取得にフォールバックする機能を追加
- `.github/workflows/ci.yml`: 統合テストにスキルファイルの配置確認とスキップ検証を追加
- `README.md`: `.claude/skills/` の使い方とカスタマイズ手順を追加

### Changed
- スキルテンプレートを `<skill-name>/SKILL.md` のサブディレクトリ構造へ変更（Claude Code のスキル仕様に準拠）
- `scripts/setup-project.sh`: `fetch_if_absent` 内で親ディレクトリを作成するようにし、`mkdir` の重複を解消
- `scripts/setup-project.sh`: スキップログを相対パス表示に変更して一意性を確保
- `.github/workflows/ci.yml`: スキップ検証の grep を `^$` アンカー付き正規表現に変更

## [0.1.0] - 2026-04-13

### Added
- Claude Code 設定管理リポジトリの初期構築
- `CLAUDE.md` / `.claude/settings.json` / `.claude/settings.local.json` / `.mcp.json` のテンプレート
- `scripts/setup-project.sh` によるセットアップ（ローカル実行・`curl | bash` 両対応）
- `.github/workflows/ci.yml` による JSON/JSONC 構文検証・ShellCheck・統合テスト
- MIT License

[Unreleased]: https://github.com/sanpicule/claude-config/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/sanpicule/claude-config/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/sanpicule/claude-config/releases/tag/v0.1.0

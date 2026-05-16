# プロジェクト固有ルール

<!--
  このファイルには「このプロジェクト固有」の情報だけを書きます。
  全プロジェクト共通の規約 (Git / コーディング / テスト / セキュリティ / API)
  は .claude/rules/ 配下に切り出し、下の「## 共有ルール」で @import 参照します。

  - プロジェクト固有 (ここに書く)  : 概要 / 環境 / 言語 / アーキテクチャ
  - 全プロジェクト共通 (rules/)    : 規約系
  - プロジェクト個別の上書き        : 同名ファイルをこのリポジトリの .claude/rules/ に
                                      置けば共有版より優先されます。
-->

## 概要
<!-- 例: 社内向けの在庫管理 SaaS。管理者が商品マスタと発注履歴を管理する Web アプリ。 -->

## 環境
<!-- 例:
- OS: macOS (Apple Silicon) / Ubuntu 22.04
- Node.js: 20.x (Volta で固定)
- パッケージマネージャ: pnpm 9.x
- DB: PostgreSQL 16 (ローカルは Docker Compose)
- エディタ: VSCode + 推奨拡張 (.vscode/extensions.json 参照)
-->

## 言語・フレームワーク
<!-- 例:
- 言語: TypeScript 5.x (strict: true)
- フロントエンド: Next.js 14 (App Router) / React 18 / Tailwind CSS
- バックエンド: Hono / Prisma
- バリデーション: Zod
- ホスティング: Vercel (frontend) / Fly.io (API)
-->

## アーキテクチャ・デザインパターン
<!-- 例:
- ディレクトリは `src/features/<機能名>/` で機能単位にまとめる (feature-based)
- UI 層とビジネスロジック層を分離。副作用は Server Actions に集約。
- データ取得は React Server Components、クライアント状態は zustand。
- エラーは独自 `AppError` 経由で throw し、境界層でハンドリング。
- 外部 API 呼び出しは `src/lib/clients/` にラップし直接呼ばない。
-->

## 共有ルール

> 規約系の本体は `.claude/rules/` に分割しています。
> 下記 `@import` で読み込まれます。逸脱したい項目があれば、対応する
> ファイルをこのリポジトリの `.claude/rules/` に置いて上書きしてください
> (詳細は README の「共有ルールの参照モード」を参照)。

@.claude/rules/coding.md
@.claude/rules/git.md
@.claude/rules/testing.md
@.claude/rules/security.md

<!--
  API を持つプロジェクトのみ次の行のコメントを外す:
  @.claude/rules/api.md
-->

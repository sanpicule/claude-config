# プロジェクト固有ルール

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

## コーディング規約
<!-- 例:
- フォーマッタ: Prettier (設定は .prettierrc)。保存時に自動整形。
- Linter: ESLint (設定は .eslintrc)。CI で `pnpm lint` を必ず通す。
- 命名: コンポーネントは PascalCase、hooks は `use` から始める、util は camelCase。
- 定数は UPPER_SNAKE_CASE、型は PascalCase で `Type` / `Props` サフィックス可。
- any 禁止。unknown + 型ガードを使用。
- コメントは「なぜ」を書く。「何を」はコードで表現する。
-->

## Git ルール
<!-- 例:
- ブランチ: main から `feature/xxx` / `fix/xxx` / `chore/xxx` を切る。
- コミットメッセージ: Conventional Commits (feat:, fix:, chore:, docs:, refactor:, test:)
- マージ方式: PR は squash merge。main を常にリニアに保つ。
- PR: 最低 1 人のレビュー必須。CI (lint / typecheck / test) が green であること。
- force push は自分のブランチのみ許可。main への force push は禁止。
- .env / secrets 系は絶対にコミットしない。
-->

## テスト
<!-- 例:
- 単体テスト: Vitest。`src/**/*.test.ts` を配置。新規ロジックは必須。
- コンポーネントテスト: React Testing Library。
- E2E: Playwright。主要なユーザーフローをカバー。
- カバレッジ目標: 行カバレッジ 80% 以上 (CI で計測)。
- モック方針: 外部 API はモック可、DB はテストコンテナで実物を使用。
-->

## セキュリティ・秘匿情報
<!-- 例:
- シークレットは `.env.local` に格納し、`.env.example` をダミー値で更新する。
- 本番シークレットは 1Password / AWS Secrets Manager で管理。
- 新しい依存を追加する際は `pnpm audit` で脆弱性を確認する。
- 個人情報を含むログは出力しない。構造化ログに PII マスクを適用する。
-->

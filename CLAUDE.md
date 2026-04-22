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

> 以下は GitHub Flow と Conventional Commits をベースとしたデフォルトルールです。  
> プロジェクトの事情に合わせて自由に書き換え・削除してください。

### ブランチ戦略: GitHub Flow

- `main` は常にリリース可能な状態を保ち、直接 push は禁止（Pull Request 経由のみ）。
- すべての変更は `main` から作業ブランチを切って行う。ブランチ名は種別を prefix にする:
  - 新機能: `feature/<short-description>` 例: `feature/add-hooks-template`
  - バグ修正: `fix/<short-description>` 例: `fix/setup-script-path`
  - ドキュメント: `docs/<short-description>`
  - CI / ビルド: `ci/<short-description>`
  - リファクタ・雑務: `refactor/<...>` / `chore/<...>`
- 作業ブランチは 1 つの PR で完結させ、マージ後は削除する。長命ブランチは作らない。

### コミットメッセージ: Conventional Commits

- フォーマット: `<type>: <subject>` または `<type>(<scope>): <subject>`（scope は任意。必要に応じて本文で理由や背景を記述）
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

### Pull Request

- タイトルは代表コミット同様 Conventional Commits 形式で書く。
- 本文に「変更の目的 / 主な変更点 / テスト観点」を記載する。
- CI (`lint` / `typecheck` / `test` など) が green であること。
- マージ方式は **squash merge** を推奨（`main` をリニアに保つため）。
- 直接 `main` への push・force push は禁止。作業ブランチへの force push は自分のブランチのみ許可。

### その他

- `.env` / 鍵・トークン等のシークレットは絶対にコミットしない。
- 一時ファイル・個人設定（`.claude/settings.local.json` など）は `.gitignore` で除外する。

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

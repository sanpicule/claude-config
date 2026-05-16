# claude-config

プロジェクト配下の Claude Code 設定（`CLAUDE.md` と `.claude/` 配下の設定ファイル）のテンプレートを管理するリポジトリです。

## 導入後のディレクトリ構成

セットアップを実行すると、導入先プロジェクトのルートに以下のファイルが配置されます（既存ファイルはスキップされます）。

```
your-project/
├── CLAUDE.md                     # プロジェクトルール (Claude Code に読み込まれます)
├── .mcp.json                     # MCP サーバー設定 (チーム共有、コミット対象)
└── .claude/
    ├── settings.json             # Claude Code のチーム共有設定 (コミット対象)
    ├── settings.local.json       # 個人ローカル設定 (.gitignore で除外推奨)
    ├── rules/                    # 規約系を分割配置 (CLAUDE.md から @import)
    │   ├── coding.md
    │   ├── git.md
    │   ├── testing.md
    │   ├── security.md
    │   └── api.md
    └── skills/
        ├── example-code-reviewer/
        │   └── SKILL.md           # コードレビュースキルの例
        └── example-test-writer/
            └── SKILL.md           # テスト作成スキルの例
```

各ファイルには使い方の例がコメントで記載されています。必要な箇所のコメントを外す、または書き換えて有効化してください（詳細は「テンプレートのカスタマイズ」をご参照ください）。

## CLAUDE.md と共有ルールの分離

このテンプレートは「CLAUDE.md にはプロジェクト固有の情報だけを書き、規約系は `.claude/rules/` に分割する」設計です。CLAUDE.md からは `@import` 構文で参照します。

```
CLAUDE.md                       ← 概要 / 環境 / 言語 / アーキテクチャ (プロジェクト固有)
   │
   │ @import
   ▼
.claude/rules/
   ├── coding.md                ← 命名・型・関数設計
   ├── git.md                   ← GitHub Flow + Conventional Commits
   ├── testing.md               ← テスト原則・モック方針
   ├── security.md              ← 秘匿情報・入力検証・認証
   └── api.md                   ← API レイヤを編集するときだけ参照
```

メリット:
- ルールを 1 箇所で直すだけで全プロジェクトに反映できる (DRY)。
- CLAUDE.md が短く保てる → モデルが毎回読むコンテキストが軽くなる。
- 「A プロジェクトだけ古い規約のまま」という事故が起きにくい。

### 共有ルールの参照モード

参照方法は **「コピー配信モード」** と **「共有参照モード」** の 2 通りをサポートします。
プロジェクトの運用方針に合わせて選んでください。

| モード | 参照記法 | 特徴 |
|---|---|---|
| **コピー配信** (デフォルト) | `@.claude/rules/git.md` | セットアップ時に各プロジェクトへ実体をコピー。各プロジェクトが独立。修正は配布元 + 各プロジェクトに再配布が必要。 |
| **共有参照** | `@~/.claude-config/.claude/rules/git.md` | このリポジトリをユーザーホーム等に clone し、各プロジェクトの CLAUDE.md から共有パスを参照。修正が即時反映される。 |

#### 共有参照モードのセットアップ例

```bash
# 1. このリポジトリをホーム直下に clone (1 回だけ)
git clone https://github.com/sanpicule/claude-config.git ~/.claude-config

# 2. 各プロジェクトの CLAUDE.md の @import を共有パスに書き換える
#    例: @.claude/rules/git.md → @~/.claude-config/.claude/rules/git.md
```

#### プロジェクト個別に逸脱したいとき

共有ルールから外したい項目だけ、プロジェクト直下の `.claude/rules/<同名>.md` に置いて CLAUDE.md の `@import` をそちらに向ければ、共有版より優先されます。
たとえば「このプロジェクトだけ GitFlow を使う」場合は、`.claude/rules/git.md` を上書きして配置します。

## 使い方

**推奨は「A. プロジェクトルートから実行」** の方式です。迷ったらこちらをお使いください。

### A. プロジェクトルートから実行（推奨）

導入したいプロジェクトのルートに移動してから実行します。

```bash
cd /path/to/project
curl -fsSL https://raw.githubusercontent.com/sanpicule/claude-config/main/scripts/setup-project.sh | bash -s .
```

### B. パスを指定して実行

任意のディレクトリから対象プロジェクトを絶対パスで指定します。

```bash
curl -fsSL https://raw.githubusercontent.com/sanpicule/claude-config/main/scripts/setup-project.sh | bash -s ~/Documents/my-app
```

### C. 中身を確認してから実行

パイプ to bash を避けたい場合はこちらをお使いください。

```bash
curl -fsSL https://raw.githubusercontent.com/sanpicule/claude-config/main/scripts/setup-project.sh -o /tmp/setup.sh
less /tmp/setup.sh
bash /tmp/setup.sh ~/Documents/my-app
```

## テンプレートのカスタマイズ

各テンプレートは「そのまま使える最小構成 + よく使う設定をコメントアウトで例示」という形になっています。

セットアップ後、導入先プロジェクトのファイルを開いて、必要な部分のコメントを外したり書き換えたりしてください。

### 1. `CLAUDE.md` （プロジェクトルール）

Claude Code が読み込むプロジェクト固有のルールを書くファイルです。

1. ファイルを開きます。
2. 各セクション（概要 / 技術スタック / 開発ルール など）の `<!-- ... -->` で囲まれた記入例を確認します。
3. プロジェクトの実情に合わせて書き換えます。

### 2. `.claude/settings.json` （Claude Code の設定）

Claude Code の権限設定などを書くファイルです。JSONC 形式（コメントが書ける JSON）です。

1. ファイルを開きます。
2. `permissions` の `deny` / `ask` / `allow` に、よく使う設定がコメントアウトで並んでいます。
3. 有効にしたい行の先頭 `//` を外してください。
4. 各行の右側には設定内容の説明コメントが付いています。そちらを参考に取捨選択してください。

### 3. `.mcp.json` （MCP サーバー設定）

Claude Code から外部サービス（GitHub、Postgres など）を利用するための MCP サーバー設定ファイルです。

1. ファイルを開きます。
2. `__example_xxx__` というキー名で設定例が並んでいます。
3. 使うサーバーだけ、キー名の前後の `__` を外してください（例: `__example_github__` → `github`）。
4. パスやトークンを実値に書き換えます。
5. **注意**: トークン類はファイルに直接書かず、環境変数経由で渡してください。

### 4. `.claude/settings.local.json` （個人ローカル設定）

自分だけで使う設定を書くファイルです。チームで共有したくない許可設定などを記述します。

- このファイルは適用先プロジェクトの `.gitignore` に追加して、Git 管理から除外する運用を想定しています。

### 5. `.claude/skills/` （カスタムスキル）

Claude Code がサブエージェントとして呼び出せる、プロジェクト固有のスキルを定義するディレクトリです。  
各スキルは **`<skill-name>/SKILL.md`** という形式で、スキル名のサブディレクトリ配下に `SKILL.md` を置きます。

セットアップ後、以下の 2 つのサンプルが配置されます。

| ファイル | 説明 |
|---------|------|
| `example-code-reviewer/SKILL.md` | コードレビューを行うスキルのサンプル |
| `example-test-writer/SKILL.md`   | テストコードを作成するスキルのサンプル |

#### スキルファイルの構成

```markdown
---
name: スキル名          # Claude がスキルを識別するキー（英小文字・ハイフン推奨）
description: 説明文     # Claude がいつこのスキルを使うか判断するための文章
# model: claude-opus-4-7  # 使用モデル（省略時は親セッションを引き継ぐ）
---

# スキルのシステムプロンプト（Markdown 形式）
Claude に与える詳細な指示をここに書く。
```

#### カスタマイズ手順

1. サンプルディレクトリを参考に、`.claude/skills/<新しいスキル名>/SKILL.md` を新規作成します。
2. `name` と `description` を用途に合わせて書き換えます。
3. Markdown 本文にスキルの詳細な指示（ロール・手順・出力フォーマットなど）を記述します。
4. 不要なサンプルディレクトリは削除してください。

### 自分用にテンプレート自体を変えたい場合

デフォルト値をご自身のチーム向けに作り込みたい場合は、このリポジトリを fork してからお使いください。環境変数で参照先を差し替えられます（下記「環境変数によるカスタマイズ」をご参照ください）。

## 環境変数によるカスタマイズ

fork して使う場合は、環境変数で参照先を切り替えられます。


| 変数名                    | デフォルト                     | 用途        |
| ---------------------- | ------------------------- | --------- |
| `CLAUDE_CONFIG_REPO`   | `sanpicule/claude-config` | 参照するリポジトリ |
| `CLAUDE_CONFIG_BRANCH` | `main`                    | 参照するブランチ  |


例:

```bash
CLAUDE_CONFIG_REPO=myname/claude-config \
  curl -fsSL https://raw.githubusercontent.com/myname/claude-config/main/scripts/setup-project.sh | bash -s ~/my-app
```

## 変更履歴

リリースごとの変更点は [CHANGELOG.md](CHANGELOG.md) を参照してください。

## リリース運用（メンテナ向け）

バージョニングと `CHANGELOG.md` / GitHub Release は [release-please](https://github.com/googleapis/release-please) により自動化されています。メンテナが手動でタグや Release を作成する必要はありません。

### フロー

1. [Conventional Commits](https://www.conventionalcommits.org/ja/v1.0.0/) 形式（`feat:` / `fix:` など）で main にコミットする（PR マージ）。
2. release-please GitHub Action が **release PR**（`chore(main): release x.y.z`）を自動で作成／更新する。
3. release PR をマージすると以下が自動実行される:
   - `CHANGELOG.md` の追記
   - `vx.y.z` タグの作成
   - GitHub Release の作成

### コミット種別とバージョンアップの対応

| Prefix 例 | バージョンへの影響 |
|-----------|--------------------|
| `feat: ...` | minor bump（例: 0.2.0 → 0.3.0） |
| `fix: ...` | patch bump（例: 0.2.0 → 0.2.1） |
| `feat!: ...` / 本文に `BREAKING CHANGE:` | major bump（v1.0.0 以降に有効） |
| `docs:` / `chore:` / `ci:` / `refactor:` / `test:` / `style:` / `perf:` | リリースなし |

> v0.x の間は `feat:` でも minor bump に留まります（`bump-minor-pre-major: true` 設定）。

## ライセンス

[MIT License](LICENSE) のもとで公開しています。商用・非商用を問わず自由に利用・改変・再配布いただけます。

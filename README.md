# claude-config

プロジェクト配下の Claude Code 設定（`CLAUDE.md` と `.claude/` 配下の設定ファイル）のテンプレートを管理するリポジトリ。

## ディレクトリ構成

```
claude-config/
├── CLAUDE.md                     # プロジェクトルールのテンプレート
├── .claude/
│   ├── settings.json             # チーム共有設定（コミット対象）
│   └── settings.local.json       # 個人用ローカル設定（gitignore）
└── scripts/
    └── setup-project.sh          # テンプレートを任意のプロジェクトに適用
```

`.claude/settings.json` は最低限のルール（`.env` の読み取り拒否）のみ記述。必要に応じてプロジェクトごとに追記する。

## 使い方

**推奨は「A. プロジェクトルートから実行」** の方式です。迷ったらこれを使ってください。

### A. プロジェクトルートから実行（推奨）

導入したいプロジェクトのルートに移動してから実行する:

```bash
cd /path/to/project
curl -fsSL https://raw.githubusercontent.com/sanpicule/claude-config/main/scripts/setup-project.sh | bash -s .
```

例:

```bash
cd ~/Documents/my-app
curl -fsSL https://raw.githubusercontent.com/sanpicule/claude-config/main/scripts/setup-project.sh | bash -s .
```

### B. パスを指定して実行

任意のディレクトリから対象プロジェクトを絶対パスで指定する:

```bash
curl -fsSL https://raw.githubusercontent.com/sanpicule/claude-config/main/scripts/setup-project.sh | bash -s ~/Documents/my-app
```

### C. 中身を確認してから実行

パイプ to bash を避けたい場合:

```bash
curl -fsSL https://raw.githubusercontent.com/sanpicule/claude-config/main/scripts/setup-project.sh -o /tmp/setup.sh
less /tmp/setup.sh
bash /tmp/setup.sh ~/Documents/my-app
```

### D. ローカル clone して実行

このリポジトリ自体を手元で編集したい場合:

```bash
git clone https://github.com/sanpicule/claude-config.git
bash claude-config/scripts/setup-project.sh /path/to/project
```

### 適用結果

いずれの方法でも以下が配置される（既存ファイルは上書きされずスキップ）:

- `<プロジェクト>/CLAUDE.md`
- `<プロジェクト>/.claude/settings.json`
- `<プロジェクト>/.claude/settings.local.json`

## テンプレートの編集

ルートの `CLAUDE.md` と `.claude/settings.json` を直接編集してコミット・push する。以降 `setup-project.sh` で適用されるのは編集後の内容になる。

`.claude/settings.local.json` は個人設定のため適用先では `.gitignore` で除外する運用を想定している。

## 環境変数によるカスタマイズ

fork して使う場合は環境変数で参照先を切り替えられる:

| 変数名 | デフォルト | 用途 |
|---|---|---|
| `CLAUDE_CONFIG_REPO` | `sanpicule/claude-config` | 参照するリポジトリ |
| `CLAUDE_CONFIG_BRANCH` | `main` | 参照するブランチ |

例:

```bash
CLAUDE_CONFIG_REPO=myname/claude-config \
  curl -fsSL https://raw.githubusercontent.com/myname/claude-config/main/scripts/setup-project.sh | bash -s ~/my-app
```

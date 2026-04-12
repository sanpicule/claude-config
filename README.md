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

### curl ワンライナー（推奨）

リポジトリを clone せずにそのまま適用できる:

```bash
curl -fsSL https://raw.githubusercontent.com/sanpicule/claude-config/main/scripts/setup-project.sh | bash -s /path/to/project
```

例:

```bash
curl -fsSL https://raw.githubusercontent.com/sanpicule/claude-config/main/scripts/setup-project.sh | bash -s ~/Documents/my-app
```

中身を確認してから実行したい場合:

```bash
curl -fsSL https://raw.githubusercontent.com/sanpicule/claude-config/main/scripts/setup-project.sh -o /tmp/setup.sh
less /tmp/setup.sh
bash /tmp/setup.sh ~/Documents/my-app
```

### ローカル clone して実行

```bash
git clone https://github.com/sanpicule/claude-config.git
bash claude-config/scripts/setup-project.sh /path/to/project
```

### 適用結果

どちらの方法でも以下が配置される（既存ファイルは上書きされずスキップ）:

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

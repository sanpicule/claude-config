# claude-config

Claude Code の `.claude` ディレクトリ設定を一元管理するリポジトリ。

## ディレクトリ構成

```
claude-config/
├── global/                  # ~/.claude に配置するグローバル設定
│   ├── CLAUDE.md            # グローバルルール
│   ├── settings.json        # パーミッション・フック設定
│   ├── statusline.sh        # ステータスライン表示スクリプト
│   └── skills/              # カスタムスキル
│       ├── brush-up-user-input/
│       ├── find-skills/
│       └── supabase-postgres-best-practices/
├── templates/               # プロジェクト用テンプレート
│   ├── nextjs/              # Next.js プロジェクト向け
│   │   ├── CLAUDE.md
│   │   ├── AGENTS.md
│   │   ├── settings.local.json
│   │   └── launch.json
│   └── general/             # 汎用テンプレート
│       ├── CLAUDE.md
│       └── settings.local.json
└── scripts/                 # セットアップスクリプト
    ├── setup-global.sh      # グローバル設定を反映
    ├── setup-project.sh     # プロジェクトにテンプレートを適用
    └── sync-from-live.sh    # ライブ設定をリポジトリに取り込み
```

## 使い方

### グローバル設定を反映

```bash
bash scripts/setup-global.sh
```

`~/.claude/` にグローバル設定（CLAUDE.md, settings.json, skills 等）を反映する。既存設定は自動バックアップされる。

### プロジェクトに .claude をセットアップ

```bash
bash scripts/setup-project.sh /path/to/project [テンプレート名]
```

例:
```bash
bash scripts/setup-project.sh ~/Documents/my-app nextjs
bash scripts/setup-project.sh ~/Documents/my-tool general
```

既存ファイルは上書きしない（スキップされる）。

### ライブ設定をリポジトリに同期

```bash
bash scripts/sync-from-live.sh
```

`~/.claude/` の現在の設定をリポジトリに取り込む。設定を変更した後にこのスクリプトで差分を管理する。

## テンプレートの追加

`templates/` 配下に新しいディレクトリを作成し、以下のファイルを配置する:

- `CLAUDE.md` - プロジェクトルートに配置されるルールファイル
- `AGENTS.md` - (任意) エージェント向け指示
- `settings.local.json` - `.claude/` 内に配置されるローカル設定
- `launch.json` - (任意) dev server 設定

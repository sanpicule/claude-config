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

### プロジェクトに適用

```bash
bash scripts/setup-project.sh /path/to/project
```

以下が配置される（既存ファイルは上書きされずスキップ）:

- `<プロジェクト>/CLAUDE.md`
- `<プロジェクト>/.claude/settings.json`
- `<プロジェクト>/.claude/settings.local.json`

### テンプレートの編集

ルートの `CLAUDE.md` と `.claude/settings.json` を直接編集してコミットする。以降 `setup-project.sh` で適用されるのは編集後の内容になる。

`settings.local.json` は個人設定のため `.gitignore` で除外されている。テンプレートとしてはリポジトリに含めているが、実プロジェクトでの変更はコミットされない。

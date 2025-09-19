# ドキュメント貢献ガイドライン

## 概要

このプロジェクトは数学的タスク管理フレームワークの日本語ドキュメントサイトです。**Dev Container** を使用して一貫した開発環境を提供しています。貢献をお考えいただき、ありがとうございます。

## 🚀 開発環境セットアップ

### Dev Container 使用（推奨）

このプロジェクトは **Dev Container** で最適化されており、VS Code または GitHub Codespaces ですぐに開発を始められます。

**VS Code + Dev Container**
```bash
# 1. リポジトリをクローン
git clone --recursive https://github.com/kjun1/task-management.git

# 2. VS Codeで開く
code task-management

# 3. "Reopen in Container" を選択
# Hugo Extended、Node.js、必要な拡張機能が自動セットアップ
```

**GitHub Codespaces**
- リポジトリページで「Code」→「Codespaces」→「Create codespace」
- 全ての環境が自動構築されます

### ローカル環境（Dev Container未使用時）

```bash
# 必要な要件: Hugo Extended v0.150.0+, Node.js LTS, Git
make dev-setup
```

## 貢献の種類

### 📝 コンテンツの改善
- 誤字脱字の修正
- 数式の正確性向上
- 説明の明確化
- 新しい例題や実践例の追加

### 🔧 技術的改善
- サイト構造の最適化
- アクセシビリティの向上
- パフォーマンスの改善
- CI/CD パイプラインの強化

### 🐛 問題報告
- バグレポート
- リンク切れの報告
- 表示崩れの報告

## 📝 開発ワークフロー

### 1. 新しいコンテンツの作成

```bash
# Dev Container環境内で
make new-content FILE=new-article

# または直接
hugo new content/new-article.md
```

### 2. 開発サーバーの起動

```bash
# 通常の開発サーバー
make serve

# ドラフト含めて表示
make serve-drafts
```

### 3. 品質チェック

```bash
# 全てのチェックを実行
make test

# 個別チェック
make lint           # Markdownリント
make check-links    # リンクチェック
```

## 開発環境のセットアップ（参考）

### Dev Container環境の詳細
- **Hugo Extended** v0.150.0 (自動インストール)
- **Node.js** LTS + npm
- **VS Code拡張機能**: Markdown lint, Math preview等
- **ポート転送**: 1313 (Hugo開発サーバー)

### 従来の手動セットアップ
```bash
# VS Codeでリポジトリを開き
# "Reopen in Container"を選択
```

### ローカル環境
```bash
git clone --recursive https://github.com/kjun1/task-management.git
cd task-management
make dev-setup  # 自動セットアップ
make serve      # 開発サーバー起動
```

## 貢献ワークフロー

### 1. Issue作成（推奨）
大きな変更の前にIssueを作成して議論してください。

### 2. フォーク & ブランチ作成
```bash
# フォークしたリポジトリをクローン
git clone https://github.com/YOUR_USERNAME/task-management.git
cd task-management

# フィーチャーブランチを作成
git checkout -b feature/your-feature-name
```

### 3. 開発
```bash
# 依存関係のインストール
make deps

# 開発サーバー起動
make serve

# または、ドラフト含む
make serve-drafts
```

### 4. 品質チェック
```bash
# 全チェック実行
make test

# 個別チェック
make lint           # Markdownリント
make check-links    # リンクチェック
make build          # ビルドテスト
```

### 5. コミット
コミットメッセージは日本語または英語で明確に：

```bash
git add .
git commit -m "feat: 新しい数式表記の追加"
# または
git commit -m "fix: リンク切れを修正"
```

### 6. プルリクエスト
- 変更内容を明確に説明
- 関連するIssue番号を記載
- 必要に応じてスクリーンショットを添付

## コンテンツスタイルガイド

### Markdown記法
```markdown
---
title: "記事タイトル"
type: docs
weight: 10
description: "記事の概要（150文字以内）"
---

# メインタイトル

## セクション

### サブセクション
```

### 数式記法
```markdown
# インライン数式
$E = mc^2$

# ブロック数式
$$
\sum_{i=1}^{n} x_i = x_1 + x_2 + \cdots + x_n
$$
```

### 注意点
- 日本語が主言語ですが、技術用語は英語も併記
- 数式は正確性を重視
- コードブロックには適切な言語指定を追加
- リンクは相対パスを使用

## CI/CDパイプライン

### 自動実行される項目
- **プルリクエスト時**:
  - Markdownリント
  - リンクチェック
  - ビルドテスト
  - プレビューURL生成

- **main ブランチマージ時**:
  - 本番ビルド
  - GitHub Pages デプロイ

- **週次実行**:
  - 依存関係チェック
  - セキュリティ監査
  - パフォーマンス監査

## ディレクトリ構造

```
task-management/
├── content/              # Markdownコンテンツ
│   ├── _index.md        # トップページ
│   ├── overview.md      # 概要
│   └── *.md            # 各ドキュメント
├── layouts/partials/    # テンプレート拡張
├── static/images/       # 画像ファイル
├── .github/workflows/   # CI/CD定義
└── .devcontainer/      # 開発環境設定
```

## よくある質問

### Q: 数式が正しく表示されない
A: KaTeX記法を確認してください。`$...$`（インライン）と`$$...$$`（ブロック）を正しく使用していますか？

### Q: テーマを変更したい
A: `themes/PaperMod`はサブモジュールです。`layouts/partials/`で拡張してください。

### Q: 新しいページが表示されない
A: `hugo.yaml`のメニュー設定を確認し、frontmatterの`weight`でソート順を調整してください。

## サポート

### 技術的な質問
- GitHub Issuesで質問を投稿
- ディスカッションでの議論

### 緊急時
- セキュリティ問題: private issueで報告
- サイトダウン: 直接連絡

## ライセンス

貢献されたコンテンツは、プロジェクトと同じライセンス（MIT）の下で公開されます。

---

貢献いただき、ありがとうございます！🙏
# Task Management Documentation

[![GitHub Pages](https://github.com/kjun1/task-management/actions/workflows/hugo.yml/badge.svg)](https://github.com/kjun1/task-management/actions/workflows/hugo.yml)
[![Quality Check](https://github.com/kjun1/task-management/actions/workflows/quality-check.yml/badge.svg)](https://github.com/kjun1/task-management/actions/workflows/quality-check.yml)
[![Security & Dependencies](https://github.com/kjun1/task-management/actions/workflows/security-deps.yml/badge.svg)](https://github.com/kjun1/task-management/actions/workflows/security-deps.yml)

[![Hugo Version](https://img.shields.io/badge/Hugo-0.150.0-blue.svg)](https://gohugo.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Live Site](https://img.shields.io/badge/Live%20Site-Available-brightgreen.svg)](https://kjun1.github.io/task-management)
[![Language](https://img.shields.io/badge/Language-Japanese-red.svg)](https://github.com/kjun1/task-management)
[![Theme](https://img.shields.io/badge/Theme-PaperMod-orange.svg)](https://github.com/adityatelange/hugo-PaperMod)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/kjun1/task-management/commits/main)

このリポジトリは、タスク管理に関する包括的なドキュメンテーションサイトです。[Hugo](https://gohugo.io/) と [PaperMod](https://github.com/adityatelange/hugo-PaperMod) テーマを使用して構築されています。

## 🌐 サイト

ドキュメンテーションサイトは以下のURLで公開されています：

**<https://kjun1.github.io/task-management>**

## 📚 ドキュメント構成

- **概要** - プロジェクト全体の概要と基本概念
- **実装ガイド** - 実装に関する詳細ガイドと技術仕様
- **外部レイヤー仕様** - 外部システムとの連携仕様
- **実践例** - 具体的な使用例とベストプラクティス
- **プロジェクト例** - サンプルプロジェクトとコード例

## 🚀 開発環境のセットアップ

### 前提条件

- [Hugo](https://gohugo.io/installation/) (Extended版推奨)
- Git

### ローカル開発

1. リポジトリをクローン:

```bash
git clone https://github.com/kjun1/task-management.git
cd task-management
```

2. Gitサブモジュールを初期化（テーマのダウンロード）:

```bash
git submodule update --init --recursive
```

3. ローカルサーバーを起動:

```bash
hugo server -D
```

4. ブラウザで <http://localhost:1313> にアクセス

### 新しいドキュメントを追加

```bash
hugo new content/new-document.md
```

## 📝 記事の書き方

### フロントマター

各マークダウンファイルの先頭には以下のフロントマターを設定してください：

```yaml
---
title: "記事タイトル"
date: 2025-09-19
draft: false
description: "記事の概要"
---
```

### 数式のサポート

このサイトではKaTeXによる数式表示をサポートしています：

- インライン数式: `$E = mc^2$`
- ブロック数式:

```math
$$
\sum_{i=1}^{n} x_i = x_1 + x_2 + \cdots + x_n
$$
```

## 🔧 サイト設定

サイトの設定は `hugo.yaml` ファイルで管理されています：

- **ベースURL**: `https://kjun1.github.io/task-management`
- **言語**: 日本語 (`ja-jp`)
- **テーマ**: PaperMod

## 🚀 デプロイ

GitHub Actionsを使用して自動デプロイを行っています。`main` ブランチへのプッシュ時に自動的にGitHub Pagesにデプロイされます。

デプロイワークフローは `.github/workflows/hugo.yml` で定義されています。

## 📁 プロジェクト構造

```text
.
├── content/                 # マークダウンコンテンツ
│   ├── _index.md           # ホームページ
│   ├── overview.md         # 概要
│   ├── implementation_guide.md
│   ├── external_layer_specification.md
│   ├── practical_example.md
│   └── example_project.md
├── layouts/                # カスタムレイアウト
├── static/                 # 静的ファイル
├── themes/PaperMod/        # Hugoテーマ (サブモジュール)
├── public/                 # 生成されたサイト
├── hugo.yaml              # Hugo設定ファイル
└── .github/workflows/     # GitHub Actions
```

## 🤝 貢献

1. このリポジトリをフォーク
2. フィーチャーブランチを作成: `git checkout -b feature/new-feature`
3. 変更をコミット: `git commit -am 'Add new feature'`
4. ブランチにプッシュ: `git push origin feature/new-feature`
5. プルリクエストを作成

## 📄 ライセンス

このプロジェクトは[MIT License](./LICENSE)の下で提供されています。

Hugo PaperModテーマは[MIT License](https://github.com/adityatelange/hugo-PaperMod/blob/master/LICENSE)の下で提供されています。

## 📞 サポート

質問や問題がある場合は、[Issues](https://github.com/kjun1/task-management/issues)からお気軽にお問い合わせください。

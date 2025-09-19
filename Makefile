# Makefile for Hugo static site development

# Variables
HUGO_VERSION := 0.150.0
PORT := 1313
PUBLIC_DIR := public

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m # No Color

.PHONY: help install serve build clean test lint deploy deps-check

# Default target
help: ## このヘルプメッセージを表示
	@echo "$(GREEN)Task Management Hugo Site - Available commands:$(NC)"
	@echo "$(YELLOW)Note: This project uses Dev Container for consistent development environment$(NC)"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Hugoをローカルにインストール（Dev Container環境では不要）
	@echo "$(GREEN)Installing Hugo Extended v$(HUGO_VERSION)...$(NC)"
	@if [ -n "$$CODESPACES" ] || [ -n "$$DEVCONTAINER" ]; then \
		echo "$(YELLOW)Running in Dev Container - Hugo should already be installed$(NC)"; \
		hugo version; \
	elif command -v hugo > /dev/null 2>&1; then \
		echo "Hugo is already installed: $$(hugo version)"; \
	else \
		wget -O /tmp/hugo.deb "https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)/hugo_extended_$(HUGO_VERSION)_linux-amd64.deb" && \
		sudo dpkg -i /tmp/hugo.deb && \
		rm /tmp/hugo.deb; \
	fi

deps: ## 依存関係をインストール
	@echo "$(GREEN)Installing dependencies...$(NC)"
	@git submodule update --init --recursive
	@if [ -f "package.json" ]; then npm ci; fi

serve: deps ## 開発サーバーを起動
	@echo "$(GREEN)Starting Hugo development server on port $(PORT)...$(NC)"
	@hugo server --bind 0.0.0.0 --port $(PORT) --disableFastRender

serve-drafts: deps ## ドラフト含めて開発サーバーを起動
	@echo "$(GREEN)Starting Hugo development server with drafts...$(NC)"
	@hugo server --bind 0.0.0.0 --port $(PORT) --buildDrafts --buildFuture

build: deps ## 本番用ビルド
	@echo "$(GREEN)Building site for production...$(NC)"
	@hugo --gc --minify
	@echo "$(GREEN)Build complete! Files in $(PUBLIC_DIR)/$(NC)"

clean: ## ビルド成果物を削除
	@echo "$(YELLOW)Cleaning build artifacts...$(NC)"
	@rm -rf $(PUBLIC_DIR) resources/_gen .hugo_build.lock

test: build ## 基本的なテストを実行
	@echo "$(GREEN)Running tests...$(NC)"
	@# Check if hugo builds without errors
	@hugo --quiet --buildDrafts --buildFuture || (echo "$(RED)Hugo build failed$(NC)" && exit 1)
	@# Check for broken internal links
	@if command -v htmltest > /dev/null 2>&1; then \
		htmltest; \
	else \
		echo "$(YELLOW)htmltest not installed, skipping link checking$(NC)"; \
	fi

lint: ## Markdownファイルのリント
	@echo "$(GREEN)Linting markdown files...$(NC)"
	@if command -v markdownlint > /dev/null 2>&1; then \
		markdownlint content/**/*.md; \
	else \
		echo "$(YELLOW)markdownlint not installed, run: npm install -g markdownlint-cli$(NC)"; \
	fi

check-links: ## リンクをチェック
	@echo "$(GREEN)Checking links in markdown files...$(NC)"
	@if command -v markdown-link-check > /dev/null 2>&1; then \
		find content -name "*.md" -exec markdown-link-check {} \;; \
	else \
		echo "$(YELLOW)markdown-link-check not installed, run: npm install -g markdown-link-check$(NC)"; \
	fi

deps-check: ## 依存関係の更新チェック
	@echo "$(GREEN)Checking for dependency updates...$(NC)"
	@echo "Current Hugo version: $(shell hugo version 2>/dev/null || echo 'Not installed')"
	@echo "Target Hugo version: $(HUGO_VERSION)"
	@cd themes/PaperMod && git fetch origin && git status

new-content: ## 新しいコンテンツファイルを作成 (usage: make new-content FILE=filename)
	@if [ -z "$(FILE)" ]; then \
		echo "$(RED)Please specify FILE=filename$(NC)"; \
		echo "Example: make new-content FILE=new-article"; \
		exit 1; \
	fi
	@echo "$(GREEN)Creating new content file...$(NC)"
	@hugo new content/$(FILE).md
	@echo "$(GREEN)Created content/$(FILE).md$(NC)"

theme-update: ## テーマを最新版に更新
	@echo "$(GREEN)Updating PaperMod theme...$(NC)"
	@git submodule update --remote themes/PaperMod
	@echo "$(GREEN)Theme updated!$(NC)"

dev-setup: install deps ## 開発環境の完全セットアップ
	@echo "$(GREEN)Development environment setup complete!$(NC)"
	@if [ -n "$$CODESPACES" ] || [ -n "$$DEVCONTAINER" ]; then \
		echo "$(GREEN)✓ Running in Dev Container - optimized environment ready$(NC)"; \
	fi
	@echo "Run 'make serve' to start the development server"

prod-test: clean build test ## 本番環境用の完全テスト
	@echo "$(GREEN)Production test complete!$(NC)"
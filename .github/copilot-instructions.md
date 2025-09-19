# AI Coding Agent Instructions

## Project Overview

This is a **Japanese-language Hugo documentation site** for a mathematical task management framework. The site focuses on formal mathematical definitions, equations, and theoretical concepts presented through Hugo static site generation with the PaperMod theme.

### Architecture

- **Hugo Static Site**: Uses Hugo extended for mathematical content rendering
- **PaperMod Theme**: Git submodule in `themes/PaperMod/`
- **Japanese Content**: Primary language is Japanese (`ja-jp`)
- **Mathematical Focus**: Heavy use of KaTeX for mathematical notation
- **GitHub Pages Deployment**: Automated via GitHub Actions

## Critical Knowledge

### Mathematical Content Patterns

This site renders complex mathematical notation extensively. When editing content:

```markdown
# Inline math: $E = mc^2$
# Block math:
$$
\sum_{i=1}^{n} x_i = x_1 + x_2 + \cdots + x_n
$$
```

The Hugo configuration supports both `$...$` and `\(...\)` delimiters for inline math, and `$$...$$` and `\[...\]` for display math.

### Content Structure Convention

All content files follow this frontmatter pattern:
```yaml
---
title: "記事タイトル"
type: docs
weight: 10  # For menu ordering
description: "記事の概要"
url: "/override-url/"  # Optional URL override
---
```

### Menu Configuration

Navigation menu is defined in `hugo.yaml` under `menu.main`. Each entry requires:
- `identifier`: unique key
- `name`: Japanese display name
- `url`: target URL
- `weight`: ordering (10, 20, 30...)

### Math Rendering Setup

Math support is enabled through:
1. `layouts/partials/math.html` - KaTeX integration
2. `layouts/partials/extend_head.html` - includes math partial
3. `hugo.yaml` params: `math: true`
4. Markup configuration with passthrough delimiters

## Development Workflows

### Local Development
```bash
# Clone with submodules (essential for theme)
git submodule update --init --recursive

# Start dev server with drafts
hugo server -D

# Build for production
hugo --gc --minify
```

### Creating New Content
```bash
# Generate new content file
hugo new content/new-document.md

# Edit the frontmatter weight to control menu order
```

### Theme Customization

- Custom partials in `layouts/partials/` override theme defaults
- `extend_head.html` is the primary customization point
- Never edit files in `themes/PaperMod/` directly (it's a submodule)

## Deployment Details

- **Auto-deploy**: Triggered on `main` branch pushes
- **Hugo Version**: Pinned to 0.150.0 in workflow
- **Build Command**: `hugo --gc --minify --baseURL`
- **Artifact Path**: `./public`

GitHub Actions workflow handles:
1. Hugo CLI installation (extended version)
2. Submodule checkout with `recursive: true`
3. Production build with garbage collection and minification
4. Pages artifact upload and deployment

## Japanese Language Considerations

- All content should be in Japanese unless specifically English technical terms
- URL slugs can use English but display text should be Japanese
- Menu items and descriptions follow Japanese conventions
- Mathematical notation is universal but explanatory text is Japanese

## File Organization

```
content/           # All markdown content (Japanese)
├── _index.md     # Site homepage
├── overview.md   # Mathematical framework overview
└── *.md          # Individual documentation pages

layouts/partials/ # Theme customizations only
└── math.html     # KaTeX mathematical rendering

hugo.yaml         # Central configuration (Japanese locale)
```

## Common Tasks

- **Add new section**: Create markdown in `content/`, update menu in `hugo.yaml`
- **Math equations**: Use `$$` for display math, `$` for inline
- **Theme updates**: `git submodule update --remote themes/PaperMod`
- **Preview changes**: Always test locally with `hugo server -D`
- **URL structure**: Controlled by frontmatter `url` field, not filename

## Key Configuration Points

- BaseURL: `https://kjun1.github.io/task-management`
- Language: `ja-jp` with `defaultContentLanguage: ja`
- Math: Enabled globally with KaTeX 0.16.4
- Theme: PaperMod with extensive customization in `params`
- Markup: Goldmark with math passthrough and syntax highlighting
# WiseZenn's Blog

🏠 **Personal Blog** | [https://wisezenn.github.io](https://wisezenn.github.io)

A personal blog built with the [al-folio](https://github.com/alshedivat/al-folio) academic template.

---

## Quick Start

### Local Development

```bash
# Start development server (also cleans _site)
./scripts/serve.ps1
```

Visit http://localhost:8040 to preview the blog.

### Build & Deploy

```bash
# Build static files
./scripts/build.ps1

# Deploy to GitHub Pages
./scripts/deploy.ps1

# Or do it all — validate, build, deploy, then verify the live URLs
./scripts/publish.ps1
```

### Writing A Post

```bash
# Scaffold a paired zh/en post from a draft: frontmatter, lang-ref,
# series_order, image renaming and CDN link rewriting
./scripts/new-post.ps1 -Draft "D:\Desktop\Blog\Drafts\foo.md" -Slug foo -Series geek-survival-guide -Tags "A,B"

# Push staged images to the CDN (PicGo CLI by default; -Via Api | Gui | Cli to override)
./scripts/upload-images.ps1 -Slug foo

# Force a specific backend
./scripts/upload-images.ps1 -Slug foo -Via Api

# Check posts before publishing (pipes, links, CDN images, frontmatter pairing)
./scripts/validate_posts.ps1 -CheckImages
```

---

## Features

- **Bilingual (EN/ZH)**: Full i18n via jekyll-polyglot with language toggle in navbar
- **Blog system**: Posts with tags/categories, contribution heatmap, series support
- **Course materials**: Data-driven course resource cards with CDN-hosted downloads
- **CV/Resume**: `cv_format: rendercv` is what the live pages use; the JSONResume source at `assets/json/resume.json` is kept valid as the alternative
- **Giscus comments**: Theme-aware comment system that follows dark/light mode
- **Dark/light/system theme**: Full theme toggle with persistence
- **Search**: Modal search via ninja-keys with keyboard shortcut (titles and descriptions only)

### Shipped With The Theme, Not Populated Here

These are wired up but have no content, so their pages render empty. Kept because
turning them on later is just a matter of adding files:

- **Bookshelf** (`_books/`), **News** (`_news/`), **Projects** (`_projects/`) — the
  collections are configured with `output: true`, but the directories are empty.
- **Image gallery** — `_includes/image_gallery.liquid` exists; no page includes it.

---

## Related Repositories

- 📝 **Blog Repository**: [WiseZenn/wisezenn.github.io](https://github.com/WiseZenn/wisezenn.github.io)
- 🖼️ **Image Hosting**: [WiseZenn/Blog-assets](https://github.com/WiseZenn/Blog-assets)

## Documentation

- [User Guide](docs/DOCS_GUIDE.md)
- [Architecture and Change Guide](docs/ARCHITECTURE_CHANGE_GUIDE.md)
- [Change Decision Tree](docs/CHANGE_DECISION_TREE.md)
- [Maintenance Runbook](docs/MAINTENANCE_RUNBOOK.md)
- [Documentation Governance](docs/DOCUMENTATION_GOVERNANCE.md)
- [Customize Guide](customize.md)
- [Prompt Guide (AI Rules + Task Templates)](docs/prompt/PROMPT_GUIDE.md)
- [Image Hosting Setup](docs/IMAGE_HOSTING.md)

### Suggested Reading Order

1. Architecture and Change Guide
2. Change Decision Tree
3. Maintenance Runbook
4. Documentation Governance
5. Customize Guide
6. User Guide

### Documentation Sync Policy

Architecture-impacting changes must update related docs in the same change set.
Validation is enforced by `scripts/validate_structure.ps1`.

---

## License

This site is open-sourced under the MIT License. Thanks to the al-folio template authors.

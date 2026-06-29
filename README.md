# WiseZenn's Blog

🏠 **Personal Blog** | [https://wisezenn.github.io](https://wisezenn.github.io)

A personal blog built with the [al-folio](https://github.com/alshedivat/al-folio) academic template.

---

## Quick Start

### Local Development

```bash
# Start development server
docker compose up
```

Visit http://localhost:8040 to preview the blog.

### Build & Deploy

```bash
# Build static files
./scripts/build.ps1

# Deploy to GitHub Pages
./scripts/deploy.ps1
```

---

## Features

- **Bilingual (EN/ZH)**: Full i18n via jekyll-polyglot with language toggle in navbar
- **Blog system**: Paginated posts with tags/categories, contribution heatmap, series support
- **Course materials**: Data-driven course resource cards with CDN-hosted downloads
- **Bookshelf**: Reading tracker with cover images, star ratings, and reading status
- **CV/Resume**: Dual-format support (RenderCV YAML and JSONResume JSON)
- **News system**: Auto-classification with type badges (publication/award/talk/funding)
- **Image gallery**: Responsive grid gallery with medium-zoom lightbox support
- **Giscus comments**: Theme-aware comment system that follows dark/light mode
- **Dropdown navigation**: Template for grouping pages under a dropdown menu
- **Dark/light/system theme**: Full theme toggle with persistence
- **Search**: Modal search via ninja-keys with keyboard shortcut

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

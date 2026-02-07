# Design system for SFG TERMINAL HUB

This repository uses lightweight, custom design tokens and component patterns so the site stays consistent and easy to maintain.

Files
- `assets/css/tokens.css` — design tokens (colors, spacing, radii, shadows, type scale).
- `assets/css/style.css` — organized stylesheet using tokens; contains base layout and components.

Guidelines
- Use design tokens via CSS variables. Don't hard-code colors or spacing.
- Keep styles modular: group component rules under comments and use descriptive class names.
- Use `clamp()` for fluid typography and responsive breakpoints of 880px and 480px.

Components
- Header: `.site-header` and `.main-nav a` — active link uses underline via `::after`.
- Buttons: `.btn`, `.btn.primary`, `.btn.ghost` — use tokens for colors and shadows.
- Hero & Cards: use `.preview-box`, `.card` classes and rely on `--card` and `--glass` tokens for background.

Next steps (if you want me to implement):
- Add a component directory and split CSS into partials (requires adding an import step or build).
- Create a small preview HTML snippet for each component for quick review.
- Add visual tests/screenshots and a tiny Storybook-style page for components.

Want me to start applying the full redesign (header, hero, CTA, script cards) now? Reply “Yes, apply redesign” and I’ll implement a polished, organized layout matching the screenshot while keeping your current palette.
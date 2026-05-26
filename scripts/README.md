# QA Scripts

Automated quality checks that run on every PR to `main` via GitHub Actions.

## Checks

| Script | What it catches | Blocks merge? |
|--------|----------------|:-------------:|
| `check-structure.js` | Missing README.md, setup.sql, or solutions.sql in published day folders | Yes |
| `check-readme-template.js` | Missing required sections (What You'll Learn, Exercises, Key Concepts) | Yes |
| `check-no-inline-sql.js` | SQL dumps pasted into READMEs instead of kept in .sql files | Yes |
| `check-links.js` | Broken relative links between days and to SQL files | Yes |
| `check-sql.js` | Empty SQL files, unbalanced parentheses, unclosed strings | Yes |

## Running locally

```bash
node scripts/check-structure.js
node scripts/check-readme-template.js
node scripts/check-no-inline-sql.js
node scripts/check-links.js
node scripts/check-sql.js
```

## Branch protection (apply manually in GitHub Settings)

1. Go to **Settings > Branches > Add branch protection rule**
2. Branch name pattern: `main`
3. Enable:
   - Require a pull request before merging
   - Require status checks to pass before merging
   - Select: `Folder Structure`, `Markdown Quality`, `Link Checker`, `SQL Validation`
   - Do not allow bypassing the above settings
4. Save

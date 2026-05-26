#!/usr/bin/env node

/**
 * Validates relative links in markdown files.
 * Checks that ../day-XX/ references and file links (setup.sql, solutions.sql) exist.
 * Does NOT check external URLs (YouTube etc.) - that would need network access.
 */

const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const errors = [];

function checkFile(filePath) {
  const content = fs.readFileSync(filePath, 'utf8');
  const dir = path.dirname(filePath);

  // Match markdown links: [text](relative/path) - skip http/https
  const linkRegex = /\[([^\]]*)\]\(([^)]+)\)/g;
  let match;

  while ((match = linkRegex.exec(content)) !== null) {
    const target = match[2];

    // Skip external URLs, anchors, and known placeholders
    if (target.startsWith('http') || target.startsWith('#') || target.startsWith('mailto:')) continue;
    if (target === 'COMING_SOON') continue;

    // Strip anchor from path
    const cleanTarget = target.split('#')[0];
    if (!cleanTarget) continue;

    const resolved = path.resolve(dir, cleanTarget);

    if (!fs.existsSync(resolved)) {
      const rel = path.relative(ROOT, filePath);
      errors.push(`${rel}: broken link [${match[1]}](${target})`);
    }
  }
}

// Check all README.md files
for (let i = 1; i <= 30; i++) {
  const day = String(i).padStart(2, '0');
  const readme = path.join(ROOT, `day-${day}`, 'README.md');
  if (fs.existsSync(readme)) checkFile(readme);
}

// Check root README
const rootReadme = path.join(ROOT, 'README.md');
if (fs.existsSync(rootReadme)) checkFile(rootReadme);

if (errors.length > 0) {
  console.error('Link check FAILED:\n');
  errors.forEach(e => console.error(`  - ${e}`));
  process.exit(1);
} else {
  console.log('Link check PASSED: all relative links resolve.');
}

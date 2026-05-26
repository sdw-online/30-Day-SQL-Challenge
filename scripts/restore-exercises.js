#!/usr/bin/env node

/**
 * Restores exercises and key concepts from git history into current READMEs.
 * The rewrite-day-readmes.js script lost these sections due to regex issues.
 * This script:
 * 1. Gets old README from git (HEAD~1)
 * 2. Extracts ## Exercises ... up to ## Key Concepts
 * 3. Extracts ## Key Concepts Covered ... up to next --- or EOF
 * 4. Injects them into the current README at the right position
 */

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');

for (let i = 1; i <= 13; i++) {
  const dd = String(i).padStart(2, '0');
  const dayDir = `day-${dd}`;

  // Get old README from git
  let oldContent;
  try {
    oldContent = execSync(`git show 0fc1ff8~1:${dayDir}/README.md`, { cwd: ROOT, encoding: 'utf8' });
  } catch (e) {
    console.log(`${dayDir}: no old README found, skipping`);
    continue;
  }

  // Extract exercises section (## Exercises to ## Key Concepts)
  const exerciseMatch = oldContent.match(/^## Exercises\b[^\n]*\n([\s\S]*?)(?=^## Key Concepts)/m);
  const exercises = exerciseMatch ? exerciseMatch[1].trim() : null;

  // Extract key concepts (## Key Concepts Covered to --- or [<< or EOF)
  const conceptMatch = oldContent.match(/^## Key Concepts[^\n]*\n([\s\S]*?)(?=^---\s*$|^\[<<|$)/m);
  const concepts = conceptMatch ? conceptMatch[1].trim() : null;

  if (!exercises) {
    console.log(`${dayDir}: could not extract exercises`);
    continue;
  }

  // Read current README
  const readmePath = path.join(ROOT, dayDir, 'README.md');
  let current = fs.readFileSync(readmePath, 'utf8');

  // Remove existing exercises/concepts sections if present (will re-add from old)
  current = current.replace(/## Exercises[\s\S]*?(?=## Where To Next\?)/, '');
  current = current.replace(/## Key Concepts[\s\S]*?(?=## Where To Next\?|## Exercises)/, '');

  // Find insertion point: after Quick Setup section (before ## Where To Next?)
  const insertBefore = '## Where To Next?';
  const insertIdx = current.indexOf(insertBefore);

  if (insertIdx === -1) {
    console.log(`${dayDir}: could not find insertion point`);
    continue;
  }

  // Build the sections to insert
  let insert = '';
  insert += `## Exercises\n\n${exercises}\n\n`;
  insert += `### Solutions\n\nFinished? Check your answers: [\`solutions.sql\`](solutions.sql)\n\n---\n\n`;

  if (concepts) {
    insert += `## Key Concepts\n\n${concepts}\n\n---\n\n`;
  }

  // Insert before "Where To Next?"
  const newContent = current.slice(0, insertIdx) + insert + current.slice(insertIdx);
  fs.writeFileSync(readmePath, newContent);
  console.log(`${dayDir}: restored exercises${concepts ? ' + key concepts' : ''}`);
}

console.log('\nDone.');

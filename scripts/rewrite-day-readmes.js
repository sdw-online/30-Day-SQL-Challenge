#!/usr/bin/env node

/**
 * Rewrites all 30 day READMEs with the new template.
 * Preserves existing exercise content, strips inline SQL dumps,
 * adds concept card, badges, hints, navigation tree.
 *
 * Strategy:
 * - For days with existing content: extract exercises + key concepts, wrap in new template
 * - Strip everything inside <details> that contains CREATE TABLE / INSERT INTO
 * - Add concept card SVG, badges, nav tree
 */

const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');

// Day metadata - must match generate-day-banners.js
const days = [
  { day: 1, topic: 'Introduction to SQL & Databases', slug: 'intro-to-sql', diff: 'Beginner', week: 1, video: 'https://www.youtube.com/watch?v=mFIMPhiO-N0' },
  { day: 2, topic: 'SELECT & WHERE', slug: 'select-where', diff: 'Beginner', week: 1, video: 'https://www.youtube.com/watch?v=-0uVBtXCZ_s' },
  { day: 3, topic: 'ORDER BY & LIMIT', slug: 'order-by-limit', diff: 'Beginner', week: 1, video: 'https://www.youtube.com/watch?v=s86nI9dPZqY' },
  { day: 4, topic: 'Aggregate Functions & GROUP BY', slug: 'group-by', diff: 'Beginner', week: 1, video: 'https://www.youtube.com/watch?v=7IWrvTIrIkg' },
  { day: 5, topic: 'INSERT, UPDATE & DELETE', slug: 'insert-update-delete', diff: 'Beginner', week: 1, video: 'https://www.youtube.com/watch?v=NJ4ujmOZt60' },
  { day: 6, topic: 'Primary & Foreign Keys', slug: 'keys-constraints', diff: 'Beginner', week: 1, video: 'https://www.youtube.com/watch?v=1AdFU8Vdq-0' },
  { day: 7, topic: 'Project: Freight & Logistics Report', slug: 'project-freight', diff: 'Beginner', week: 1, video: 'https://youtu.be/fiBYAziNtGI' },
  { day: 8, topic: 'NULL Handling', slug: 'null-handling', diff: 'Intermediate', week: 2, video: 'https://www.youtube.com/watch?v=0nH464EoZ9w' },
  { day: 9, topic: 'String & Numeric Functions', slug: 'string-numeric', diff: 'Intermediate', week: 2, video: 'https://www.youtube.com/watch?v=h6J7AajBD6w' },
  { day: 10, topic: 'Date Functions & CAST', slug: 'date-functions', diff: 'Intermediate', week: 2, video: 'https://youtu.be/Iturx2kgs1A' },
  { day: 11, topic: 'CASE WHEN', slug: 'case-when', diff: 'Intermediate', week: 2, video: 'https://youtu.be/eZ5iTTsKGkI' },
  { day: 12, topic: 'Subqueries & Temp Tables', slug: 'subqueries', diff: 'Intermediate', week: 2, video: 'https://youtu.be/SOt5jUrzKOU' },
  { day: 13, topic: 'CTEs (Part 1)', slug: 'ctes', diff: 'Intermediate', week: 2, video: 'https://youtu.be/IijQJAfqcJc' },
  { day: 14, topic: 'Project: Fleet Intelligence Pipeline', slug: 'project-fleet', diff: 'Intermediate', week: 2, video: 'COMING_SOON' },
  { day: 15, topic: 'JOINs Part 1: INNER, LEFT, RIGHT, FULL OUTER', slug: 'joins', diff: 'Intermediate', week: 3, video: 'COMING_SOON' },
  { day: 16, topic: 'CROSS JOIN & Self Joins', slug: 'cross-self-join', diff: 'Intermediate', week: 3, video: 'COMING_SOON' },
  { day: 17, topic: 'UNION & UNION ALL', slug: 'union', diff: 'Intermediate', week: 3, video: 'COMING_SOON' },
  { day: 18, topic: 'Normalisation & Denormalisation', slug: 'normalisation', diff: 'Intermediate', week: 3, video: 'COMING_SOON' },
  { day: 19, topic: 'Recursive CTEs', slug: 'recursive-ctes', diff: 'Advanced', week: 3, video: 'COMING_SOON' },
  { day: 20, topic: 'Data Modelling (Star Schema)', slug: 'star-schema', diff: 'Advanced', week: 3, video: 'COMING_SOON' },
  { day: 21, topic: 'Project: SaaS Trial-to-Paid Conversion', slug: 'project-saas', diff: 'Advanced', week: 3, video: 'COMING_SOON' },
  { day: 22, topic: 'Window Functions Part 1', slug: 'window-functions-1', diff: 'Advanced', week: 4, video: 'COMING_SOON' },
  { day: 23, topic: 'Window Functions Part 2', slug: 'window-functions-2', diff: 'Advanced', week: 4, video: 'COMING_SOON' },
  { day: 24, topic: 'SCD Types & MERGE', slug: 'scd-merge', diff: 'Advanced', week: 4, video: 'COMING_SOON' },
  { day: 25, topic: 'Views & Materialised Views', slug: 'views', diff: 'Advanced', week: 4, video: 'COMING_SOON' },
  { day: 26, topic: 'Information Schema & Metadata', slug: 'information-schema', diff: 'Advanced', week: 4, video: 'COMING_SOON' },
  { day: 27, topic: 'CREATE FUNCTION (UDFs)', slug: 'udfs', diff: 'Advanced', week: 4, video: 'COMING_SOON' },
  { day: 28, topic: 'EXPLAIN & Indexing', slug: 'explain-indexing', diff: 'Advanced', week: 4, video: 'COMING_SOON' },
  { day: 29, topic: 'PostgreSQL Pro Tips', slug: 'pro-tips', diff: 'Advanced', week: 4, video: 'COMING_SOON' },
  { day: 30, topic: 'Capstone: FinTech Lending Analytics', slug: 'capstone', diff: 'Advanced', week: 4, video: 'COMING_SOON' },
];

function extractSection(content, heading) {
  // Extract content between ## heading and next ## heading
  const regex = new RegExp(`^## ${heading}\\b[^\\n]*\\n([\\s\\S]*?)(?=^## |$)`, 'm');
  const match = content.match(regex);
  return match ? match[1].trim() : null;
}

function extractExercisesAndConcepts(content) {
  // Get everything from ## Exercises to ## Key Concepts (inclusive of both)
  const exerciseMatch = content.match(/^## Exercises\b[^\n]*\n([\s\S]*?)(?=^## Key Concepts|$)/m);
  const conceptMatch = content.match(/^## Key Concepts[^\n]*\n([\s\S]*?)(?=^## |^---\s*$|$)/m);

  return {
    exercises: exerciseMatch ? exerciseMatch[1].trim() : null,
    concepts: conceptMatch ? conceptMatch[1].trim() : null,
  };
}

function extractDatasetDescription(content) {
  // Get dataset section but strip the SQL dump inside <details>
  const datasetMatch = content.match(/^## Dataset\b[^\n]*\n([\s\S]*?)(?=^## |$)/m);
  if (!datasetMatch) return null;

  let dataset = datasetMatch[1];
  // Remove <details> blocks containing SQL
  dataset = dataset.replace(/<details>[\s\S]*?<\/details>/g, '').trim();
  // Remove "Run the SQL..." instructions (we'll replace with Quick Setup)
  dataset = dataset.replace(/Run (the |this )?SQL.*?\./g, '').trim();
  return dataset || null;
}

function extractWhatYoullLearn(content) {
  const match = content.match(/^## What You'll Learn\b[^\n]*\n([\s\S]*?)(?=^## |^---)/m);
  return match ? match[1].trim() : null;
}

function prevDay(d) {
  if (d.day === 1) return null;
  return days.find(x => x.day === d.day - 1);
}

function nextDay(d) {
  if (d.day === 30) return null;
  return days.find(x => x.day === d.day + 1);
}

function generateReadme(d, existingContent) {
  const dd = String(d.day).padStart(2, '0');
  const prev = prevDay(d);
  const next = nextDay(d);

  const videoLink = d.video === 'COMING_SOON' ? 'COMING_SOON' : d.video;
  const videoBadge = d.video === 'COMING_SOON'
    ? ''
    : `  <a href="${d.video}"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>\n`;

  // Extract from existing content
  const whatYoullLearn = existingContent ? extractWhatYoullLearn(existingContent) : null;
  const datasetDesc = existingContent ? extractDatasetDescription(existingContent) : null;
  const { exercises, concepts } = existingContent ? extractExercisesAndConcepts(existingContent) : { exercises: null, concepts: null };

  // Determine if this day has SQL files
  const hasSetup = fs.existsSync(path.join(ROOT, `day-${dd}`, 'setup.sql'));
  const hasExercise = fs.existsSync(path.join(ROOT, `day-${dd}`, 'exercise.sql'));

  // Build nav links
  const prevLink = prev ? `[<< Day ${prev.day}: ${prev.topic}](../day-${String(prev.day).padStart(2, '0')}/)` : 'Start of challenge';
  const nextLink = next ? `[Day ${next.day}: ${next.topic} >>](../day-${String(next.day).padStart(2, '0')}/)` : 'Challenge complete!';

  // Build prev/next for bottom nav
  const prevBottom = prev ? `<a href="../day-${String(prev.day).padStart(2, '0')}/">&#9664; Day ${prev.day}: ${prev.topic}</a>` : '';
  const nextBottom = next ? `<a href="../day-${String(next.day).padStart(2, '0')}/">Day ${next.day}: ${next.topic} &#9654;</a>` : '';
  const bottomNav = [prevBottom, nextBottom].filter(Boolean).join(' &nbsp;&nbsp;|&nbsp;&nbsp; ');

  let md = '';

  // Concept card
  md += `<p align="center">\n  <img src="../assets/banners/day-${dd}-${d.slug}.svg" width="800" alt="Day ${d.day} - ${d.topic}">\n</p>\n\n`;

  // Badges
  md += `<p align="center">\n`;
  md += videoBadge;
  md += `  <img src="https://img.shields.io/badge/Day-${d.day}_of_30-blue" alt="Day ${d.day}">\n`;
  md += `  <img src="https://img.shields.io/badge/Week-${d.week}-purple" alt="Week ${d.week}">\n`;
  md += `  <img src="https://img.shields.io/badge/Difficulty-${d.diff}-orange" alt="${d.diff}">\n`;
  md += `</p>\n\n`;

  // Title + tagline
  md += `# Day ${d.day} - ${d.topic}\n\n`;
  md += `${prevLink} | ${nextLink}\n\n`;
  md += `---\n\n`;

  // What You'll Learn
  if (whatYoullLearn) {
    md += `## What You'll Learn\n\n${whatYoullLearn}\n\n---\n\n`;
  }

  // Quick Setup (for days with SQL files)
  if (hasSetup) {
    md += `## Quick Setup\n\n`;
    md += '```sql\n-- Run in pgAdmin (takes a few seconds)\n\\i setup.sql\n```\n\n';
    md += `Or open [\`setup.sql\`](setup.sql) and run the full script manually.\n\n`;
    if (datasetDesc) {
      md += `${datasetDesc}\n\n`;
    }
    md += `<details>\n<summary>Verify your setup</summary>\n\n`;
    md += '```sql\n-- Check your tables loaded correctly\nSELECT COUNT(*) FROM your_table;\n```\n\n</details>\n\n---\n\n';
  } else if (datasetDesc) {
    md += `## Dataset\n\n${datasetDesc}\n\n---\n\n`;
  }

  // Exercises
  if (exercises) {
    md += `## Exercises\n\n${exercises}\n\n`;
    // Add solutions link if setup exists (published day)
    if (hasSetup) {
      md += `### Solutions\n\nFinished? Check your answers: [\`solutions.sql\`](solutions.sql)\n\n`;
    }
    md += `---\n\n`;
  }

  // Key Concepts
  if (concepts) {
    md += `## Key Concepts\n\n${concepts}\n\n---\n\n`;
  }

  // Where To Next? navigation tree
  md += `## Where To Next?\n\n`;
  md += `<p align="center">\n  <img src="../assets/banners/day-${dd}-where-next.svg" width="900" alt="Where To Next?">\n</p>\n\n`;
  md += `---\n\n`;

  // Bottom nav
  md += `<p align="center">\n  ${bottomNav}\n</p>\n`;

  return md;
}

// Process all 30 days
let count = 0;
for (const d of days) {
  const dd = String(d.day).padStart(2, '0');
  const readmePath = path.join(ROOT, `day-${dd}`, 'README.md');

  let existingContent = null;
  if (fs.existsSync(readmePath)) {
    existingContent = fs.readFileSync(readmePath, 'utf8');
  }

  const newReadme = generateReadme(d, existingContent);
  fs.writeFileSync(readmePath, newReadme);
  count++;
}

console.log(`Rewrote ${count} day READMEs`);

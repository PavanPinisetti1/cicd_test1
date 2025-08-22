#!/usr/bin/env node
/* generate_diff_reports.js
   Replicates:
   - Prompt for updated/old branches
   - git checkout updated, ensure old exists, return to updated
   - Create reports/
   - Write: files_changed_<old>_to_<updated>.txt
             summary_<old>_to_<updated>.txt
             diff_<old>_to_<updated>.patch
   - git add + commit

   Run: node generate_diff_reports.js
*/

const { spawnSync } = require('node:child_process');
const { mkdirSync, writeFileSync, existsSync } = require('node:fs');
const { join } = require('node:path');
const readline = require('node:readline');

function run(cmd, args, opts = {}) {
  const res = spawnSync(cmd, args, { stdio: 'pipe', encoding: 'utf-8', ...opts });
  if (opts.check !== false && res.status !== 0) {
    // Bubble up stdout/stderr for easier troubleshooting
    const out = (res.stdout || '').trim();
    const err = (res.stderr || '').trim();
    const msg = [`Command failed: ${cmd} ${args.join(' ')}`, out, err].filter(Boolean).join('\n');
    throw new Error(msg);
  }
  return res;
}

function inGitRepo() {
  const res = spawnSync('git', ['rev-parse', '--is-inside-work-tree'], { encoding: 'utf-8' });
  return res.status === 0 && (res.stdout || '').trim() === 'true';
}

function sanitizeBranchName(name) {
  return name.replace(/[\\/]/g, '_').replace(/\.\./g, '_').trim();
}

async function prompt(q) {
  const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
  const answer = await new Promise((resolve) => rl.question(q, resolve));
  rl.close();
  return answer.trim();
}

async function main() {
  if (!inGitRepo()) {
    console.error('Error: Not inside a Git repository. Run this script at the repo root.');
    process.exit(1);
  }

  const updatedBranch = await prompt('Enter updated branch (new version): ');
  const oldBranch = await prompt('Enter old branch (previous version): ');

  if (!updatedBranch || !oldBranch) {
    console.error('Both branch names are required.');
    process.exit(1);
  }

  // Checkout updated branch
  run('git', ['checkout', updatedBranch]);

  // Ensure old branch is available locally, then come back to updated
  run('git', ['fetch', 'origin']);
  // If oldBranch is remote-only, try to create a local branch tracking it
  // Attempt checkout; if it fails, try "git checkout -t origin/<oldBranch>"
  let ok = spawnSync('git', ['checkout', oldBranch], { encoding: 'utf-8' });
  if (ok.status !== 0) {
    ok = spawnSync('git', ['checkout', '-t', `origin/${oldBranch}`], { encoding: 'utf-8' });
    if (ok.status !== 0) {
      console.error(`Unable to checkout old branch '${oldBranch}'. Make sure it exists locally or on origin.`);
      process.exit(1);
    }
  }
  run('git', ['checkout', updatedBranch]);

  // Prepare reports folder
  const reportsDir = join(process.cwd(), 'reports');
  if (!existsSync(reportsDir)) {
    mkdirSync(reportsDir, { recursive: true });
  }

  const oldS = sanitizeBranchName(oldBranch);
  const updS = sanitizeBranchName(updatedBranch);

  const filesChangedPath = join(reportsDir, `files_changed_${oldS}_to_${updS}.txt`);
  const summaryPath = join(reportsDir, `summary_${oldS}_to_${updS}.txt`);
  const patchPath = join(reportsDir, `diff_${oldS}_to_${updS}.patch`);

  // Generate diffs
  const filesChanged = run('git', ['diff', '--name-only', `${oldBranch}..${updatedBranch}`], { check: false });
  writeFileSync(filesChangedPath, (filesChanged.stdout || ''), 'utf-8');

  const summary = run('git', ['diff', '--stat', `${oldBranch}..${updatedBranch}`], { check: false });
  writeFileSync(summaryPath, (summary.stdout || ''), 'utf-8');

  const patch = run('git', ['diff', `${oldBranch}..${updatedBranch}`], { check: false });
  writeFileSync(patchPath, (patch.stdout || ''), 'utf-8');

  // Stage and commit
  run('git', ['add', filesChangedPath, summaryPath, patchPath]);
  const commitMsg = `Add human-readable diffs: ${oldBranch} → ${updatedBranch}`;
  const commit = spawnSync('git', ['commit', '-m', commitMsg], { encoding: 'utf-8' });
  if (commit.status !== 0) {
    const msg = (commit.stderr || commit.stdout || '').trim();
    if (msg) console.log(msg);
    console.log('No changes to commit (reports unchanged).');
  } else {
    console.log('Reports committed successfully.');
  }

  console.log('Generated files:');
  console.log(`- ${filesChangedPath}`);
  console.log(`- ${summaryPath}`);
  console.log(`- ${patchPath}`);
}

main().catch((e) => {
  console.error(e.message || e);
  process.exit(1);
});

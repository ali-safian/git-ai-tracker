#!/usr/bin/env node

const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

// Check if we're in a git repository
function isGitRepo() {
  try {
    execSync('git rev-parse --git-dir', { stdio: 'ignore' });
    return true;
  } catch {
    return false;
  }
}

// Get the git repository root
function getGitRoot() {
  try {
    return execSync('git rev-parse --show-toplevel', { encoding: 'utf8' }).trim();
  } catch {
    return null;
  }
}

// Main AI tracking functionality
function trackAI(args) {
  if (!isGitRepo()) {
    console.error('❌ Not a git repository. Please run this command from within a git repository.');
    process.exit(1);
  }

  const scriptPath = path.join(__dirname, '..', 'scripts', 'ai-tracker.sh');
  
  try {
    const result = execSync(`bash "${scriptPath}" ${args.join(' ')}`, { 
      encoding: 'utf8',
      stdio: 'inherit'
    });
  } catch (error) {
    process.exit(error.status || 1);
  }
}

// Help message
function showHelp() {
  console.log(`
🤖 Git AI Tracker - Track AI-assisted commits globally

Usage: git ai [options] [branch/tag] [base_branch/previous_tag]

Options:
  -b, --branch [BRANCH]       Track AI commits in specific branch (uses current branch if not specified)
  -t, --tag TAG [PREV_TAG]    Track AI commits in tag, optionally compare with previous tag
  -f, --feature [BRANCH] [BASE] Track AI commits since feature branch creation (uses current branch if not specified, default base: master)
  -c, --compare BASE FEATURE  Compare AI commits between base and feature branch
  -a, --all-branches          Show AI stats for all branches
  -r, --range FROM TO         Track AI commits between two commits/tags/branches
  -s, --setup                 Set up AI tracking hooks in current repository
  -h, --help                  Show this help

Examples:
  git ai -b                                     # AI commits in current branch
  git ai -b feature/new-login                    # AI commits in specific branch
  git ai -f                                     # AI commits since current branch creation from master
  git ai -f feature/new-login                    # AI commits since branch creation from master
  git ai -c master feature/new-login            # Compare feature branch with master
  git ai -t v2.0.3                              # AI commits in specific tag
  git ai -t v2.0.3 v2.0.2                      # AI commits between two tags
  git ai -r v1.0.0 v2.0.0                      # AI commits between two versions
  git ai -a                                     # Show AI stats for all branches
  git ai -s                                     # Set up AI tracking in current repo

Setup:
  Run 'git ai -s' in any repository to enable AI commit tracking.
  This will install the commit hooks that prompt for AI usage.

🔗 More info: https://github.com/ali-safian/git-ai-tracker
  `);
}

// Parse arguments and execute
const args = process.argv.slice(2);

if (args.length === 0 || args.includes('-h') || args.includes('--help')) {
  showHelp();
  process.exit(0);
}

if (args.includes('-s') || args.includes('--setup')) {
  // Run setup
  const { setupHooks } = require('./git-ai-setup.js');
  setupHooks();
} else {
  // Run tracking
  trackAI(args);
}

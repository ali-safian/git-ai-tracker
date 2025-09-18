#!/usr/bin/env node

// Main entry point for the git-ai-tracker package
module.exports = {
  setupHooks: require('./bin/git-ai-setup').setupHooks
};

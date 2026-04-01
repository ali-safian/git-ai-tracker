#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

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

// Setup AI tracking hooks
function setupHooks() {
  console.log('🔧 Setting up Git AI tracking hooks...');
  
  if (!isGitRepo()) {
    console.error('❌ Not a git repository. Please run this command from within a git repository.');
    process.exit(1);
  }

  const gitRoot = getGitRoot();
  const hooksDir = path.join(gitRoot, '.git', 'hooks');
  const templatesDir = path.join(__dirname, '..', 'templates');
  
  console.log(`📁 Git repository: ${gitRoot}`);
  console.log(`📁 Hooks directory: ${hooksDir}`);
  console.log(`📁 Templates directory: ${templatesDir}`);
  
  // Ensure hooks directory exists
  if (!fs.existsSync(hooksDir)) {
    console.log('📂 Creating hooks directory...');
    fs.mkdirSync(hooksDir, { recursive: true });
  }

  // Verify templates exist
  const commitMsgTemplate = path.join(templatesDir, 'commit-msg');
  const aiConfirmTemplate = path.join(templatesDir, 'ai-confirmation-msg');
  const prepareCommitMsgTemplate = path.join(templatesDir, 'prepare-commit-msg');
  
  if (!fs.existsSync(commitMsgTemplate)) {
    console.error(`❌ Template not found: ${commitMsgTemplate}`);
    process.exit(1);
  }
  
  if (!fs.existsSync(aiConfirmTemplate)) {
    console.error(`❌ Template not found: ${aiConfirmTemplate}`);
    process.exit(1);
  }
  
  if (!fs.existsSync(prepareCommitMsgTemplate)) {
    console.error(`❌ Template not found: ${prepareCommitMsgTemplate}`);
    process.exit(1);
  }
  
  console.log('✅ Templates found');

  try {
    // Copy prepare-commit-msg hook (runs first to add user hash)
    const prepareCommitMsgHook = path.join(hooksDir, 'prepare-commit-msg');
    console.log(`📋 Installing prepare-commit-msg hook...`);
    
    fs.copyFileSync(prepareCommitMsgTemplate, prepareCommitMsgHook);
    fs.chmodSync(prepareCommitMsgHook, 0o755);
    console.log(`✅ Installed: ${prepareCommitMsgHook}`);
    
    // Copy commit-msg hook
    const commitMsgHook = path.join(hooksDir, 'commit-msg');
    console.log(`📋 Installing commit-msg hook...`);
    
    fs.copyFileSync(commitMsgTemplate, commitMsgHook);
    fs.chmodSync(commitMsgHook, 0o755);
    console.log(`✅ Installed: ${commitMsgHook}`);
    
    // Copy ai-confirmation-msg script
    const aiConfirmScript = path.join(hooksDir, 'ai-confirmation-msg');
    console.log(`📋 Installing ai-confirmation-msg script...`);
    
    fs.copyFileSync(aiConfirmTemplate, aiConfirmScript);
    fs.chmodSync(aiConfirmScript, 0o755);
    console.log(`✅ Installed: ${aiConfirmScript}`);
    
    // Verify installation
    console.log('');
    console.log('🔍 Verifying installation...');
    
    if (fs.existsSync(prepareCommitMsgHook) && fs.existsSync(commitMsgHook) && fs.existsSync(aiConfirmScript)) {
      const prepareStats = fs.statSync(prepareCommitMsgHook);
      const commitStats = fs.statSync(commitMsgHook);
      const aiStats = fs.statSync(aiConfirmScript);
      
      if (prepareStats.mode & parseInt('111', 8) && commitStats.mode & parseInt('111', 8) && aiStats.mode & parseInt('111', 8)) {
        console.log('✅ Git AI tracking hooks successfully installed!');
        console.log('✅ All hooks are executable');
        console.log('');
        console.log('🎉 Setup complete! Your repository now supports enhanced commit tracking.');
        console.log('');
        console.log('📝 Features enabled:');
        console.log('   • User identification hash added to all commits');
        console.log('   • AI detection prompts for commit classification');
        console.log('');
        console.log('📋 Commit format examples:');
        console.log('   Regular: "Fix bug - $u:a1b2c3d4"');
        console.log('   AI-assisted: "[AI] Add feature - $u:a1b2c3d4"');
        console.log('');
        console.log('🔍 Track AI commits with:');
        console.log('   git ai -a                    # Show all AI commits');
        console.log('   git ai -f <branch>           # AI commits in feature branch');
        console.log('   git ai -t <tag>              # AI commits in tag');
      } else {
        console.error('❌ Hooks installed but not executable');
        process.exit(1);
      }
    } else {
      console.error('❌ Hook verification failed - files not found after installation');
      process.exit(1);
    }
    
  } catch (error) {
    console.error('❌ Error setting up hooks:', error.message);
    console.error('Stack trace:', error.stack);
    process.exit(1);
  }
}

// Run setup if called directly
if (require.main === module) {
  setupHooks();
}

module.exports = { setupHooks };

#!/usr/bin/env node

console.log(`
🎉 Git AI Tracker installed successfully!

📦 Installation complete! To get started:

1️⃣  Navigate to any Git repository
2️⃣  Run: git ai -s    (to set up AI tracking hooks)
3️⃣  Start committing! You'll be prompted about AI usage

📊 Track your AI commits:
   git ai -a                    # Show all AI commits
   git ai -f <branch>           # AI commits in feature branch  
   git ai -t <tag>              # AI commits in tag
   git ai -c <base> <feature>   # Compare branches

💡 Need help? Run: git ai -h

🔗 Documentation: https://github.com/your-username/git-ai-tracker
`);

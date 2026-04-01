# 🤖 Git AI Tracker

Track and analyze AI-assisted commits in your Git repositories with detailed statistics and insights.

## 🚀 Quick Start

### Installation

```bash
# Install globally
npm install -g git-ai-tracker

# Or use yarn
yarn global add git-ai-tracker
```

### Setup

Navigate to any Git repository and run:

```bash
git ai -s
```

This installs Git hooks: a `prepare-commit-msg` hook that appends a short user hash to the subject line, and a `commit-msg` flow that prompts about AI usage.

### Usage

Once set up, commits get a hash derived from `user.name` and `user.email` (format ` - $u:` plus eight hex characters), then the AI prompt runs:

```
📝 Commit message:
Add new feature - $u:a1b2c3d4

Is this code written by AI? (y/n): y
✅ [AI] tag added.
```

Final message example: `[AI] Add new feature - $u:a1b2c3d4`

## 📊 Tracking Commands

### Basic Commands

```bash
# Show all AI commits across all branches
git ai -a

# Track AI commits in current branch
git ai -b

# Track AI commits in specific branch
git ai -b main

# Track AI commits in a specific tag
git ai -t v2.0.1

# Track AI commits in current feature branch (since creation)
git ai -f

# Track AI commits in specific feature branch (since creation)
git ai -f feature/new-login
```

### Advanced Tracking

```bash
# Compare AI commits between branches
git ai -c master feature/new-login

# Track AI commits between two tags
git ai -t v2.0.1 v2.0.0

# Track AI commits in a date range
git ai -r v1.0.0 v2.0.0

# Track with custom base branch
git ai -f feature/auth develop
```

## 📈 Features

- **User hash on every commit**: Subject line gets ` - $u:<8 hex chars>` from an MD5 of `user.name:user.email` (macOS and Linux)
- **🔍 Branch Analysis**: Track AI commits since branch creation using `git merge-base`
- **🏷️ Tag Comparisons**: Compare AI usage between releases
- **📊 Statistics**: Percentage of AI-assisted commits with detailed breakdowns
- **🕒 Timeline**: Chronological view of AI commits
- **🌐 Global Installation**: Works on any machine, any Git repository
- **⚡ Easy Setup**: One command setup per repository

## 📋 Full Command Reference

| Command | Description | Example |
|---------|-------------|---------|
| `git ai -a` | Show all branches with AI commits | `git ai -a` |
| `git ai -b [branch]` | AI commits in branch (current if not specified) | `git ai -b` or `git ai -b main` |
| `git ai -f [branch] [base]` | AI commits since branch creation (current if not specified) | `git ai -f` or `git ai -f feature/auth master` |
| `git ai -t <tag> [prev]` | AI commits in tag, optionally vs previous | `git ai -t v2.0.1 v2.0.0` |
| `git ai -c <base> <feature>` | Compare branches | `git ai -c master feature/new-ui` |
| `git ai -r <from> <to>` | AI commits between references | `git ai -r HEAD~10 HEAD` |
| `git ai -s` | Set up AI tracking in repository | `git ai -s` |
| `git ai -h` | Show help | `git ai -h` |

## 🔧 Example Output

### Branch Analysis
```bash
$ git ai -f feature/new-auth

📊 AI Commits unique to Feature Branch: feature/new-auth
=======================================================
Base branch: master

📍 Branch point: a1b2c3d - Initial project setup
📅 Branch created: 2024-01-15

Commits since branch creation: 23
AI commits since branch creation: 8
AI percentage in feature branch: 34.78%

🤖 AI commits in feature branch (since creation):
d4e5f6g - 2024-01-20 - [AI] Add authentication middleware
h7i8j9k - 2024-01-22 - [AI] Implement JWT token validation
```

### Tag Comparison
```bash
$ git ai -t v2.0.1 v2.0.0

📊 AI Commit Statistics for Tag: v2.0.1
======================================
📅 Tag date: 2024-01-25

📊 AI commits between v2.0.0 and v2.0.1:
Commits between tags: 15
AI commits between tags: 6
AI percentage between tags: 40.00%

🤖 AI commits in this release:
l1m2n3o - 2024-01-23 - [AI] Refactor user authentication
p4q5r6s - 2024-01-24 - [AI] Add password reset functionality
```

## 🛠️ Installation Methods

### Method 1: NPM Global Install (Recommended)
```bash
npm install -g git-ai-tracker
```

### Method 2: Direct from Repository
```bash
git clone https://github.com/ali-safian/git-ai-tracker.git
cd git-ai-tracker
npm install -g .
```

### Method 3: Local Project Install
```bash
npm install git-ai-tracker
npx git-ai -s  # Setup in current repo
```

## 🔄 Updating

```bash
npm update -g git-ai-tracker
```

## 🗑️ Uninstalling

```bash
npm uninstall -g git-ai-tracker
```

To remove hooks from a repository:
```bash
rm .git/hooks/prepare-commit-msg .git/hooks/commit-msg .git/hooks/ai-confirmation-msg
```

## 💡 Tips

- **Current Branch Detection**: Use `git ai -b` or `git ai -f` without specifying a branch to automatically use your current branch
- **Quick Branch Analysis**: Perfect for checking AI commits in your current working branch before merging

- **Branch Tracking**: Uses `git merge-base` to find exact divergence points
- **Performance**: Optimized for large repositories with thousands of commits
- **Compatibility**: Works with any Git workflow (GitFlow, GitHub Flow, etc.)
- **CI/CD**: Hooks automatically skip in non-interactive environments
- **Customization**: Modify tag format by editing hook templates

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🐛 Issues

Found a bug? Have a feature request? Please open an issue on [GitHub](https://github.com/ali-safian/git-ai-tracker/issues).

## 🔗 Links

- [GitHub Repository](https://github.com/ali-safian/git-ai-tracker)
- [NPM Package](https://www.npmjs.com/package/git-ai-tracker)
- [Documentation](https://github.com/ali-safian/git-ai-tracker/wiki)

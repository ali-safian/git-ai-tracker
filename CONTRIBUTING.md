# Contributing to Git AI Tracker

Thank you for your interest in contributing to Git AI Tracker! 🎉

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/git-ai-tracker.git`
3. Create a feature branch: `git checkout -b feature/amazing-feature`
4. Make your changes
5. Test your changes: `npm install -g . && git ai -s`
6. Commit your changes: `git commit -m 'Add amazing feature'`
7. Push to your branch: `git push origin feature/amazing-feature`
8. Open a Pull Request

## Development Setup

```bash
# Clone the repository
git clone https://github.com/ali-safian/git-ai-tracker.git
cd git-ai-tracker

# Install globally for testing
npm install -g .

# Test in any git repository
cd /some/git/repo
git ai -s  # Setup hooks
git ai -a  # Test tracking
```

## Project Structure

```
git-ai-tracker/
├── bin/                    # CLI executables
│   ├── git-ai.js          # Main command
│   └── git-ai-setup.js    # Setup command
├── scripts/               # Core tracking scripts
│   └── ai-tracker.sh      # Bash script for Git analysis
├── templates/             # Git hook templates
│   ├── commit-msg         # Main Git hook
│   └── ai-confirmation-msg # AI detection script
├── README.md              # Documentation
└── package.json           # NPM package config
```

## Making Changes

### Adding Features
- Follow existing code style
- Add tests for new functionality
- Update README.md if needed
- Test with multiple Git repositories

### Bug Fixes
- Include reproduction steps in your PR
- Test the fix thoroughly
- Consider edge cases

### Documentation
- Keep README.md up to date
- Use clear, concise language
- Include examples

## Testing

Before submitting a PR, test your changes:

```bash
# Install your version
npm install -g .

# Test setup in multiple repos
cd /different/git/repos
git ai -s

# Test tracking commands
git ai -a
git ai -f feature-branch
git ai -t some-tag
```

## Code Style

- Use meaningful variable names
- Add comments for complex logic
- Follow existing patterns
- Keep functions focused and small

## Questions?

Feel free to open an issue for:
- Bug reports
- Feature requests
- Questions about usage
- Development help

Thanks for contributing! 🚀



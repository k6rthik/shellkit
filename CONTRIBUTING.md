# Contributing to shellkit

Thank you for your interest in contributing to shellkit! 🎉

## How to Contribute

### Reporting Bugs

If you find a bug, please open an issue with:
- Clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Your OS and shell version (`echo $SHELL`, `uname -a`)
- shellkit version or commit hash

### Suggesting Features

Feature requests are welcome! Please:
- Check if the feature already exists
- Explain the use case and benefits
- Provide examples if possible

### Submitting Pull Requests

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Follow the project guidelines** (see `.github/copilot-instructions.md`)
   - Maintain cross-shell compatibility (bash and zsh)
   - Add comments for complex logic
   - Quote variables properly: `"$variable"`
   - Check command/file existence before use
   - Keep code portable across different OS

4. **Test your changes**
   ```bash
   # Test in bash
   bash -c "source init.sh && your-command"
   
   # Test in zsh
   zsh -c "source init.sh && your-command"
   
   # Run automated tests
   ./tests/test.sh
   
   # Or use Docker
   cd docker
   docker compose run --rm shellkit-bash
   docker compose run --rm shellkit-zsh
   ```

5. **Update documentation**
   - Add new functions/aliases to README.md
   - Include usage examples
   - Document any environment variables

6. **Commit with clear messages**
   ```bash
   git commit -m "feat: add fuzzy finder for git branches"
   git commit -m "fix: handle spaces in directory names"
   git commit -m "docs: update installation instructions"
   ```
   
   Use conventional commits:
   - `feat:` - New feature
   - `fix:` - Bug fix
   - `docs:` - Documentation changes
   - `refactor:` - Code refactoring
   - `test:` - Adding tests
   - `chore:` - Maintenance tasks

7. **Push and create a Pull Request**
   ```bash
   git push origin feature/your-feature-name
   ```

## Code Style

### Shell Scripts

- Use `#!/usr/bin/env bash` for portability
- Quote all variables: `"$var"` not `$var`
- Check existence: `[ -f "$file" ]` before sourcing
- Use `command -v` to check if commands exist
- Prefix helper functions with underscore: `_helper_function()`
- Clean up helper functions after use
- Use local variables in functions: `local var="value"`
- Return meaningful exit codes (0 for success)

### File Organization

- **aliases.sh** - Command aliases only
- **functions.sh** - Reusable shell functions
- **env.sh** - Environment variable exports
- **paths.sh** - PATH modifications
- **fzf.sh** - FZF configuration
- **local.sh** - Local overrides (not tracked)
- **init.sh** - Don't modify unless necessary

### Documentation

- Add comments for non-obvious code
- Include usage examples for new functions
- Document function parameters and return values
- Update README.md with new features

## Example: Adding a New Function

```bash
# In functions.sh

# Description: Extract git repository name from URL
# Usage: git_repo_name <git-url>
# Example: git_repo_name https://github.com/user/repo.git
# Output: repo
git_repo_name() {
    if [ -z "$1" ]; then
        echo "Usage: git_repo_name <git-url>" >&2
        return 1
    fi
    
    local url="$1"
    local repo=$(basename "$url" .git)
    echo "$repo"
    return 0
}
```

Then update README.md:
```markdown
### git_repo_name

Extract repository name from git URL.

```bash
git_repo_name https://github.com/user/awesome-project.git
# Output: awesome-project
```
```

## Example: Adding a New Alias

```bash
# In aliases.sh

# Git: Show branches sorted by last commit
if command -v git &> /dev/null; then
    alias gbr='git branch --sort=-committerdate'
fi
```

## Testing Checklist

Before submitting:

- [ ] Works in both bash and zsh
- [ ] Properly quotes all variables
- [ ] Checks for command/file existence
- [ ] No hardcoded paths
- [ ] No secrets or API keys
- [ ] Includes error handling
- [ ] Documentation updated
- [ ] Comments added for complex logic
- [ ] Follows existing code style
- [ ] Tested in clean environment

## Questions?

Feel free to:
- Open an issue for discussion
- Ask in pull request comments
- Check existing issues and PRs for similar topics

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on what is best for the community
- Show empathy towards others

Thank you for making shellkit better! 🚀

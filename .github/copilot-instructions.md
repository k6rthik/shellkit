# GitHub Copilot Instructions for shellkit Project

## Project Overview

This is a portable shell configuration framework designed to work across multiple machines with both bash and zsh support. The project follows a modular architecture with separate configuration files for different concerns.

## Project Structure

- `init.sh` - Main entry point that orchestrates loading of all configuration files
- `aliases.sh` - Command aliases and shortcuts
- `functions.sh` - Custom shell functions
- `env.sh` - Environment variable exports
- `paths.sh` - PATH configuration and modifications
- `local.sh` - Machine-specific overrides (not tracked in git)
- `.env.local` - Local environment variables for secrets (not tracked in git)

## Core Principles

1. **Cross-shell compatibility**: All code must work in both bash and zsh
2. **Portability**: Configurations should work across different machines and OS distributions
3. **Modularity**: Keep different types of configurations in their respective files
4. **Safety**: Always check for existence before sourcing or modifying
5. **Documentation**: Comment complex logic and provide usage examples
6. **No hardcoded paths**: Use environment variables and relative paths
7. **Git-friendly**: Support local overrides for machine-specific settings

## Code Guidelines

### Shell Script Best Practices

1. **Shebang**: Use `#!/usr/bin/env bash` for compatibility
2. **Error handling**: Check return codes and handle errors gracefully
3. **Quoting**: Always quote variables: `"$variable"` not `$variable`
4. **Existence checks**: Use `[ -f "$file" ]` before sourcing or accessing files
5. **Command checks**: Use `command -v` to check if commands exist
6. **Functions**: Prefix internal functions with underscore (e.g., `_helper_function`)
7. **Cleanup**: Unset helper functions after use

### File-Specific Guidelines

#### init.sh
- Order matters: load env.sh first, then paths.sh, then functions.sh, then aliases.sh
- Use safe sourcing with existence checks
- Provide optional verbose mode for debugging
- Detect shell type and export as `SHELLKIT_SHELL`
- Export `SHELLKIT_DIR` for use in other files

#### aliases.sh
- Keep aliases simple and intuitive
- Group related aliases together with comments
- Use conditional aliases based on OS/available commands
- Document non-obvious aliases
- Avoid aliases that shadow important commands without safety nets

#### functions.sh
- Each function should have a single, clear purpose
- Include usage messages for functions that require arguments
- Return meaningful exit codes (0 for success, 1+ for errors)
- Validate input arguments before processing
- Use local variables inside functions: `local var="value"`
- Add error messages to stderr: `echo "Error" >&2`

#### env.sh
- Document each environment variable's purpose
- Never commit secrets or API keys
- Use conditional exports based on OS/environment
- Group related variables together
- Source `.env.local` at the end for local overrides
- Use defaults for optional variables: `${VAR:-default}`

#### paths.sh
- Check directory existence before adding to PATH
- Prevent duplicate PATH entries
- Add high-priority directories at the beginning (`_add_to_path`)
- Add low-priority directories at the end (`_append_to_path`)
- Clean up helper functions after use

### Security Guidelines

1. **Never commit secrets**: Use `.env.local` for sensitive data
2. **Validate inputs**: Check user inputs in functions
3. **Safe defaults**: Use safe options for destructive operations
4. **Permission checks**: Verify permissions before operations
5. **Sanitize paths**: Be careful with user-provided paths

### Compatibility Guidelines

1. **OS detection**: Use proper conditionals for OS-specific code
   ```bash
   if [[ "$OSTYPE" == "linux-gnu"* ]]; then
       # Linux-specific
   elif [[ "$OSTYPE" == "darwin"* ]]; then
       # macOS-specific
   fi
   ```

2. **Command availability**: Check before using
   ```bash
   if command -v docker &> /dev/null; then
       alias d='docker'
   fi
   ```

3. **Shell-specific features**: Use compatible syntax
   - Avoid bash-only or zsh-only features
   - Test in both shells when possible
   - Document shell-specific requirements

## Adding New Features

### Adding an Alias

1. Open `aliases.sh`
2. Find the appropriate section or create a new one
3. Add the alias with a comment
4. Example:
   ```bash
   # My custom shortcut
   alias mycommand='echo "Hello, World!"'
   ```

### Adding a Function

1. Open `functions.sh`
2. Write the function with error handling
3. Add usage documentation
4. Example:
   ```bash
   # Description of what the function does
   myfunction() {
       if [ -z "$1" ]; then
           echo "Usage: myfunction <argument>"
           return 1
       fi
       
       local arg="$1"
       echo "Processing: $arg"
   }
   ```

### Adding Environment Variables

1. Open `env.sh`
2. Add export statement with comment
3. Use defaults when appropriate
4. Example:
   ```bash
   # Description of the variable
   export MY_VAR="${MY_VAR:-default_value}"
   ```

### Adding to PATH

1. Open `paths.sh`
2. Use helper functions to add directories
3. Example:
   ```bash
   # Add my custom bin directory
   _add_to_path "$HOME/my-tools/bin"
   ```

## Testing Guidelines

1. **Test in both shells**: Verify changes work in bash and zsh
2. **Test on clean environment**: Source in a fresh shell session
3. **Test error cases**: Ensure functions handle bad inputs gracefully
4. **Test portability**: If possible, test on different OS/distributions
5. **Check for conflicts**: Ensure new aliases/functions don't conflict with existing ones

## Code Review Checklist

When reviewing or generating code for this project:

- [ ] Works in both bash and zsh
- [ ] Properly quoted variables
- [ ] Error handling included
- [ ] Documentation/comments added
- [ ] No hardcoded paths
- [ ] No secrets or API keys
- [ ] Follows naming conventions
- [ ] Helper functions cleaned up
- [ ] Added to appropriate file
- [ ] Doesn't break existing functionality

## Common Patterns

### Safe sourcing
```bash
if [ -f "$file" ]; then
    source "$file"
fi
```

### Command existence check
```bash
if command -v mycommand &> /dev/null; then
    # Command exists
fi
```

### Adding to PATH safely
```bash
if [ -d "$dir" ] && [[ ":$PATH:" != *":$dir:"* ]]; then
    export PATH="$dir:$PATH"
fi
```

### Function with validation
```bash
myfunction() {
    if [ -z "$1" ]; then
        echo "Usage: myfunction <arg>" >&2
        return 1
    fi
    
    local arg="$1"
    # Function logic here
    return 0
}
```

## Don't Do This

❌ Don't hardcode paths
```bash
alias myproject='cd /home/john/projects/myapp'  # Bad
```

✅ Do use environment variables
```bash
alias myproject='cd $PROJECTS_DIR/myapp'  # Good
```

❌ Don't commit secrets
```bash
export API_KEY="secret123"  # Bad - in tracked file
```

✅ Do use .env.local
```bash
# In .env.local (not tracked)
export API_KEY="secret123"  # Good
```

❌ Don't assume commands exist
```bash
alias d='docker ps'  # Bad - docker might not be installed
```

✅ Do check command existence
```bash
if command -v docker &> /dev/null; then
    alias d='docker ps'  # Good
fi
```

## When Working on This Project

1. **Understand the context**: Review the file you're modifying and related files
2. **Follow the structure**: Place code in the appropriate file
3. **Maintain consistency**: Match the existing code style
4. **Document changes**: Add comments for complex logic
5. **Think portable**: Consider different machines and environments
6. **Test thoroughly**: Verify changes don't break existing functionality
7. **Update README**: Document new features, functions, aliases, or major changes in README.md
8. **Update Copilot instructions**: Keep this file in sync with project practices and guidelines

## Support and Debugging

- Set `SHELLKIT_VERBOSE=1` to enable debug output
- Use `bash -x` to trace script execution
- Check `$SHELLKIT_DIR` and `$SHELLKIT_SHELL` variables
- Review load order in `init.sh`
- Check for syntax errors with `bash -n filename.sh`

---

Remember: This is a personal productivity tool. Keep it simple, keep it portable, and keep it useful!

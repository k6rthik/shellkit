# shellkit

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/bash-4.0+-blue.svg)](https://www.gnu.org/software/bash/)
[![Zsh](https://img.shields.io/badge/zsh-5.0+-blue.svg)](https://www.zsh.org/)

A portable, modular shell configuration framework for bash and zsh that works seamlessly across multiple machines.

> 🚀 Stop copying dotfiles around. Keep your shell configuration in sync across all your machines with git.

## Table of Contents

- [Quick Start Guide](QUICKSTART.md) ⚡
- [Aliases Reference](docs/ALIASES.md) 📚
- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Configuration Files](#configuration-files)
- [Usage Examples](#usage-examples)
- [Real-World Scenarios](#real-world-scenarios)
- [Customization](#customization)
- [Syncing Across Machines](#syncing-across-machines)
- [Troubleshooting](#troubleshooting)
- [Recommended Tools](#recommended-tools)
- [Docker Testing](#docker-testing)
- [Contributing](#contributing)
- [License](#license)

## Overview

**shellkit** is a well-organized collection of shell configurations that you can version control and sync across all your development machines. It provides a clean separation of concerns with individual files for aliases, functions, environment variables, and PATH configurations.

## Features

- ✅ **Cross-shell compatibility**: Works with both bash and zsh
- ✅ **Modular structure**: Separate files for different configuration types
- ✅ **Portable**: Clone once, use everywhere
- ✅ **Safe**: Checks for file existence before sourcing
- ✅ **Extensible**: Easy to add custom configurations
- ✅ **Git-friendly**: Supports local overrides not tracked in version control
- ✅ **Modern tools**: Integrates fd, rg (ripgrep), and fzf for enhanced productivity
- ✅ **FZF powered**: Interactive fuzzy finding for files, directories, git, processes, and more

## Project Structure

```
shellkit/
├── init.sh           # Main entry point - source this file
├── aliases.sh        # Command aliases
├── functions.sh      # Custom shell functions
├── env.sh           # Environment variables
├── paths.sh         # PATH modifications
├── fzf.sh           # FZF configuration and key bindings
├── wsl.sh           # WSL-specific initialization
├── starship.sh      # Starship prompt configuration
├── install.sh       # Installation script
├── .env.example     # Template for .env.local
├── .gitignore       # Git ignore rules
├── README.md        # This file
├── .github/
│   └── copilot-instructions.md  # Copilot guidelines
├── docs/
│   └── DOCKER.md    # Docker testing guide
├── docker/
│   ├── Dockerfile
│   └── docker-compose.yml
└── tests/
    └── test.sh      # Automated test script

Not tracked in git:
├── local.sh         # Local overrides (optional)
└── .env.local       # Local environment variables (optional)
```

## Installation

### 1. Clone the repository

```bash
# Clone to your preferred location
git clone https://github.com/k6rthik/shellkit.git ~/.shellkit

# Or if already in a directory
cd ~/path/to/shellkit
```

### 2. Source in your shell configuration

#### For Bash (~/.bashrc)

Add this line to your `~/.bashrc`:

```bash
# Load shellkit configuration
[ -f "$HOME/.shellkit/init.sh" ] && source "$HOME/.shellkit/init.sh"
```

#### For Zsh (~/.zshrc)

Add this line to your `~/.zshrc`:

```bash
# Load shellkit configuration
[ -f "$HOME/.shellkit/init.sh" ] && source "$HOME/.shellkit/init.sh"
```

### 3. Reload your shell

```bash
# For bash
source ~/.bashrc

# For zsh
source ~/.zshrc

# Or simply open a new terminal
```

## Configuration Files

### init.sh - Main Entry Point

This is the orchestrator that loads all other configuration files in the correct order:
1. Environment variables (`env.sh`)
2. PATH modifications (`paths.sh`)
3. Custom functions (`functions.sh`)
4. Aliases (`aliases.sh`)
5. FZF configuration (`fzf.sh`)
6. Local overrides (`local.sh`, if exists)

**You should source this file from your `.bashrc` or `.zshrc`.**

### aliases.sh - Command Aliases

Define your command shortcuts here. Includes common aliases for:
- Navigation (`..`, `...`, etc.)
- File operations (`ll`, `la`, etc.)
- Git shortcuts (`gs`, `ga`, `gc`, etc.)
- Docker commands (`dps`, `dex`, etc.)
- System monitoring and utilities

> 📖 **See [Aliases Reference](docs/ALIASES.md) for a complete list of all available aliases.**

**Example:**
```bash
alias myproject='cd ~/projects/myapp'
alias dev='npm run dev'
```

### functions.sh - Custom Functions

Add reusable shell functions here. Includes utilities for:
- File operations (`extract`, `backup`, `targz`)
- Directory navigation (`mkcd`)
- Process management (`psgrep`, `killps`)
- Development tools (`serve`, `gcl`)
- And more...

**Example:**
```bash
deploy() {
    echo "Deploying to production..."
    ./scripts/deploy.sh
}
```

### env.sh - Environment Variables

Export environment variables here. Includes:
- Editor configuration
- History settings
- Colored man pages
- Custom application variables

**Example:**
```bash
export EDITOR="code"
export PROJECTS_DIR="$HOME/projects"
export NODE_ENV="development"
```

**⚠️ Never commit secrets or API keys!** Use `.env.local` for sensitive data.

### paths.sh - PATH Configuration

Manage your PATH here. Automatically adds directories to PATH if they exist:
- Local bin directories
- Programming language tools (Node, Python, Ruby, Go, Rust, etc.)
- Package managers (npm, pip, cargo, etc.)
- Custom binary directories

**Example:**
```bash
# Add project bin to PATH
_add_to_path "$HOME/projects/tools/bin"
```

### fzf.sh - FZF Configuration

Configures fuzzy finding with fzf for interactive workflows:
- Custom color scheme and UI options
- Native key bindings (Ctrl-T, Ctrl-R, Alt-C)
- Custom key bindings (Ctrl-G, Ctrl-P, Ctrl-K)
- Preview windows with bat/exa integration
- Smart command detection (fd, rg, bat, exa)
- Shell-specific integrations for bash and zsh
- Tmux integration for popup mode

**Features:**
- Interactive file finder with preview
- Fuzzy directory navigation
- Git branch/log browser
- Process management
- Command history search
- Project switcher

**Key Bindings:**
- `Ctrl-T`: Fuzzy file finder
- `Ctrl-R`: Command history search
- `Alt-C`: Fuzzy directory navigation
- `Ctrl-G` / `Alt-G`: Git branch checkout

**FZF Features:**
- `fzgr`: Interactive unstage of staged files with preview
- `fzgbd -y`: Pass `-y` to skip confirmations and delete selected local branches

**FZF Aliases:** All FZF-powered aliases use the `fz` prefix (e.g., `fzff`, `fzcd`, `fzgbc`, `fzp`).

> 📖 **See [Aliases Reference](docs/ALIASES.md#fzf-powered-aliases) for complete FZF alias documentation.**
- `Ctrl-G`: Git branch selector
- `Ctrl-P`: Project switcher
- `Ctrl-K`: Interactive process killer
- `Ctrl-/`: Toggle preview window

### local.sh - Local Overrides (Optional)

Create this file for machine-specific configurations that shouldn't be tracked in git:

```bash
# Create local overrides file
touch ~/.shellkit/local.sh

# Add machine-specific configurations
echo 'alias work="cd /path/to/work/projects"' >> ~/.shellkit/local.sh
```

### .env.local - Local Environment Variables (Optional)

For sensitive or machine-specific environment variables:

```bash
# Copy the example file
cp ~/.shellkit/.env.example ~/.shellkit/.env.local

# Edit with your secrets
vim ~/.shellkit/.env.local
```

## Usage Examples

### Using Aliases

```bash
# Navigate quickly
..              # Go up one directory
...             # Go up two directories

# Git shortcuts
gs              # git status
ga .            # git add .
gc -m "fix"     # git commit -m "fix"
gp              # git push

# Docker
dps             # docker ps
dex mycontainer bash  # docker exec -it mycontainer bash
```

### Using Functions

```bash
# Extract any archive
extract myfile.tar.gz

# Create directory and cd into it
mkcd my-new-project

# Find files (uses fd if available)
ff "*.js"       # Find JavaScript files
fdir "node_modules"  # Find node_modules directories

# Backup a file
backup important.txt  # Creates important.txt.backup-20231125-143022

# Start a local web server
serve 8080      # Serve current directory on port 8080

# Clone and cd
gcl https://github.com/user/repo.git

# Take quick notes
note "Remember to update documentation"
note            # Display all notes
```

### Using FZF Commands

```bash
# Interactive file search and edit
fzff            # Quick file search and edit (alias for fzf_file)

# Interactive directory navigation
fzcd            # Interactive cd with preview (alias for fzf_cd)

# Search file contents and open in editor
fzrg "search term"  # Search contents and edit (alias for fzf_rg, requires ripgrep)

# Git operations
fzgbc           # Interactive git branch checkout (local + remote)
fzgl            # Interactive git log browser
fzgbd           # Interactive git branch delete (use -y to skip confirmation)
fzgr            # Interactive unstage (select staged files to reset)

# System management
fkill           # Interactive process killer
fh              # Search command history

# Project navigation
fp              # Quick project switcher

# Docker
fd-container    # Interactive docker container shell

# Browse configuration
fzf-env         # Browse environment variables
fzf-alias       # Browse available aliases

# Native fzf key bindings (press while typing)
Ctrl-T          # Find files in current directory
Ctrl-R          # Search command history
Alt-C           # Find and cd to directory
Ctrl-G          # Git branch selector
Ctrl-P          # Project switcher
Ctrl-K          # Process killer
```

### Advanced Git Workflows with FZF

```bash
# Interactive file selection and staging
fzf_git_files   # List all modified/staged/untracked files
                # Press TAB to select multiple, Enter to return selection

# Stage specific files interactively
fzga            # Pick which modified files to stage
                # Multi-select with TAB, see diff preview

# Review what you're about to commit
fzgdc           # Browse staged files with diff preview
                # Navigate with arrow keys, quit with ESC

# Review unstaged changes
fzgd            # Browse modified files with diff preview

# Quick workflow example:
fzga            # Pick files to stage
fzgdc           # Review staged changes
gc -m "feat: add feature"  # Commit
fzgbc           # Switch to another branch

# Reset staged files
greset          # Unstage all files and show status
fzgr            # Interactive unstage with file selection
```

### VS Code Integration

```bash
# Open files interactively with VS Code
vs              # No args: pick file with fzf, open in current window
vs file.js      # With args: open specific file
vs .            # Open current directory

# Combined with other commands
frg "TODO"      # Find TODO comments, open file at line in VS Code
```

### Modern Tool Examples

```bash
# Use eza instead of ls (if installed)
ll              # Long listing with icons and colors
la              # Show all files
lt              # Tree view of directory
l.              # Show only hidden files

# Use bat instead of cat (if installed)
cat file.js     # Syntax highlighted output (no paging)
less file.js    # Syntax highlighted with paging

# Use rg instead of grep (if installed)
grep "pattern"  # Fast search with rg
ag "pattern"    # Alias for rg

# Use fd instead of find (if available in functions)
ff "*.md"       # Find markdown files
fdir "src"      # Find directories named src
```

### Workspace Navigation

```bash
# Quick workspace access
ws              # Go to ~/ws or ~/workspace

# Project navigation (if configured)
elcows          # Navigate to elco workspace
up              # Go to unified-platform
gal             # Go to galactus
bf              # Go to bifrost service

# Custom project shortcuts (add to local.sh)
alias myapp='cd ~/ws/my-application'
alias frontend='myapp && cd frontend'
alias backend='myapp && cd backend'
```

### Productivity Tips

```bash
# Quick directory creation and navigation
mkcd project/src/components  # Creates nested dirs and cd

# Extract any archive automatically
extract archive.tar.gz
extract file.zip
extract data.tar.bz2

# Backup before editing
backup config.json          # Creates config.json.backup-20251128-143022
vim config.json

# Quick HTTP server for testing
serve 3000                  # Start server on port 3000
# Open http://localhost:3000 in browser

# Search and replace with history
fh                          # Search command history interactively
Ctrl-R                      # Native fuzzy history search

# Process management
psgrep node                 # Find node processes
fkill                       # Interactively kill processes
killps node                 # Kill processes by name

# Quick notes
note "Bug: API returns 500 on user update"
note "TODO: Refactor auth module"
note                        # View all notes

# View PATH in readable format
showpath                    # Shows PATH entries numbered
```

### Development Workflows

```bash
# Start a new feature
fzgbc                       # Switch to develop branch
git pull
git checkout -b feature/new-feature
mkcd src/components/NewFeature

# Work on multiple projects
fp                          # Fuzzy project switcher
# Select project, instantly cd there

# Debug with containers
d ps                        # docker ps
fd-container               # Pick container, get shell
dlogs container-name       # Follow logs

# Quick git workflow
gs                          # Check status
fzga                        # Stage files interactively
gc -m "feat: implement feature"
gp                          # Push

# Review changes before committing
fzgd                        # Browse unstaged changes
fzgdc                       # Browse staged changes
greset                      # Unstage if needed
```

### Zoxide Integration (Smart cd)

```bash
# After using zoxide for a while:
z project       # Jump to most frequent "project" directory
z doc           # Jump to documents
zi              # Interactive directory picker

# Zoxide learns your habits:
cd ~/ws/elco/unified-platform/galactus/service/bifrost
# Later, just:
z bifrost       # Jumps there directly
```

## Real-World Scenarios

### Scenario 1: Starting Work on a New Machine

```bash
# Clone and install
git clone https://github.com/yourusername/shellkit.git ~/.shellkit
cd ~/.shellkit
./install.sh

# Set up local overrides
cp .env.example .env.local
vim .env.local              # Add API keys, secrets

# Add machine-specific aliases
echo 'alias work="cd /work/projects"' >> local.sh

# Reload and test
source ~/.bashrc
ll                          # Test eza integration
f                           # Test fzf
```

### Scenario 2: Debugging Production Issue

```bash
ws                          # Go to workspace
fp                          # Pick project with fzf
checkout main               # Switch to main branch
git pull
frg "ERROR"                 # Find error logs with preview
dlogs production-app        # Check container logs
fkill                       # Kill stuck processes if needed
```

### Scenario 3: Code Review Workflow

```bash
fzgbc                       # Switch to feature branch
fzf_git_files               # See all changes
fzgd                        # Review unstaged changes
fzgdc                       # Review staged changes
fzgl                        # Browse commit history
vs                          # Open file in VS Code
```

### Scenario 4: Multi-Project Development

```bash
# Terminal 1: Backend
ws
cd backend
serve 8080

# Terminal 2: Frontend  
ws
cd frontend
npm run dev

# Terminal 3: Testing
fh                          # Search for previous test commands
fzga                        # Stage test files
gc -m "test: add integration tests"
```

## Native fzf key bindings (press while typing)
Ctrl-T          # Find files in current directory
Ctrl-R          # Search command history
Alt-C           # Find and cd to directory
Ctrl-G          # Git branch selector
Ctrl-P          # Project switcher
Ctrl-K          # Process killer
```

## Customization

### Adding Your Own Configurations

### Adding Your Own Configurations

1. **Add aliases**: Edit `aliases.sh`
2. **Add functions**: Edit `functions.sh`
3. **Add environment variables**: Edit `env.sh`
4. **Add to PATH**: Edit `paths.sh`

### Machine-Specific Settings

Use `local.sh` and `.env.local` for settings unique to each machine:

```bash
# In local.sh
alias mycompany='cd /work/company/projects'

# In .env.local
export COMPANY_API_KEY="secret-key-here"
export DATABASE_URL="postgresql://localhost/mydb"
```

## Syncing Across Machines

### Initial Setup on a New Machine

```bash
# Clone your repository
git clone <your-repo-url> ~/.shellkit

# Add to shell config (bash or zsh)
echo '[ -f "$HOME/.shellkit/init.sh" ] && source "$HOME/.shellkit/init.sh"' >> ~/.bashrc

# Reload shell
source ~/.bashrc
```

### Updating Configurations

```bash
# Pull latest changes
cd ~/.shellkit
git pull

# Reload shell
source ~/.bashrc  # or source ~/.zshrc
```

### Pushing Your Changes

```bash
cd ~/.shellkit
git add .
git commit -m "Add new aliases and functions"
git push
```

## Troubleshooting

### Configuration not loading

```bash
# Check if init.sh is being sourced
grep shellkit ~/.bashrc ~/.zshrc

# Verify file exists
ls -la ~/.shellkit/init.sh

# Check for errors
bash -x ~/.shellkit/init.sh
```

### Verbose loading

Enable verbose mode to see what's loading:

```bash
export SHELLKIT_VERBOSE=1
source ~/.shellkit/init.sh
```

### Shell detection issues

Check which shell is detected:

```bash
echo $SHELLKIT_SHELL  # Should output 'bash' or 'zsh'
```

## Best Practices

1. **Never commit secrets**: Use `.env.local` for API keys and sensitive data
2. **Test before pushing**: Ensure changes work on your machine before pushing
3. **Document your additions**: Add comments explaining custom configurations
4. **Use local overrides**: Keep machine-specific settings in `local.sh`
5. **Keep it simple**: Don't overcomplicate your configurations
6. **Regular backups**: Commit and push changes regularly

## Environment Variables

The following environment variables are set by shellkit:

- `SHELLKIT_DIR`: Directory where shellkit is installed
- `SHELLKIT_SHELL`: Detected shell type (`bash` or `zsh`)
- `SHELLKIT_VERBOSE`: Set to `1` to enable verbose loading messages

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for:
- How to report bugs
- How to suggest features
- Code style guidelines
- Pull request process

Please read our [Code of Conduct](CODE_OF_CONDUCT.md) before contributing.

## Security

See [SECURITY.md](SECURITY.md) for security policy and reporting vulnerabilities.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for release history and version changes.

## License

MIT License - See [LICENSE](LICENSE) file for details.

## Support

- 📖 Read the [documentation](README.md)
- 📚 Browse [all available aliases](docs/ALIASES.md)
- 🐛 Report bugs via [GitHub Issues](https://github.com/YOUR-USERNAME/shellkit/issues)
- 💡 Request features via [GitHub Issues](https://github.com/YOUR-USERNAME/shellkit/issues)
- 💬 Join discussions on [GitHub Discussions](https://github.com/YOUR-USERNAME/shellkit/discussions)
- ⭐ Star the repo if you find it useful!

## Tips

- Run `reload` alias to quickly reload your shell configuration
- Use `showpath` to see your PATH in a readable format
- The `mkcd` function is a game-changer for creating and entering directories
- Set `SHELLKIT_VERBOSE=1` in your shell config for debugging
- Use tab completion - most functions support it!
- Browse all aliases with `fzf-alias` or check the [Aliases Reference](docs/ALIASES.md)
- All FZF aliases use the `fz` prefix for consistency (e.g., `fzff`, `fzcd`, `fzgbc`, `fzp`)

## Recommended Tools

For the best experience, install these modern CLI tools:

```bash
# On Ubuntu/Debian
sudo apt install fd-find ripgrep fzf bat exa

# On macOS
brew install fd ripgrep fzf bat eza

# On Arch Linux
sudo pacman -S fd ripgrep fzf bat exa
```

**What they do:**
- `fd`: Fast alternative to `find`
- `ripgrep` (rg): Fast alternative to `grep`
- `fzf`: Fuzzy finder for interactive selection
- `bat`: Cat with syntax highlighting
- `eza`: Modern ls replacement

All features gracefully fall back to standard tools if these aren't installed.

## Docker Testing

Want to test shellkit in an isolated environment? See [docs/DOCKER.md](docs/DOCKER.md) for instructions on using Docker containers with all tools pre-installed.

---

**Happy shell customization!** 🚀

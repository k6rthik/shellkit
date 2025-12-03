# shellkit Quick Start Guide

Get up and running with shellkit in 5 minutes! ⚡

## TL;DR

```bash
# 1. Clone
git clone https://github.com/YOUR-USERNAME/shellkit.git ~/.shellkit

# 2. Install
cd ~/.shellkit
./install.sh

# 3. Reload shell
source ~/.bashrc  # or source ~/.zshrc

# 4. Test
echo $SHELLKIT_DIR  # Should output: /Users/you/.shellkit
ll                 # Try an alias
```

## Step-by-Step Installation

### 1. Clone the Repository

Choose your installation location:

```bash
# Option A: Install in home directory (recommended)
git clone https://github.com/YOUR-USERNAME/shellkit.git ~/.shellkit

# Option B: Install in custom location
git clone https://github.com/YOUR-USERNAME/shellkit.git ~/path/to/shellkit
```

### 2. Run the Installer

```bash
cd ~/.shellkit
./install.sh
```

The installer will:
- Detect your shell (bash/zsh)
- Add source line to your shell config
- Create `.env.local` and `local.sh` for local overrides
- Back up your existing config

### 3. Reload Your Shell

```bash
# For bash
source ~/.bashrc

# For zsh
source ~/.zshrc

# Or just open a new terminal
```

### 4. Verify Installation

```bash
# Check environment variables
echo $SHELLKIT_DIR    # Should show installation path
echo $SHELLKIT_SHELL  # Should show 'bash' or 'zsh'

# Try some commands
ll                   # List with details
..                   # Go up one directory
gs                   # Git status
```

## First Steps

### 1. Explore Available Commands

```bash
# List all aliases
alias | grep -v '^_'

# Try navigation
..        # Up one directory
...       # Up two directories
~         # Go home

# Try Git aliases
gs        # git status
ga .      # git add .
gc -m ""  # git commit
```

### 2. Set Up Local Configuration

```bash
# Edit local environment variables
vim ~/.shellkit/.env.local

# Add machine-specific settings
echo 'export MY_PROJECT_DIR="$HOME/work/projects"' >> ~/.shellkit/.env.local

# Add local aliases
echo 'alias work="cd $MY_PROJECT_DIR"' >> ~/.shellkit/local.sh

# Reload
source ~/.bashrc  # or ~/.zshrc
```

### 3. Install Recommended Tools (Optional)

For the best experience:

**macOS:**
```bash
brew install fd ripgrep fzf bat eza zoxide
```

**Ubuntu/Debian:**
```bash
sudo apt install fd-find ripgrep fzf bat exa
```

**Arch Linux:**
```bash
sudo pacman -S fd ripgrep fzf bat exa zoxide
```

### 4. Try FZF Features

```bash
# Interactive file finder
Ctrl-T

# Command history search
Ctrl-R

# Directory navigation
Alt-C

# Git branch switcher
Ctrl-G
```

## Common Tasks

### Adding a Custom Alias

```bash
# Edit aliases.sh
vim ~/.shellkit/aliases.sh

# Add your alias
alias mycommand='echo "Hello!"'

# Reload
source ~/.bashrc
```

### Adding a Custom Function

```bash
# Edit functions.sh
vim ~/.shellkit/functions.sh

# Add your function
myfunction() {
    echo "My function: $1"
}

# Reload
source ~/.bashrc

# Use it
myfunction test
```

### Machine-Specific Settings

```bash
# For settings you don't want in git
vim ~/.shellkit/local.sh

# Add machine-specific aliases
alias work='cd /work/projects'
alias vpn='sudo openvpn /etc/vpn/config.ovpn'

# These won't be committed to git
```

## Syncing to Another Machine

### On New Machine

```bash
# Clone your fork
git clone https://github.com/YOUR-USERNAME/shellkit.git ~/.shellkit

# Run installer
cd ~/.shellkit
./install.sh

# Reload shell
source ~/.bashrc

# Done! 🎉
```

### Updating Configuration

```bash
# Pull latest changes
cd ~/.shellkit
git pull

# Reload shell
source ~/.bashrc
```

### Pushing Your Changes

```bash
# Make changes to aliases.sh, functions.sh, etc.
cd ~/.shellkit

# Commit and push
git add .
git commit -m "Add my custom aliases"
git push

# Changes are now available on all machines
```

## Troubleshooting

### shellkit not loading

```bash
# Check if it's sourced
grep shellkit ~/.bashrc ~/.zshrc

# Should see:
# [ -f "$HOME/.shellkit/init.sh" ] && source "$HOME/.shellkit/init.sh"
```

### Commands not found

```bash
# Enable verbose mode
export SHELLKIT_VERBOSE=1
source ~/.shellkit/init.sh

# Check what's loading
```

### Conflicts with existing config

```bash
# Check your existing config
cat ~/.bashrc | grep -v shellkit > ~/.bashrc.backup

# Review conflicts
vim ~/.bashrc
```

## Next Steps

1. **Customize**: Add your favorite aliases and functions
2. **Explore**: Try the FZF key bindings
3. **Sync**: Push your changes to GitHub
4. **Share**: Install on your other machines
5. **Contribute**: Submit improvements back to the project

## Quick Reference

### Essential Aliases
```bash
ll        # List files with details
la        # List all files including hidden
gs        # git status
ga        # git add
gc        # git commit
gp        # git push
d         # docker
dps       # docker ps
..        # cd ..
...       # cd ../..
```

### Essential Functions
```bash
mkcd dir           # Create and cd into directory
extract file.zip   # Extract any archive
backup file.txt    # Create timestamped backup
f                  # Fuzzy file finder
fcd                # Fuzzy directory changer
serve 8080         # Start HTTP server
```

### Essential Keys
```bash
Ctrl-T    # Find files
Ctrl-R    # Search history
Alt-C     # Find directories
Ctrl-G    # Git branch selector
Ctrl-K    # Kill processes
```

## Getting Help

- 📖 Full documentation: [README.md](README.md)
- 🐛 Report issues: [GitHub Issues](https://github.com/YOUR-USERNAME/shellkit/issues)
- 💡 Discussions: [GitHub Discussions](https://github.com/YOUR-USERNAME/shellkit/discussions)
- 🤝 Contributing: [CONTRIBUTING.md](CONTRIBUTING.md)

---

**Welcome to shellkit!** 🎉

Start by trying `ll`, then explore from there. Happy customizing!

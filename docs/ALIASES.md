# Shell Aliases Reference

This document provides a comprehensive list of all aliases available in shellkit, organized by category.

## Table of Contents

- [Navigation](#navigation)
- [File Operations](#file-operations)
- [Git Aliases](#git-aliases)
- [Docker Aliases](#docker-aliases)
- [System Monitoring](#system-monitoring)
- [Network Tools](#network-tools)
- [Disk Usage](#disk-usage)
- [Process Management](#process-management)
- [Date and Time](#date-and-time)
- [Shell Configuration](#shell-configuration)
- [Package Management](#package-management)
- [FZF-Powered Aliases](#fzf-powered-aliases)
- [FZF Helper Functions](#fzf-helper-functions)

---

## Navigation

Quick directory navigation shortcuts.

| Alias | Command | Description |
|-------|---------|-------------|
| `..` | `cd ..` | Go up one directory |
| `...` | `cd ../..` | Go up two directories |
| `....` | `cd ../../..` | Go up three directories |
| `~` | `cd ~` | Go to home directory |
| `-` | `cd -` | Go to previous directory |
| `pg` | `cd` | Alias for cd (page/go) |
| `ws` | `cd ~/ws` | Go to workspace (if exists) |

---

## File Operations

Enhanced file listing and manipulation with safety nets.

| Alias | Command | Description |
|-------|---------|-------------|
| `ls` | `eza --color=always --group-directories-first` or `ls --color=auto` | List files with colors (uses eza if available) |
| `ll` | `eza -alF --color=always --group-directories-first --icons` or `ls -alF` | Long format with icons |
| `la` | `eza -a --color=always --group-directories-first` or `ls -A` | List all files including hidden |
| `l` | `eza -F --color=always --group-directories-first` or `ls -CF` | Simple file list |
| `lt` | `eza -aT --color=always --group-directories-first --icons` | Tree view (eza only) |
| `l.` | `eza -a \| grep "^\."` | Show only hidden files (eza only) |
| `cp` | `cp -i` | Copy with confirmation prompt |
| `mv` | `mv -i` | Move with confirmation prompt |
| `rm` | `rm -i` | Remove with confirmation prompt |
| `mkdir` | `mkdir -pv` | Create directories recursively with verbose output |
| `cat` | `bat --paging=never` or `cat` | Display file contents (uses bat if available) |
| `less` | `bat` or `less` | Paginated file viewer (uses bat if available) |

---

## Git Aliases

Shortcuts for common git operations.

| Alias | Command | Description |
|-------|---------|-------------|
| `g` | `git` | Short for git |
| `gs` | `git status` | Show git status |
| `ga` | `git add` | Stage files |
| `gc` | `git commit` | Commit changes |
| `gp` | `git push` | Push to remote |
| `gl` | `git log --oneline --graph --decorate` | Pretty git log |
| `gd` | `git diff` | Show git diff |
| `gco` | `git checkout` | Checkout branch/file |
| `gb` | `git branch` | List/create branches |
| `greset` | `git reset HEAD $(git diff --cached --name-only); git status` | Unstage all files |
| `fzgr` | `fzf_git_reset_staged` | Interactive unstage with preview - select staged files and run `git reset HEAD -- <file>` |

---

## Docker Aliases

Docker and Docker Compose shortcuts.

| Alias | Command | Description |
|-------|---------|-------------|
| `d` | `docker` | Short for docker |
| `dc` | `docker-compose` | Short for docker-compose |
| `dps` | `docker ps` | List running containers |
| `dpsa` | `docker ps -a` | List all containers |
| `di` | `docker images` | List docker images |
| `dex` | `docker exec -it` | Execute command in container |
| `dlogs` | `docker logs -f` | Follow container logs |

---

## System Monitoring

System resource and process monitoring.

| Alias | Command | Description |
|-------|---------|-------------|
| `ports` | `netstat -tulanp` | Show all listening ports |
| `psmem` | `ps auxf \| sort -nr -k 4 \| head -10` | Top 10 memory-consuming processes |
| `pscpu` | `ps auxf \| sort -nr -k 3 \| head -10` | Top 10 CPU-consuming processes |
| `psg` | `ps aux \| grep -v grep \| grep -i -e VSZ -e` | Search processes (use: `psg <name>`) |

---

## Network Tools

Network and IP address utilities.

| Alias | Command | Description |
|-------|---------|-------------|
| `myip` | `curl -s http://ipecho.net/plain; echo` | Show public IP address |
| `localip` | `ip addr show \| grep 'inet ' \| grep -v 127.0.0.1 \| awk '{print $2}' \| cut -d/ -f1` | Show local IP address |
| `wget` | `wget -c` | Resume-capable wget |
| `lhr` | `ssh -o ServerAliveInterval=60 -R 80:localhost:4005 localhost.run` | Localhost tunnel via localhost.run |

---

## Disk Usage

Disk space and file size utilities.

| Alias | Command | Description |
|-------|---------|-------------|
| `df` | `df -h` | Show disk usage in human-readable format |
| `du` | `du -h` | Show directory sizes in human-readable format |
| `dush` | `du -sh` | Show total size of directory |

---

## Process Management

Process search and management aliases.

| Alias | Command | Description |
|-------|---------|-------------|
| `grep` | `rg` or `grep --color=auto` | Search with color (uses ripgrep if available) |
| `ag` | `rg` | Alias for ripgrep (if available) |
| `fgrep` | `fgrep --color=auto` | Fixed-string grep with color |
| `egrep` | `egrep --color=auto` | Extended regex grep with color |

---

## Date and Time

Quick date and time formatting.

| Alias | Command | Description |
|-------|---------|-------------|
| `now` | `date +"%Y-%m-%d %H:%M:%S"` | Show current date and time |
| `nowdate` | `date +"%Y-%m-%d"` | Show current date only |

---

## Shell Configuration

Quick access to shell configuration files.

| Alias | Command | Description |
|-------|---------|-------------|
| `zshrc` | `${EDITOR:-vim} ~/.zshrc` | Edit zsh configuration |
| `bashrc` | `${EDITOR:-vim} ~/.bashrc` | Edit bash configuration |
| `vimrc` | `${EDITOR:-vim} ~/.vimrc` | Edit vim configuration |
| `reload` | `source ~/.${SHELLKIT_SHELL}rc` | Reload shell configuration |
| `c` | `clear` | Clear terminal screen |
| `cl` | `clear && ls` | Clear screen and list files |
| `mkcd` | `_mkcd` | Create directory and cd into it (function) |

---

## Package Management

OS-specific package management shortcuts (auto-detected).

### Ubuntu/Debian (apt-get)
| Alias | Command | Description |
|-------|---------|-------------|
| `update` | `sudo apt-get update && sudo apt-get upgrade` | Update and upgrade packages |
| `install` | `sudo apt-get install` | Install package |

### RedHat/CentOS (yum)
| Alias | Command | Description |
|-------|---------|-------------|
| `update` | `sudo yum update` | Update packages |
| `install` | `sudo yum install` | Install package |

### macOS (Homebrew)
| Alias | Command | Description |
|-------|---------|-------------|
| `update` | `brew update && brew upgrade` | Update Homebrew and packages |
| `install` | `brew install` | Install package |

---

## FZF-Powered Aliases

Interactive fuzzy finding aliases for enhanced productivity. All FZF aliases use the `fz` prefix.

> **Note:** These aliases require [fzf](https://github.com/junegunn/fzf) to be installed.

| Alias | Function | Key Binding | Description |
|-------|----------|-------------|-------------|
| `fzco` | Inline git switch | - | Interactive git branch checkout (simple) |
| `fzff` | `fzf_file` | `Alt-F` | Search and edit file |
| `fzcd` | `fzf_cd` | `Alt-D` | Interactive directory navigation |
| `fzk` | `fzf_kill` | `Alt-K` | Interactive process killer |
| `fzga` | `fzf_git_add` | - | Interactive git add (stage files) |
| `fzgbc` | `fzf_git_branch_checkout` | `Ctrl-G`, `Alt-G` | Interactive git branch checkout (local + remote) |
| `fzgd` | `fzf_git_diff` | - | Interactive git diff (unstaged changes) |
| `fzgdc` | `fzf_git_diff_cached` | - | Interactive git diff (staged changes) |
| `fzgl` | `fzf_git_log` | - | Interactive git log browser |
| `fzgbd` | `fzf_git_branch_delete` | - | Interactive git branch delete with -y option |
| `fzgr` | `fzf_git_reset_staged` | - | Interactive git reset (unstage files) |
| `fzh` | `fzf_history` | `Ctrl-R` (native) | Interactive command history search |
| `fzp` | `fzf_project` | `Ctrl-P`, `Alt-P` | Quick project directory switcher |
| `fzd` | `fzf_docker` | - | Interactive docker container shell |
| `fzrg` | `fzf_rg` | - | Search file contents and edit |

---

## FZF Helper Functions

Additional FZF-powered functions available as commands (not aliases).

| Function | Description | Usage |
|----------|-------------|-------|
| `vs` | Open file in VS Code with fuzzy finder | `vs` (no args opens picker) |
| `fzf_git_files` | List git modified/cached/untracked files with preview | `fzf_git_files` |
| `fzf_git_diff` | Interactive git diff file picker (unstaged) | `fzgd` or `fzf_git_diff` |
| `fzf_git_diff_cached` | Interactive git diff file picker (staged) | `fzgdc` or `fzf_git_diff_cached` |
| `fzf_git_add` | Interactive git add (select files to stage) | `fzga` or `fzf_git_add` |
| `fzf_git_branch_delete` | Interactive git branch delete with -y option | `fzgbd` or `fzf_git_branch_delete [-y]` |
| `fzf_alias` | Browse and search shell aliases | `fzf-alias` |
| `fzf_env` | Browse and search environment variables | `fzf-env` |

---

## Default FZF Key Bindings

FZF provides these native key bindings when properly installed:

| Key Binding | Function | Description |
|-------------|----------|-------------|
| `Ctrl-T` | File finder | Paste selected files/directories |
| `Ctrl-R` | History search | Search and execute command from history |
| `Alt-C` | Directory navigation | Change to selected directory |
| `**<Tab>` | Completion trigger | FZF completion for paths/commands |

---

## FZF Preview Controls

When using FZF-powered commands, these keys control the preview window:

| Key | Action |
|-----|--------|
| `Ctrl-/` | Toggle preview window |
| `Ctrl-U` | Scroll preview up |
| `Ctrl-D` | Scroll preview down |
| `Ctrl-A` | Select all results |
| `Ctrl-Y` | Copy selection to clipboard (macOS) |

---

## Customization

To add your own aliases:

1. For general aliases, add them to `aliases.sh` under the custom section
2. For FZF-related aliases, add them to `fzf.sh`
3. For machine-specific aliases, add them to `local.sh` (not tracked by git)

### Example: Adding a Custom Alias

```bash
# In aliases.sh
alias myproject='cd ~/projects/my-awesome-app'
alias deploy='./scripts/deploy.sh'
```

---

## Related Documentation

- [Main README](../README.md)
- [Quick Start Guide](../QUICKSTART.md)
- [FZF Configuration](../fzf.sh)
- [Functions Reference](../functions.sh)

---

**Last Updated:** December 2025

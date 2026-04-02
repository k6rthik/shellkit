# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Project Is

**shellkit** is a portable, modular shell configuration framework for bash and zsh. Users source `init.sh` from their `.bashrc`/`.zshrc`, which loads all configuration modules in order.

## Running Tests and Linting

```bash
# Run the full test suite (must source init.sh first)
source ./init.sh && ./tests/test.sh

# Syntax check a shell file
bash -n filename.sh

# Lint with ShellCheck (mirrors CI)
shellcheck --severity=warning aliases.sh functions.sh env.sh paths.sh init.sh tools_init.sh
```

**Test Coverage**: The test suite validates:
- Environment variable setup (`SHELLKIT_DIR`, `SHELLKIT_SHELL`)
- Alias availability (e.g., `ll`, `gs`, FZF-powered aliases)
- Function availability (e.g., `extract`, `mkcd`, FZF functions)
- PATH modifications (`.local/bin` in PATH, tool availability)
- FZF integration (when fzf is installed)
- Tool-specific completions and initializations

## Architecture: Load Order in init.sh

`init.sh` is the sole entry point. It sources modules in this strict order:
1. `env.sh` — environment variables (loaded first; others may depend on them)
2. `paths.sh` — PATH modifications
3. `tools_init.sh` — third-party tool initialization (asdf, zoxide, gh, etc.)
4. `functions.sh` — custom shell functions
5. `aliases.sh` — aliases (last, may reference functions)
6. `fzf.sh` — FZF key bindings and fuzzy commands (conditional: requires fzf)
7. `wsl.sh` — WSL-specific setup (conditional)
8. `local.sh` — machine-specific overrides (not tracked in git)

**Not tracked in git:** `local.sh` and `.env.local` — these are intentional escape hatches for per-machine config and secrets.

## Key Environment Variables

- `SHELLKIT_DIR` — absolute path to the shellkit install directory (set by `init.sh`)
- `SHELLKIT_SHELL` — detected shell: `bash` or `zsh`
- `SHELLKIT_VERBOSE=1` — print load messages for debugging

## Optional Tools and Modern CLI Enhancements

Many features in shellkit are **enhanced** (not required) by modern CLI tools:

| Tool | What it enhances | Install with |
|------|-----------------|--------------|
| `fzf` | FZF key bindings, interactive commands (`fzgbc`, `fzcd`, etc.) | `install_tools.sh` |
| `fd` | File finding (used in FZF commands, `ff` function) | `install_tools.sh` |
| `rg` | Content searching (used in FZF commands, fallback for `grep`) | `install_tools.sh` |
| `bat` | Syntax highlighting for file previews and `cat` | `install_tools.sh` |
| `eza` | Modern `ls` replacement with colors/icons | `install_tools.sh` |
| `zoxide` | Smart `cd` with frecency (`z` alias) | `install_tools.sh` |
| `starship` | Modern shell prompt | `install_tools.sh` |
| `asdf` | Version management; completions loaded in `tools_init.sh` | Manual install |
| `gh` | GitHub CLI; GitHub Copilot integration in `tools_init.sh` | Manual install |

**Key pattern**: Code always checks for tool existence before using it (e.g., `command -v fzf &> /dev/null`). Features gracefully degrade if tools aren't installed.

**For development**: Use `./check_tools.sh` to see what's installed, or `./install_tools.sh` to set up the environment.

## Code Conventions

**Cross-shell compatibility is the #1 constraint.** All code must work in both bash and zsh.

- Use `#!/usr/bin/env bash` as the shebang
- Always quote variables: `"$var"` not `$var`
- Check command existence with `command -v foo &> /dev/null` before using or aliasing
- Check directory/file existence before sourcing or adding to PATH
- Use `local` for function-scoped variables
- Prefix internal/helper functions with `_` (e.g., `_add_to_path`)
- Unset helper functions after use (see `paths.sh` pattern)
- Use `[ -f "$file" ]` not `[[ ]]` for POSIX compatibility in existence checks
- OS detection: `[[ "$OSTYPE" == "linux-gnu"* ]]` vs `[[ "$OSTYPE" == "darwin"* ]]`
- Optional tools: Always check with `command -v toolname &> /dev/null` before using (see examples in `functions.sh`, `fzf.sh`)
- FZF-based features: Wrap in `command -v fzf &> /dev/null &&` to skip if fzf isn't installed

**Where to add things:**
- New alias → `aliases.sh` (group with related aliases, add comment)
- New function → `functions.sh` (include usage message, validate args, return meaningful exit codes)
- New env var → `env.sh` (with comment; use `${VAR:-default}` pattern)
- New PATH entry → `paths.sh` (use `_add_to_path` helper)
- Tool initialization → `tools_init.sh` (e.g., asdf/zoxide completions, gh extensions, tool-specific aliases)
- Machine-specific → `local.sh` (not committed)
- Secrets → `.env.local` (not committed)

## Debugging

```bash
# Verbose load to trace what's sourcing
SHELLKIT_VERBOSE=1 source ~/.shellkit/init.sh

# Trace execution
bash -x ~/.shellkit/init.sh

# Syntax check only (no execution)
bash -n ~/.shellkit/functions.sh
```

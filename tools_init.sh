#!/usr/bin/env bash
# Tool/command initialization for shellkit
# This file initializes tools that require PATH to be set up (asdf, gh, zoxide, etc.)
# Sourced from init.sh after paths.sh

# Detect shell type for completions and integrations
if [ -n "$ZSH_VERSION" ]; then
    _SHELL_TYPE="zsh"
elif [ -n "$BASH_VERSION" ]; then
    _SHELL_TYPE="bash"
else
    _SHELL_TYPE=""
fi

# Linuxbrew initialization (if installed)
if [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# asdf completion (if asdf is installed)
if command -v asdf &> /dev/null && [ -n "$_SHELL_TYPE" ]; then
    . <(asdf completion "$_SHELL_TYPE")
fi

# GitHub Copilot CLI aliases (if gh copilot is available)
if command -v gh &> /dev/null && gh copilot --version &> /dev/null && [ -n "$_SHELL_TYPE" ]; then
    eval "$(gh copilot alias -- $_SHELL_TYPE)"
fi

# Zoxide initialization (if zoxide is installed)
if command -v zoxide &> /dev/null && [ -n "$_SHELL_TYPE" ]; then
    eval "$(zoxide init $_SHELL_TYPE)"
fi


# Starship prompt initialization (if starship is installed)
if command -v starship &> /dev/null && [ -n "$_SHELL_TYPE" ]; then
    # Starship prompt configuration (loaded near the end)
    _shellkit_source "${SHELLKIT_DIR}/starship.sh"

    eval "$(starship init $_SHELL_TYPE)"
fi

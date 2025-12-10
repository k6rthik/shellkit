#!/usr/bin/env bash
# shellkit - Portable Shell Configuration
# Main initialization file - source this from your .bashrc or .zshrc

# Get the directory where this script is located
SHELLKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")" && pwd)"
export SHELLKIT_DIR

# Detect shell type
if [ -n "$BASH_VERSION" ]; then
    export SHELLKIT_SHELL="bash"
elif [ -n "$ZSH_VERSION" ]; then
    export SHELLKIT_SHELL="zsh"
else
    export SHELLKIT_SHELL="unknown"



    
fi

# Function to safely source a file if it exists
_shellkit_source() {
    if [ -f "$1" ]; then
        # shellcheck disable=SC1090
        source "$1"
    fi
}

# Load configuration files in order
# 1. Environment variables (loaded first, as other configs may depend on them)
_shellkit_source "${SHELLKIT_DIR}/env.sh"

# 2. PATH modifications
_shellkit_source "${SHELLKIT_DIR}/paths.sh"

# 3. Custom functions
_shellkit_source "${SHELLKIT_DIR}/functions.sh"

# 4. Aliases (loaded last, as they may reference functions)
_shellkit_source "${SHELLKIT_DIR}/aliases.sh"

# 5. FZF configuration and key bindings (loaded after aliases)
_shellkit_source "${SHELLKIT_DIR}/fzf.sh"

# 6. WSL-specific initialization (if on WSL)
_shellkit_source "${SHELLKIT_DIR}/wsl.sh"

# 7. Starship prompt configuration (loaded near the end)
_shellkit_source "${SHELLKIT_DIR}/starship.sh"

# Load local overrides if they exist (not tracked in git)
_shellkit_source "${SHELLKIT_DIR}/local.sh"

# Clean up
unset -f _shellkit_source

# Optional: Print loaded message (comment out if you prefer silent loading)
if [ "${SHELLKIT_VERBOSE:-0}" = "1" ]; then
    echo "✓ shellkit loaded from ${SHELLKIT_DIR} (${SHELLKIT_SHELL})"
fi

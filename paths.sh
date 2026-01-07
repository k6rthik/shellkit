#!/usr/bin/env bash
# PATH Configuration
# Add directories to your PATH here

# Helper function to add directory to PATH if it exists and isn't already in PATH
_add_to_path() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}

# Helper function to append directory to PATH if it exists and isn't already in PATH
_append_to_path() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="$PATH:$1"
    fi
}

# Local bin directories (highest priority)
_add_to_path "$HOME/.local/bin"
_add_to_path "$HOME/bin"

# asdf shims (if asdf is installed)
if [ -d "${ASDF_DATA_DIR:-$HOME/.asdf}/shims" ]; then
    _add_to_path "${ASDF_DATA_DIR:-$HOME/.asdf}/shims"
fi

# Programming language-specific paths

# Node.js / npm
_add_to_path "$HOME/.npm-global/bin"
_add_to_path "$HOME/.yarn/bin"
_add_to_path "$HOME/.config/yarn/global/node_modules/.bin"

# Python
_add_to_path "$HOME/.poetry/bin"
_add_to_path "$HOME/.local/share/pyenv/bin"

# Ruby
_add_to_path "$HOME/.rbenv/bin"
_add_to_path "$HOME/.gem/ruby/bin"

# Go
if [ -d "$HOME/go" ]; then
    export GOPATH="$HOME/go"
    _add_to_path "$GOPATH/bin"
fi

# Rust
_add_to_path "$HOME/.cargo/bin"

# Java (SDKMAN)
if [ -d "$HOME/.sdkman" ]; then
    export SDKMAN_DIR="$HOME/.sdkman"
fi

# PHP Composer
_add_to_path "$HOME/.composer/vendor/bin"
_add_to_path "$HOME/.config/composer/vendor/bin"

# Homebrew (macOS)
if [ -d "/opt/homebrew/bin" ]; then
    _add_to_path "/opt/homebrew/bin"
    _add_to_path "/opt/homebrew/sbin"
fi

# Snap
_add_to_path "/snap/bin"

# Custom bin directory for this project
_add_to_path "${SHELLKIT_DIR}/bin"

# Add your custom PATH modifications below this line
# ============================================

# Example: Add a project-specific bin directory
# _add_to_path "$HOME/projects/myapp/bin"

# Example: Add system paths (use _append_to_path for lower priority)
# _append_to_path "/usr/local/go/bin"

# Clean up helper functions
unset -f _add_to_path
unset -f _append_to_path

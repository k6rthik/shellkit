#!/usr/bin/env bash
# Environment Variables
# Add your environment variable exports here

# Editor preferences
export EDITOR="vim"
export VISUAL="vim"

# Default browser (wslview for WSL)
if command -v wslview &> /dev/null; then
    export BROWSER=wslview
fi

# Language and locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.utf8"
export LC_CTYPE="en_US.utf8"

# History configuration
export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTCONTROL=ignoreboth:erasedups  # Ignore duplicates and lines starting with space

# Less pager configuration
export LESS="-R -F -X"
export PAGER="less"

# Colored man pages
export LESS_TERMCAP_mb=$'\e[1;32m'      # Begin blinking
export LESS_TERMCAP_md=$'\e[1;34m'      # Begin bold
export LESS_TERMCAP_me=$'\e[0m'         # End mode
export LESS_TERMCAP_se=$'\e[0m'         # End standout-mode
export LESS_TERMCAP_so=$'\e[01;33m'     # Begin standout-mode (info box)
export LESS_TERMCAP_ue=$'\e[0m'         # End underline
export LESS_TERMCAP_us=$'\e[1;4;31m'    # Begin underline

# Grep colors
export GREP_COLOR='1;33'

# Time format
export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'

# Notes file location (used by the note function)
export NOTES_FILE="$HOME/notes.txt"

# Erlang configuration
export KERL_BUILD_DOCS="yes"
export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"
export ERL_AFLAGS="-kernel shell_history enabled"

# SSL Certificate configuration (if certificate file exists)
if [ -f /etc/ssl/certs/ca-certificates.crt ]; then
    export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
    export HEX_CACERTS_PATH=$SSL_CERT_FILE
    export REQUESTS_CA_BUNDLE=$SSL_CERT_FILE
    export LOCALSTACK_REQUESTS_CA_BUNDLE=$SSL_CERT_FILE
    export CURL_CA_BUNDLE=$SSL_CERT_FILE
    export NODE_EXTRA_CA_CERTS=$SSL_CERT_FILE
fi

# Development directories (customize these)
# PROJECTS_DIR supports multiple directories separated by colons (like PATH)
# Example: export PROJECTS_DIR="$HOME/ws:$HOME/projects:$HOME/work"
export PROJECTS_DIR="$HOME/ws/elco:$HOME/ws/priv"
# export WORKSPACE_DIR="$HOME/workspace"

# Docker MySQL container hostname (for development)
if command -v docker &> /dev/null; then
    DB_HOSTNAME=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mysql-db-1 2>/dev/null)
    if [ -n "$DB_HOSTNAME" ]; then
        export DB_HOSTNAME
    fi
fi

# Add your custom environment variables below this line
# ============================================

# Suppress zoxide doctor warning if zoxide is installed
export _ZO_DOCTOR=0

# Example: API keys and secrets (DO NOT commit actual secrets!)
# export GITHUB_TOKEN="your-token-here"
# export AWS_PROFILE="your-profile"

# Example: Application-specific settings
# export NODE_ENV="development"
# export DOCKER_DEFAULT_PLATFORM="linux/amd64"

# Load local environment variables if they exist (not tracked in git)
if [ -f "${SHELLKIT_DIR}/.env.local" ]; then
    # shellcheck disable=SC1091
    source "${SHELLKIT_DIR}/.env.local"
fi

#!/usr/bin/env bash
# Bootstrap Configuration
# This file contains shell integrations that should load before shellkit

# VS Code shell integration (if running in VS Code terminal)
if [[ "$TERM_PROGRAM" == "vscode" ]] && command -v code &> /dev/null; then
    if [ -n "$ZSH_VERSION" ]; then
        # shellcheck disable=SC1090
        . "$(code --locate-shell-integration-path zsh)" 2>/dev/null
    elif [ -n "$BASH_VERSION" ]; then
        # shellcheck disable=SC1090
        . "$(code --locate-shell-integration-path bash)" 2>/dev/null
    fi
fi

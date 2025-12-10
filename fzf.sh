#!/usr/bin/env bash
# FZF Configuration and Key Bindings
# This file configures fzf options and shell integrations

# Check if fzf is installed
if ! command -v fzf &> /dev/null; then
    return 0
fi

# Load fzf bash integration (if available)
if [ -n "$BASH_VERSION" ] && command -v fzf &> /dev/null; then
    # Modern fzf (0.48+) supports --bash flag
    if fzf --bash &> /dev/null; then
        source <(fzf --bash) 2>/dev/null
        FZF_INTEGRATION_LOADED=1
    fi
fi

# FZF default options
export FZF_DEFAULT_OPTS="
--height 40%
--layout=reverse
--border
--inline-info
--preview-window=right:60%:wrap
--bind='ctrl-/:toggle-preview'
--bind='ctrl-u:preview-page-up'
--bind='ctrl-d:preview-page-down'
--bind='ctrl-a:select-all'
--bind='ctrl-y:execute-silent(echo -n {+} | pbcopy)'
--color=fg:#e5e9f0,bg:#2e3440,hl:#81a1c1
--color=fg+:#e5e9f0,bg+:#3b4252,hl+:#81a1c1
--color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
--color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b
"

# Use fd for default file/directory finding if available
if command -v fd &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
else
    export FZF_DEFAULT_COMMAND='find . -type f 2>/dev/null'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='find . -type d 2>/dev/null'
fi

# Preview command with bat or cat fallback
if command -v bat &> /dev/null; then
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
    export FZF_ALT_C_OPTS="--preview 'exa --tree --level=2 --color=always {} 2>/dev/null || ls -la {}'"
else
    export FZF_CTRL_T_OPTS="--preview 'cat {}'"
    export FZF_ALT_C_OPTS="--preview 'ls -la {}'"
fi

# Load fzf key bindings and completion for bash
if [ -n "$BASH_VERSION" ] && [ -z "$FZF_INTEGRATION_LOADED" ]; then
    # Try common fzf installation locations for bash
    for fzf_path in \
        /usr/share/doc/fzf/examples/key-bindings.bash \
        /usr/share/fzf/key-bindings.bash \
        /usr/local/opt/fzf/shell/key-bindings.bash \
        ~/.fzf/shell/key-bindings.bash \
        /opt/homebrew/opt/fzf/shell/key-bindings.bash; do
        if [ -f "$fzf_path" ]; then
            source "$fzf_path"
            break
        fi
    done

    # Try common locations for bash completion
    for fzf_completion in \
        /usr/share/doc/fzf/examples/completion.bash \
        /usr/share/fzf/completion.bash \
        /usr/local/opt/fzf/shell/completion.bash \
        ~/.fzf/shell/completion.bash \
        /opt/homebrew/opt/fzf/shell/completion.bash; do
        if [ -f "$fzf_completion" ]; then
            source "$fzf_completion"
            break
        fi
    done
fi

# Load fzf key bindings and completion for zsh
if [ -n "$ZSH_VERSION" ]; then
    # Try common fzf installation locations for zsh
    for fzf_path in \
        /usr/share/doc/fzf/examples/key-bindings.zsh \
        /usr/share/fzf/key-bindings.zsh \
        /usr/local/opt/fzf/shell/key-bindings.zsh \
        ~/.fzf/shell/key-bindings.zsh \
        /opt/homebrew/opt/fzf/shell/key-bindings.zsh; do
        if [ -f "$fzf_path" ]; then
            source "$fzf_path"
            break
        fi
    done

    # Try common locations for zsh completion
    for fzf_completion in \
        /usr/share/doc/fzf/examples/completion.zsh \
        /usr/share/fzf/completion.zsh \
        /usr/local/opt/fzf/shell/completion.zsh \
        ~/.fzf/shell/completion.zsh \
        /opt/homebrew/opt/fzf/shell/completion.zsh; do
        if [ -f "$fzf_completion" ]; then
            source "$fzf_completion"
            break
        fi
    done
fi

# Custom key bindings for fzf functions

# Key bindings (only in interactive shells)
if [[ $- == *i* ]]; then

# ALT-F to open file finder (fzf alias)
if [ -n "$BASH_VERSION" ]; then
    bind -x '"\ef": fzf_file'
elif [ -n "$ZSH_VERSION" ]; then
    _fzf_file_widget() {
        fzf_file
        zle reset-prompt
    }
    zle -N _fzf_file_widget
    bindkey '\ef' _fzf_file_widget
fi

# ALT-D to open directory finder and cd (fzcd alias)
if [ -n "$BASH_VERSION" ]; then
    bind -x '"\ed": fzf_cd'
elif [ -n "$ZSH_VERSION" ]; then
    _fzf_cd_widget() {
        fzf_cd
        zle reset-prompt
    }
    zle -N _fzf_cd_widget
    bindkey '\ed' _fzf_cd_widget
fi

# CTRL-G to open git branch selector (or ALT-G) - fzgbc alias
if [ -n "$BASH_VERSION" ]; then
    bind -x '"\C-g": fzf_git_branch_checkout'
    bind -x '"\eg": fzf_git_branch_checkout'
elif [ -n "$ZSH_VERSION" ]; then
    _fzf_git_branch_widget() {
        fzf_git_branch_checkout
        zle reset-prompt
    }
    zle -N _fzf_git_branch_widget
    bindkey '^g' _fzf_git_branch_widget
    bindkey '\eg' _fzf_git_branch_widget
fi

# CTRL-P to open project selector (or ALT-P) - fzp alias
if [ -n "$BASH_VERSION" ]; then
    bind -x '"\C-p": fzf_project'
    bind -x '"\ep": fzf_project'
elif [ -n "$ZSH_VERSION" ]; then
    _fzf_project_widget() {
        fzf_project
        zle reset-prompt
    }
    zle -N _fzf_project_widget
    bindkey '^p' _fzf_project_widget
    bindkey '\ep' _fzf_project_widget
fi

# ALT-K to open process killer (fzk alias)
if [ -n "$BASH_VERSION" ]; then
    bind -x '"\ek": fzf_kill'
elif [ -n "$ZSH_VERSION" ]; then
    _fzf_kill_widget() {
        fzf_kill
        zle reset-prompt
    }
    zle -N _fzf_kill_widget
    bindkey '\ek' _fzf_kill_widget
fi

fi  # End interactive shell check

# Additional fzf-powered commands

# Use fzf for cd with ** trigger (if not already set by fzf installation)
if [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ]; then
    # This allows typing "cd **<TAB>" to trigger fzf directory search
    _fzf_compgen_path() {
        if command -v fd &> /dev/null; then
            fd --hidden --follow --exclude ".git" . "$1"
        else
            find "$1" -type f 2>/dev/null
        fi
    }

    _fzf_compgen_dir() {
        if command -v fd &> /dev/null; then
            fd --type d --hidden --follow --exclude ".git" . "$1"
        else
            find "$1" -type d 2>/dev/null
        fi
    }
fi

# fzf-tmux integration (if tmux is available)
if command -v tmux &> /dev/null && [ -n "$TMUX" ]; then
    export FZF_TMUX=1
    export FZF_TMUX_OPTS="-p 80%,60%"
fi

# Git-specific FZF functions

# Interactive VS Code opener (file picker if no args)
vs() {
    if [ $# -eq 0 ]; then
        local file
        file=$(fzf --preview 'bat --color=always --style=numbers {} 2>/dev/null || cat {}')
        [ -n "$file" ] && code -r "$file"
    else
        code -r "$@"
    fi
}

# Git files picker (modified, cached, untracked)
fzf_git_files() {
    {
        git ls-files -m
        git diff --cached --name-only
        git ls-files --others --exclude-standard
    } | sort -u | fzf --multi --preview 'git diff --cached --color=always -- {} 2>/dev/null || git diff --color=always -- {} 2>/dev/null || bat --color=always {} 2>/dev/null || cat {}'
}

# Interactive git diff file picker (supports --cached flag for staged changes)
fzf_git_diff() {
    local cached_flag=""
    local header="[diff:unstaged changes]"
    
    # Check if --cached flag is passed
    if [[ "$1" == "--cached" ]]; then
        cached_flag="--cached"
        header="[diff:staged changes]"
    fi
    
    git diff --name-only $cached_flag | fzf --multi --preview "git diff $cached_flag --color=always -- {}" --header="$header"
}

# Interactive git add (pick modified files to stage)
fzf_git_add() {
    local files
    files=$(git ls-files -m | fzf --multi --preview 'git diff --color=always -- {}')
    [ -n "$files" ] && echo "$files" | xargs git add
}

# Interactive git reset (unstage) for multiple files with preview
fzf_git_reset_staged() {
    if ! command -v git &> /dev/null; then
        echo "git is required for greset"
        return 1
    fi

    # List staged files (i.e., in index)
    local files selected
    files=$(git diff --name-only --cached)
    if [ -z "$files" ]; then
        echo "No staged files to reset."
        return 1
    fi

    selected=$(echo "$files" | fzf --multi --ansi --preview 'git --no-pager diff --cached --color=always -- {1}' --preview-window=right:60%:wrap --header='[unstage:select files to reset]')
    if [ -z "$selected" ]; then
        return 1
    fi

    # Run git reset HEAD -- <file> for each selected file
    echo "$selected" | while IFS= read -r file; do
        [ -z "$file" ] && continue
        git reset HEAD -- "$file" && echo "Unstaged: $file"
    done
}

# Additional FZF-enhanced functions

# Interactive file finder with preview
fzf_file() {
    local file
    file=$(fd --type f --hidden --exclude .git 2>/dev/null | fzf --preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || cat {}') && ${EDITOR:-vim} "$file"
}

# Interactive directory finder and cd
fzf_cd() {
    local dir
    # Common directories to exclude from results
    local -a _excludes
    _excludes=(--exclude .git --exclude node_modules --exclude deps --exclude vendor)

    if command -v fd &> /dev/null; then
        dir=$(fd --type d --hidden "${_excludes[@]}" . 2>/dev/null | fzf --preview 'ls -la {}')
    else
        dir=$(find . \( -path '*/.git' -o -path '*/node_modules' -o -path '*/deps' -o -path '*/vendor' \) -prune -o -type d -print 2>/dev/null | sed 's|^\./||' | fzf --preview 'ls -la {}')
    fi

    [ -n "$dir" ] && cd "$dir" || return 1
}

# Interactive process killer
fzf_kill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m --header='[kill:process]' | awk '{print $2}')
    if [ -n "$pid" ]; then
        echo "$pid" | xargs kill -"${1:-9}"
    fi
}

# Interactive git branch checkout
fzf_git_branch_checkout() {
    local branch
    branch=$(git branch --all | grep -v HEAD | sed 's/^..//' | sed 's/remotes\/origin\///' | sort -u | fzf --header='[checkout:branch]')
    if [ -n "$branch" ]; then
        git checkout "$branch"
    fi
}

# Interactive git log browser
fzf_git_log() {
    git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index \
        --preview 'echo {} | grep -o "[a-f0-9]\{7\}" | head -1 | xargs git show --color=always' \
        --bind "enter:execute:echo {} | grep -o '[a-f0-9]\{7\}' | head -1 | xargs git show | less -R"
}

# Interactive git branch delete (local only)
fzf_git_branch_delete() {
    local branches branch confirm skip_confirm=0
    # Parse options: support -y or --yes to skip confirmations
    while [ "$#" -gt 0 ]; do
        case "$1" in
            -y|--yes)
                skip_confirm=1
                shift
                ;;
            --)
                shift
                break
                ;;
            -*)
                # unknown option, pass through
                break
                ;;
            *)
                break
                ;;
        esac
    done

    branches=$(git branch | grep -v HEAD | sed 's/^..//' | sort -u | fzf --multi --header='[delete:local branch]')
    if [ -z "$branches" ]; then
        return 1
    fi
    # Loop over each selected branch
    while IFS= read -r branch; do
        [ -z "$branch" ] && continue
        echo
        echo "Review branch: $branch"
        git log -1 --pretty=format:"%C(auto)%h %C(bold blue)%an %C(reset)%ar %C(bold yellow)%s" "$branch"
        echo
        if [ "$skip_confirm" -eq 1 ]; then
            git branch -D "$branch"
        else
            # Cross-shell compatible prompt - using printf and read from stdin
            printf "Delete local branch '%s'? [y/N]: " "$branch"
            read confirm </dev/tty
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                git branch -D "$branch"
            else
                echo "Aborted deletion of '$branch'."
            fi
        fi
    done <<< "$branches"
}

# Interactive command history search
fzf_history() {
    local cmd
    cmd=$(history | fzf --tac --no-sort | sed 's/^ *[0-9]* *//')
    if [ -n "$cmd" ]; then
        echo "$cmd"
        eval "$cmd"
    fi
}

# Interactive environment variable viewer
fzf_env() {
    env | sort | fzf --preview 'echo {}' --preview-window=wrap
}

# Interactive alias viewer
fzf_alias() {
    alias | fzf --preview 'echo {}' --preview-window=wrap
}

# Find and cd to a project directory
# Supports multiple directories in PROJECTS_DIR separated by colons (like PATH)
fzf_project() {
    local projects_dir="${PROJECTS_DIR:-$HOME/projects}"
    local dir
    local all_projects=""
    
    # Split PROJECTS_DIR by colon and process each directory
    IFS=':' read -ra dirs <<< "$projects_dir"
    for dir in "${dirs[@]}"; do
        # Expand ~ if present
        dir="${dir/#\~/$HOME}"
        
        if [ -d "$dir" ]; then
            # Append projects from this directory
            if [ -n "$all_projects" ]; then
                all_projects="$all_projects"$'\n'
            fi
            all_projects="$all_projects$(fd --type d --max-depth 1 . "$dir" 2>/dev/null)"
        fi
    done
    
    if [ -n "$all_projects" ]; then
        local project
        project=$(echo "$all_projects" | fzf --preview 'ls -la {}')
        if [ -n "$project" ]; then
            cd "$project" || return 1
            echo "Changed directory to: $project"
        fi
    else
        echo "No valid directories found in PROJECTS_DIR: $projects_dir"
        return 1
    fi
}

# Interactive docker container selection
fzf_docker() {
    local container
    container=$(docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}" | fzf --header-lines=1 | awk '{print $1}')
    if [ -n "$container" ]; then
        docker exec -it "$container" bash || docker exec -it "$container" sh
    fi
}

# Search file contents and open in editor
fzf_rg() {
    if command -v rg &> /dev/null; then
        local file line
        read -r file line < <(
            rg --color=always --line-number --no-heading --smart-case "$@" |
            fzf --ansi --delimiter : \
                --preview 'bat --color=always --highlight-line {2} {1}' \
                --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' |
            awk -F: '{print $1, $2}'
        )
        if [ -n "$file" ]; then
            ${EDITOR:-vim} "$file" "+${line:-1}"
        fi
    else
        echo "ripgrep (rg) is required for this function"
        return 1
    fi
}

# ============================================================================
# Aliases - All FZF-powered aliases
# ============================================================================

# FZF-powered aliases (all prefixed with 'fz' for consistency)
alias fzco='git switch $(git branch | sed '\''s/^..//'\'\'' | fzf)'  # Git checkout branch
alias fzcd='fzf_cd'           # Quick cd with preview
alias fzd='fzf_docker'        # Interactive docker container shell
alias fzf-alias='fzf_alias'   # Browse and search shell aliases
alias fzf-env='fzf_env'       # Browse and search environment variables
alias fzff='fzf_file'         # Quick file search and edit
alias fzga='fzf_git_add'          # Interactive git add (stage files)
alias fzgbc='fzf_git_branch_checkout'            # Interactive git branch checkout
alias fzgbd='fzf_git_branch_delete'              # Interactive git branch delete
alias fzgd='fzf_git_diff'     # Interactive git diff (unstaged)
alias fzgdc='fzf_git_diff --cached'              # Interactive git diff (staged)
alias fzgl='fzf_git_log'      # Interactive git log browser
alias fzgr='fzf_git_reset_staged'                # Interactive git reset (unstage files)
alias fzh='fzf_history'       # Interactive history search
alias fzk='fzf_kill'          # Interactive process killer
alias fzp='fzf_project'       # Quick project switcher
alias fzrg='fzf_rg'           # Search in files and edit

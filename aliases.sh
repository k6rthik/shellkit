#!/usr/bin/env bash
# Command Aliases
# Add your custom command aliases here

# Navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'
alias pg='cd'

# Workspace navigation (with validation)
if [ -d "$HOME/ws" ]; then
    alias ws='cd ~/ws'
fi

# List directory contents
if command -v eza &> /dev/null; then
    alias ls='eza --color=always --group-directories-first'
    alias ll='eza -alF --color=always --group-directories-first --icons'
    alias la='eza -a --color=always --group-directories-first'
    alias l='eza -F --color=always --group-directories-first'
    alias lt='eza -aT --color=always --group-directories-first --icons' # tree view
    alias l.='eza -a | grep "^\."' # show only hidden files
else
    alias ls='ls --color=auto'
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
fi

# Safety nets - prompt before overwriting files
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Grep with color (use rg if available, otherwise grep)
if command -v rg &> /dev/null; then
    alias grep='rg'
    alias ag='rg'
else
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Cat and less with bat (if available)
if command -v bat &> /dev/null; then
    alias cat='bat --paging=never'
    alias less='bat'
fi

# Git aliases (common shortcuts)
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# Docker aliases
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlogs='docker logs -f'

# System monitoring
alias ports='netstat -tulanp'
alias psmem='ps auxf | sort -nr -k 4 | head -10'
alias pscpu='ps auxf | sort -nr -k 3 | head -10'

# Networking
alias myip='curl -s http://ipecho.net/plain; echo'
alias localip="ip addr show | grep 'inet ' | grep -v 127.0.0.1 | awk '{print \$2}' | cut -d/ -f1"

# File operations
alias mkdir='mkdir -pv'
alias wget='wget -c'

# SSH tunneling
alias lhr='ssh -o ServerAliveInterval=60 -R 80:localhost:4005 localhost.run'

# Disk usage
alias df='df -h'
alias du='du -h'
alias dush='du -sh'

# Process management
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'

# Date and time
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias nowdate='date +"%Y-%m-%d"'

# Make and change to directory
alias mkcd='_mkcd'

# Quick edits
alias zshrc='${EDITOR:-vim} ~/.zshrc'
alias bashrc='${EDITOR:-vim} ~/.bashrc'
alias vimrc='${EDITOR:-vim} ~/.vimrc'

# Reload shell
alias reload='source ~/.${SHELLKIT_SHELL}rc'

# Clear screen
alias clr='clear'
alias clrs='clear && ls'

# Package management (conditional based on OS)
if command -v apt-get &> /dev/null; then
    alias update='sudo apt-get update && sudo apt-get upgrade'
    alias install='sudo apt-get install'
elif command -v yum &> /dev/null; then
    alias update='sudo yum update'
    alias install='sudo yum install'
elif command -v brew &> /dev/null; then
    alias update='brew update && brew upgrade'
    alias install='brew install'
fi

# Add your custom aliases below this line
# ============================================

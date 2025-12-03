#!/usr/bin/env bash
# Custom Shell Functions
# Add your custom bash/zsh functions here

# Create directory and cd into it
_mkcd() {
    if [ -z "$1" ]; then
        echo "Usage: mkcd <directory>"
        return 1
    fi
    mkdir -p "$1" && cd "$1" || return 1
}

# Compress files/directories into various archive formats
compress() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: compress <file|directory> <output.[tar.gz|tar.bz2|tar.xz|zip|7z]>"
        echo "Examples:"
        echo "  compress mydir archive.tar.gz"
        echo "  compress myfile.txt backup.zip"
        return 1
    fi
    
    local input="$1"
    local output="$2"
    
    if [ ! -e "$input" ]; then
        echo "Error: '$input' does not exist"
        return 1
    fi
    
    case "$output" in
        *.tar.gz|*.tgz)
            tar czf "$output" "$input"
            echo "Created: $output"
            ;;
        *.tar.bz2|*.tbz2)
            tar cjf "$output" "$input"
            echo "Created: $output"
            ;;
        *.tar.xz)
            tar cJf "$output" "$input"
            echo "Created: $output"
            ;;
        *.zip)
            zip -r "$output" "$input"
            echo "Created: $output"
            ;;
        *.7z)
            7z a "$output" "$input"
            echo "Created: $output"
            ;;
        *)
            echo "Error: Unsupported archive format"
            echo "Supported: .tar.gz, .tar.bz2, .tar.xz, .zip, .7z"
            return 1
            ;;
    esac
}

# Extract various archive types
extract() {
    if [ -z "$1" ]; then
        echo "Usage: extract <file>"
        return 1
    fi
    
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.tar.xz)    tar xJf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Find file by name in current directory tree
ff() {
    if [ -z "$1" ]; then
        echo "Usage: ff <filename>"
        return 1
    fi
    if command -v fd &> /dev/null; then
        fd --type f "$1"
    else
        find . -type f -iname "*$1*" 2>/dev/null
    fi
}

# Find directory by name in current directory tree
fdir() {
    if [ -z "$1" ]; then
        echo "Usage: fdir <dirname>"
        return 1
    fi
    if command -v fd &> /dev/null; then
        fd --type d "$1"
    else
        find . -type d -iname "*$1*" 2>/dev/null
    fi
}

# Create a backup of a file
backup() {
    if [ -z "$1" ]; then
        echo "Usage: backup <file>"
        return 1
    fi
    cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
}

# Make a directory and cd into it, handling sudo if needed
mksudo() {
    if [ -z "$1" ]; then
        echo "Usage: mksudo <directory>"
        return 1
    fi
    sudo mkdir -p "$1" && cd "$1" || return 1
}

# Show the PATH variable in a readable format
showpath() {
    echo "$PATH" | tr ':' '\n' | nl
}

# Get the size of a directory
dirsize() {
    du -sh "${1:-.}" 2>/dev/null
}

# Find process by name
psgrep() {
    if [ -z "$1" ]; then
        echo "Usage: psgrep <process-name>"
        return 1
    fi
    ps aux | grep -v grep | grep -i -e VSZ -e "$1"
}

# Kill process by name
killps() {
    if [ -z "$1" ]; then
        echo "Usage: killps <process-name>"
        return 1
    fi
    local pid
    pid=$(ps aux | grep -v grep | grep "$1" | awk '{print $2}')
    if [ -n "$pid" ]; then
        echo "Killing process(es): $pid"
        kill -9 "$pid"
    else
        echo "No process found matching: $1"
    fi
}

# Create a tar.gz archive
targz() {
    if [ -z "$1" ]; then
        echo "Usage: targz <file-or-directory>"
        return 1
    fi
    tar -czf "${1%/}.tar.gz" "${1%/}"
}

# HTTP server in current directory
serve() {
    local port="${1:-8000}"
    if command -v python3 &> /dev/null; then
        echo "Starting HTTP server on port $port..."
        python3 -m http.server "$port"
    elif command -v python &> /dev/null; then
        echo "Starting HTTP server on port $port..."
        python -m SimpleHTTPServer "$port"
    else
        echo "Python is not installed"
        return 1
    fi
}

# Weather in terminal
weather() {
    local location="${1:-}"
    curl -s "wttr.in/${location}?format=3"
}

# Generate a random string
randstr() {
    local length="${1:-32}"
    LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c "$length"
    echo
}

# Quick note taking
note() {
    local notes_file="${NOTES_FILE:-$HOME/notes.txt}"
    if [ -z "$1" ]; then
        # Display notes if no argument
        if [ -f "$notes_file" ]; then
            cat "$notes_file"
        else
            echo "No notes found. Use 'note <text>' to add a note."
        fi
    else
        # Append note with timestamp
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$notes_file"
        echo "Note added to $notes_file"
    fi
}

# Search command history
hist() {
    if [ -z "$1" ]; then
        history
    else
        history | grep -i "$1"
    fi
}

# Git clone and cd into directory
gcl() {
    if [ -z "$1" ]; then
        echo "Usage: gcl <repository-url>"
        return 1
    fi
    git clone "$1" && cd "$(basename "$1" .git)" || return 1
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Add your custom functions below this line
# ============================================

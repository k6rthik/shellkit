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

# Print full/absolute path - extends pwd to work with file/directory arguments
# Usage: fullpath [file|directory]
#   No args: prints current working directory (same as pwd)
#   With arg: prints absolute path of the given file or directory
fullpath() {
    if [ -z "$1" ]; then
        # No argument - behave like pwd
        pwd
    else
        # Argument provided - get absolute path
        local target="$1"
        
        if [ ! -e "$target" ]; then
            echo "Error: '$target' does not exist" >&2
            return 1
        fi
        
        if [ -d "$target" ]; then
            # It's a directory - cd into it and get pwd
            (cd "$target" && pwd)
        else
            # It's a file - get directory path and append filename
            local dir
            local base
            dir=$(dirname "$target")
            base=$(basename "$target")
            echo "$(cd "$dir" && pwd)/$base"
        fi
    fi
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

# Safe shell reload helper (replaces the old alias implementation)
# - Prevents recursive reloads that can terminate VS Code terminals
# - Emits optional timing info when SHELLKIT_VERBOSE=1
# - Works for both bash and zsh by inspecting SHELLKIT_SHELL/BASH_VERSION/ZSH_VERSION
reload() {
    local shell_name rcfile depth start_ts end_ts duration status

    shell_name="${SHELLKIT_SHELL:-}"
    if [ -z "$shell_name" ]; then
        if [ -n "$BASH_VERSION" ]; then
            shell_name="bash"
        elif [ -n "$ZSH_VERSION" ]; then
            shell_name="zsh"
        fi
    fi
    shell_name="${shell_name:-bash}"
    rcfile="$HOME/.${shell_name}rc"

    if [ ! -f "$rcfile" ]; then
        echo "reload: unable to find $rcfile" >&2
        return 1
    fi

    depth="${SHELLKIT_RELOAD_DEPTH:-0}"
    if [ "$depth" -ge 1 ]; then
        echo "reload: another reload is already running (depth=$depth)" >&2
        return 1
    fi

    if command -v date &> /dev/null; then
        start_ts=$(date +%s%3N 2>/dev/null || date +%s)
    fi

    export SHELLKIT_RELOAD_DEPTH=$((depth + 1))

    if [ "${SHELLKIT_VERBOSE:-0}" = "1" ]; then
        echo "↻ Reloading shell configuration from $rcfile"
    fi

    # shellcheck disable=SC1090
    source "$rcfile"
    status=$?

    if [ "$depth" -eq 0 ]; then
        unset SHELLKIT_RELOAD_DEPTH
    else
        export SHELLKIT_RELOAD_DEPTH="$depth"
    fi

    if [ "${SHELLKIT_VERBOSE:-0}" = "1" ] && [ -n "$start_ts" ]; then
        end_ts=$(date +%s%3N 2>/dev/null || date +%s)
        duration=$((end_ts - start_ts))
        echo "✓ Reload finished in ${duration}ms (status: $status)"
    fi

    return "$status"
}

# Add your custom functions below this line
# ============================================

# Find and replace text in a file
# Usage: rep <find> <replace> <filename>
rep() {
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
        echo "Usage: rep <find> <replace> <filename>" >&2
        echo "Example: rep 'old_text' 'new_text' myfile.txt" >&2
        return 1
    fi
    
    local find="$1"
    local replace="$2"
    local file="$3"
    
    if [ ! -f "$file" ]; then
        echo "Error: File '$file' not found" >&2
        return 1
    fi
    
    # Check if file is writable
    if [ ! -w "$file" ]; then
        echo "Error: File '$file' is not writable" >&2
        return 1
    fi
    
    # Count occurrences before replacement
    local count_before
    count_before=$(grep -o -F "$find" "$file" 2>/dev/null | wc -l | tr -d ' ')
    
    # Escape forward slashes in patterns for sed
    local find_escaped="${find//\//\\/}"
    local replace_escaped="${replace//\//\\/}"
    
    # OS-specific sed syntax (macOS requires empty string after -i)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/$find_escaped/$replace_escaped/g" "$file"
    else
        sed -i "s/$find_escaped/$replace_escaped/g" "$file"
    fi
    
    if [ $? -eq 0 ]; then
        if [ "$count_before" -gt 0 ]; then
            echo "✓ Replaced $count_before occurrence(s) of '$find' with '$replace' in $file"
        else
            echo "⚠ No matches found for '$find' in $file"
        fi
    else
        echo "Error: Replacement failed" >&2
        return 1
    fi
}

# Manage SOCKS proxy via SSH and environment variables
# Usage: proxy [start <host>|status|stop|set-env|unset-env]
# - proxy start <host>   : Start SOCKS proxy on localhost:1080
# - proxy status         : Check if SOCKS proxy is running
# - proxy stop           : Stop the SOCKS proxy
# - proxy set-env        : Set HTTP proxy vars (detects privoxy on 8118 or SOCKS on 1080)
# - proxy unset-env      : Unset HTTP proxy environment variables
proxy() {
    if [ -z "$1" ]; then
        echo "Usage: proxy [start <host>|status|stop|set-env|unset-env]"
        echo "  proxy start <host>  - Start SOCKS proxy to <host> on localhost:1080"
        echo "  proxy status        - Check if SOCKS proxy is running"
        echo "  proxy stop          - Stop the SOCKS proxy"
        echo "  proxy set-env       - Set HTTP_PROXY/HTTPS_PROXY (detects privoxy or SOCKS)"
        echo "  proxy unset-env     - Unset HTTP proxy environment variables"
        return 1
    fi

    local cmd="$1"

    case "$cmd" in
        start)
            local host="$2"
            # Use SHELLKIT_PROXY_HOSTNAME if host not provided as argument
            if [ -z "$host" ]; then
                host="${SHELLKIT_PROXY_HOSTNAME}"
            fi
            if [ -z "$host" ]; then
                echo "Usage: proxy start <host|alias>"
                echo "  Or set SHELLKIT_PROXY_HOSTNAME environment variable"
                return 1
            fi
            echo "Starting SOCKS proxy to $host on localhost:1080..."
            ssh -D 1080 -f -C -q -N "$host"

            if [ $? -eq 0 ]; then
                echo "✓ Proxy started. Use localhost:1080 as SOCKS5 proxy."
            else
                echo "Error: Failed to start proxy" >&2
                return 1
            fi
            ;;

        status)
            local proxy_pid
            proxy_pid=$(pgrep -f 'ssh -D 1080' | head -1)

            if [ -n "$proxy_pid" ]; then
                echo "✓ Proxy is running (PID: $proxy_pid)"
                # Try to show the remote host
                local remote_host
                remote_host=$(ps -p "$proxy_pid" -o args= 2>/dev/null | rg -o '[a-zA-Z0-9._@-]+$' | head -1)
                if [ -n "$remote_host" ]; then
                    echo "  Connected to: $remote_host"
                fi
                return 0
            else
                echo "✗ Proxy is not running"
                return 1
            fi
            ;;

        stop)
            if pgrep -f 'ssh -D 1080' > /dev/null; then
                pkill -f 'ssh -D 1080'
                echo "✓ Proxy stopped"
            else
                echo "Proxy is not running"
                return 1
            fi
            ;;

        set-env)
            # Check if privoxy is listening on 8118
            local proxy_url
            if (echo > /dev/tcp/127.0.0.1/8118) &>/dev/null 2>&1; then
                proxy_url="http://127.0.0.1:8118"
                echo "✓ Using Privoxy on :8118"
            # Check if SOCKS proxy is listening on 1080
            elif (echo > /dev/tcp/127.0.0.1/1080) &>/dev/null 2>&1; then
                proxy_url="socks5://127.0.0.1:1080"
                echo "✓ Using SOCKS proxy on :1080"
            else
                echo "⚠ No proxy detected on :8118 (privoxy) or :1080 (SOCKS)" >&2
                return 1
            fi

            # Export proxy environment variables
            export HTTP_PROXY="$proxy_url"
            export HTTPS_PROXY="$proxy_url"
            export ALL_PROXY="$proxy_url"
            export NO_PROXY="localhost,127.0.0.1,::1"

            # Also export lowercase variants for compatibility
            export http_proxy="$proxy_url"
            export https_proxy="$proxy_url"
            export all_proxy="$proxy_url"
            export no_proxy="localhost,127.0.0.1,::1"

            echo "✓ Proxy environment variables set:"
            echo "  HTTP_PROXY=$proxy_url"
            echo "  HTTPS_PROXY=$proxy_url"
            echo "  ALL_PROXY=$proxy_url"
            echo "  NO_PROXY=localhost,127.0.0.1,::1"
            ;;

        unset-env)
            # Unset all proxy-related environment variables
            unset HTTP_PROXY HTTPS_PROXY ALL_PROXY NO_PROXY
            unset http_proxy https_proxy all_proxy no_proxy
            echo "✓ Proxy environment variables unset"
            ;;

        *)
            echo "Unknown command: $cmd" >&2
            echo "Usage: proxy [start <host>|status|stop|set-env|unset-env]"
            return 1
            ;;
    esac
}

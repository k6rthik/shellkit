#!/usr/bin/env bash
# Install core enhanced tools for shellkit
# Supports Linux (Debian/Ubuntu + Homebrew) and macOS
# Provides option for sudo or user-local installation
#
# Usage:
#   ./install_tools.sh           # Interactive mode
#   ./install_tools.sh --dry-run # Dry-run mode (show commands without executing)
#   ./install_tools.sh -n        # Short form of dry-run

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Installation directory for non-sudo installs
LOCAL_BIN="${SHELLKIT_DIR:-$HOME/.shellkit}/bin"

# Dry-run mode flag
DRY_RUN="false"

# Command-line options for non-interactive mode
# OPT_MODE: "apt" (system apt-get), "brew" (homebrew), "user" (no sudo)
OPT_MODE=""
OPT_ALL=""
OPT_TOOLS=""

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -n|--dry-run)
            DRY_RUN="true"
            shift
            ;;
        --apt)
            OPT_MODE="apt"
            shift
            ;;
        --brew)
            OPT_MODE="brew"
            shift
            ;;
        -u|--user)
            OPT_MODE="user"
            shift
            ;;
        -a|--all)
            OPT_ALL="true"
            shift
            ;;
        -t|--tools)
            shift
            OPT_TOOLS="$1"
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -n, --dry-run      Show what would be done without executing"
            echo "  --apt              Install system-wide using apt-get (requires sudo)"
            echo "  --brew             Install system-wide using Homebrew"
            echo "  -u, --user         Install to ~/.shellkit/bin without sudo"
            echo "  -a, --all          Install all core tools"
            echo "  -t, --tools LIST   Install specific tools (comma-separated)"
            echo "                     Core: fzf,fd,rg,bat,eza,zoxide,starship"
            echo "                     Extra: qrencode,7z,wslview"
            echo "  -h, --help         Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0 --apt --all               # Install all tools via apt-get"
            echo "  $0 --brew --all              # Install all tools via Homebrew"
            echo "  $0 --user --all              # Install all tools to ~/.shellkit/bin"
            echo "  $0 --apt --tools fzf,rg      # Install specific tools with apt"
            echo "  $0 -n --brew -a              # Dry-run: show what would be installed"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Execute or print command based on dry-run mode
run_cmd() {
    if [ "$DRY_RUN" = "true" ]; then
        echo -e "  ${MAGENTA}[DRY-RUN]${NC} $*"
    else
        "$@"
    fi
}

# Execute or print sudo command based on dry-run mode
run_sudo() {
    if [ "$DRY_RUN" = "true" ]; then
        echo -e "  ${MAGENTA}[DRY-RUN]${NC} sudo $*"
    else
        sudo "$@"
    fi
}

# Detect OS and distribution
detect_system() {
    OS=""
    DISTRO=""
    ARCH=""
    
    # Detect OS
    case "$(uname -s)" in
        Linux*)  OS="linux" ;;
        Darwin*) OS="macos" ;;
        *)       OS="unknown" ;;
    esac
    
    # Detect architecture
    case "$(uname -m)" in
        x86_64)  ARCH="x86_64" ;;
        amd64)   ARCH="x86_64" ;;
        aarch64) ARCH="aarch64" ;;
        arm64)   ARCH="aarch64" ;;
        armv7l)  ARCH="armv7" ;;
        *)       ARCH="unknown" ;;
    esac
    
    # Detect Linux distribution
    if [ "$OS" = "linux" ]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            DISTRO="$ID"
        elif [ -f /etc/debian_version ]; then
            DISTRO="debian"
        elif [ -f /etc/fedora-release ]; then
            DISTRO="fedora"
        elif [ -f /etc/arch-release ]; then
            DISTRO="arch"
        else
            DISTRO="unknown"
        fi
    fi
    
    echo -e "${CYAN}Detected System:${NC}"
    echo -e "  OS:           ${GREEN}$OS${NC}"
    [ -n "$DISTRO" ] && echo -e "  Distribution: ${GREEN}$DISTRO${NC}"
    echo -e "  Architecture: ${GREEN}$ARCH${NC}"
    echo
}

# Check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Create local bin directory if needed
setup_local_bin() {
    if [ ! -d "$LOCAL_BIN" ]; then
        echo -e "${YELLOW}Creating local bin directory: $LOCAL_BIN${NC}"
        run_cmd mkdir -p "$LOCAL_BIN"
    fi
    
    # Check if LOCAL_BIN is in PATH
    if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
        echo -e "${YELLOW}Note: Add $LOCAL_BIN to your PATH${NC}"
        echo -e "      This should already be handled by shellkit's paths.sh"
    fi
}

# Download file with curl or wget
download() {
    local url="$1"
    local output="$2"
    
    if [ "$DRY_RUN" = "true" ]; then
        echo -e "  ${MAGENTA}[DRY-RUN]${NC} Download: $url -> $output"
        return 0
    fi
    
    if command_exists curl; then
        curl -fsSL "$url" -o "$output"
    elif command_exists wget; then
        wget -q "$url" -O "$output"
    else
        echo -e "${RED}Error: curl or wget required for downloads${NC}"
        return 1
    fi
}

# Get latest release version from GitHub
get_github_latest() {
    local repo="$1"
    curl -fsSL "https://api.github.com/repos/$repo/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

# Install Homebrew
install_homebrew() {
    echo -e "${BLUE}Installing Homebrew...${NC}"
    if [ "$DRY_RUN" = "true" ]; then
        echo -e "  ${MAGENTA}[DRY-RUN]${NC} /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    else
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add brew to PATH for current session
        if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        elif [ -f "$HOME/.linuxbrew/bin/brew" ]; then
            eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
        fi
    fi
    echo -e "${GREEN}✓ Homebrew installed${NC}"
    echo
}

# Prompt to install Homebrew if not found
ensure_homebrew() {
    if command_exists brew; then
        return 0
    fi
    
    echo -e "${YELLOW}Homebrew is not installed.${NC}"
    read -rp "Would you like to install Homebrew? [y/N]: " install_brew
    
    case "$install_brew" in
        [yY]|[yY][eE][sS])
            install_homebrew
            ;;
        *)
            echo -e "${RED}Cannot proceed without Homebrew for this installation mode.${NC}"
            exit 1
            ;;
    esac
}

# ============================================
# Generic Installation Functions
# ============================================

# Install tool via brew (works on macOS and Linux with Homebrew)
install_via_brew() {
    local brew_pkg="$1"
    run_cmd brew install "$brew_pkg"
}

# Install tool via apt (Debian-based systems)
install_via_apt() {
    local apt_pkg="$1"
    local symlink_from="$2"  # Optional: source binary name if different
    local symlink_to="$3"    # Optional: target binary name
    
    run_sudo apt-get update && run_sudo apt-get install -y "$apt_pkg"
    
    # Handle packages that install with different names (e.g., fd-find -> fd)
    if [ -n "$symlink_from" ] && [ -n "$symlink_to" ]; then
        if [ "$DRY_RUN" = "true" ]; then
            echo -e "  ${MAGENTA}[DRY-RUN]${NC} sudo ln -sf \$(which $symlink_from) /usr/local/bin/$symlink_to"
        elif command_exists "$symlink_from" && ! command_exists "$symlink_to"; then
            sudo ln -sf "$(which "$symlink_from")" "/usr/local/bin/$symlink_to"
        fi
    fi
}

# Install tool from GitHub release tarball
install_from_github() {
    local tool_name="$1"
    local repo="$2"
    local binary_name="$3"
    local filename_pattern="$4"  # Pattern with {version}, {os}, {arch} placeholders
    local extract_path="$5"      # Optional: subdirectory pattern in archive
    
    local version
    version=$(get_github_latest "$repo")
    version="${version#v}"  # Remove 'v' prefix if present
    
    # Determine OS string for filename
    local os_str arch_str
    case "$OS" in
        linux) os_str="linux" ;;
        macos) os_str="apple-darwin" ;;
    esac
    case "$ARCH" in
        x86_64)  arch_str="x86_64" ;;
        aarch64) arch_str="aarch64" ;;
    esac
    
    # Build filename from pattern
    local filename="$filename_pattern"
    filename="${filename//\{version\}/$version}"
    filename="${filename//\{os\}/$os_str}"
    filename="${filename//\{arch\}/$arch_str}"
    
    local url="https://github.com/$repo/releases/download/v${version}/${filename}"
    
    if [ "$DRY_RUN" = "true" ]; then
        echo -e "  ${MAGENTA}[DRY-RUN]${NC} Download: $url"
        echo -e "  ${MAGENTA}[DRY-RUN]${NC} Extract and copy $binary_name to $LOCAL_BIN/"
    else
        local tmpdir
        tmpdir=$(mktemp -d)
        
        echo -e "  Downloading $tool_name v${version}..."
        download "$url" "$tmpdir/$filename"
        tar -xzf "$tmpdir/$filename" -C "$tmpdir"
        
        # Find and copy binary
        if [ -n "$extract_path" ]; then
            extract_path="${extract_path//\{version\}/$version}"
            cp "$tmpdir"/$extract_path/"$binary_name" "$LOCAL_BIN/"
        else
            cp "$tmpdir/$binary_name" "$LOCAL_BIN/"
        fi
        
        chmod +x "$LOCAL_BIN/$binary_name"
        rm -rf "$tmpdir"
    fi
}

# Generic tool installer - handles brew, apt, and GitHub release installations
# Arguments:
#   $1 - tool name (for display)
#   $2 - install_mode: "apt", "brew", or "user"
#   $3 - brew package name
#   $4 - apt package name (empty if not available via apt)
#   $5 - apt symlink source (optional, for packages like fd-find)
#   $6 - apt symlink target (optional)
#   $7 - GitHub repo (owner/repo) or special installer type: "git:url", "curl:url", "none"
#   $8 - binary name
#   $9 - GitHub release filename pattern
#   $10 - extract path pattern (optional)
install_tool() {
    local tool_name="$1"
    local install_mode="$2"
    local brew_pkg="$3"
    local apt_pkg="$4"
    local apt_symlink_from="$5"
    local apt_symlink_to="$6"
    local github_repo="$7"
    local binary_name="$8"
    local filename_pattern="$9"
    local extract_path="${10}"
    
    echo -e "${BLUE}Installing $tool_name...${NC}"
    
    case "$install_mode" in
        apt)
            # Install via apt-get (Debian-based only)
            case "$DISTRO" in
                ubuntu|debian|linuxmint|pop)
                    if [ -n "$apt_pkg" ]; then
                        install_via_apt "$apt_pkg" "$apt_symlink_from" "$apt_symlink_to"
                    else
                        echo -e "${RED}$tool_name is not available via apt-get${NC}"
                        echo -e "${YELLOW}Try using --brew or --user mode instead${NC}"
                        return 1
                    fi
                    ;;
                *)
                    echo -e "${RED}apt-get is only available on Debian-based systems${NC}"
                    return 1
                    ;;
            esac
            ;;
        brew)
            # Install via Homebrew
            if [ -n "$brew_pkg" ]; then
                install_via_brew "$brew_pkg"
            else
                echo -e "${RED}$tool_name is not available via Homebrew${NC}"
                return 1
            fi
            ;;
        user)
            # Install to user directory (no sudo)
            _install_fallback "$tool_name" "$install_mode" "$github_repo" "$binary_name" "$filename_pattern" "$extract_path"
            return
            ;;
        *)
            echo -e "${RED}Unknown install mode: $install_mode${NC}"
            return 1
            ;;
    esac
    
    echo -e "${GREEN}✓ $tool_name installed${NC}"
}

# Handle fallback installation (GitHub releases, curl installers, etc.)
_install_fallback() {
    local tool_name="$1"
    local install_mode="$2"
    local github_repo="$3"
    local binary_name="$4"
    local filename_pattern="$5"
    local extract_path="$6"
    
    case "$github_repo" in
        none)
            # Extract tool identifier for the command suggestion
            local tool_id
            tool_id=$(echo "$tool_name" | sed 's/ .*//; s/(//g; s/)//g')
            echo -e "${RED}$tool_name requires package manager installation (no standalone binary available)${NC}"
            echo -e "${YELLOW}Run one of the following commands instead:${NC}"
            echo -e "  ${CYAN}./install_tools.sh --apt --tools $tool_id${NC}   # using apt-get"
            echo -e "  ${CYAN}./install_tools.sh --brew --tools $tool_id${NC}  # using Homebrew"
            return 1
            ;;
        curl:*)
            local url="${github_repo#curl:}"
            if [ "$DRY_RUN" = "true" ]; then
                echo -e "  ${MAGENTA}[DRY-RUN]${NC} curl -sS $url | sh -s -- -y"
            else
                curl -sS "$url" | sh -s -- -y
            fi
            echo -e "${GREEN}✓ $tool_name installed${NC}"
            ;;
        git:*)
            local git_url="${github_repo#git:}"
            local install_dir="$HOME/.$binary_name"
            if [ "$DRY_RUN" = "true" ]; then
                echo -e "  ${MAGENTA}[DRY-RUN]${NC} git clone $git_url $install_dir"
                echo -e "  ${MAGENTA}[DRY-RUN]${NC} $install_dir/install --bin"
                echo -e "  ${MAGENTA}[DRY-RUN]${NC} ln -sf $install_dir/bin/$binary_name $LOCAL_BIN/$binary_name"
            else
                if [ -d "$install_dir" ]; then
                    echo -e "${YELLOW}Updating existing $tool_name installation...${NC}"
                    cd "$install_dir" && git pull
                else
                    git clone --depth 1 "$git_url" "$install_dir"
                fi
                "$install_dir/install" --bin
                ln -sf "$install_dir/bin/$binary_name" "$LOCAL_BIN/$binary_name"
            fi
            echo -e "${GREEN}✓ $tool_name installed${NC}"
            ;;
        *)
            if [ -z "$github_repo" ] || [ -z "$filename_pattern" ]; then
                echo -e "${RED}$tool_name requires package manager (apt or brew) on this system${NC}"
                return 1
            fi
            echo -e "${YELLOW}Using GitHub release...${NC}"
            install_from_github "$tool_name" "$github_repo" "$binary_name" "$filename_pattern" "$extract_path"
            echo -e "${GREEN}✓ $tool_name installed${NC}"
            ;;
    esac
}

# ============================================
# Tool-Specific Installation Functions
# ============================================

# fzf - uses git clone for non-sudo install
install_fzf() {
    install_tool "fzf" "$1" \
        "fzf" \
        "fzf" "" "" \
        "git:https://github.com/junegunn/fzf.git" "fzf" \
        "" ""
}

# fd - uses generic installer
install_fd() {
    install_tool "fd" "$1" \
        "fd" \
        "fd-find" "fdfind" "fd" \
        "sharkdp/fd" "fd" \
        "fd-v{version}-{arch}-unknown-{os}-gnu.tar.gz" \
        "fd-v{version}-*"
}

# ripgrep - uses generic installer
install_rg() {
    install_tool "ripgrep" "$1" \
        "ripgrep" \
        "ripgrep" "" "" \
        "BurntSushi/ripgrep" "rg" \
        "ripgrep-{version}-{arch}-unknown-{os}-musl.tar.gz" \
        "ripgrep-{version}-*"
}

# bat - uses generic installer
install_bat() {
    install_tool "bat" "$1" \
        "bat" \
        "bat" "batcat" "bat" \
        "sharkdp/bat" "bat" \
        "bat-v{version}-{arch}-unknown-{os}-gnu.tar.gz" \
        "bat-v{version}-*"
}

# eza - uses generic installer with GitHub fallback
install_eza() {
    install_tool "eza" "$1" \
        "eza" \
        "" "" "" \
        "eza-community/eza" "eza" \
        "eza_{arch}-unknown-{os}-gnu.tar.gz" \
        ""
}

# zoxide - uses generic installer
install_zoxide() {
    install_tool "zoxide" "$1" \
        "zoxide" \
        "zoxide" "" "" \
        "ajeetdsouza/zoxide" "zoxide" \
        "zoxide-{version}-{arch}-unknown-{os}-musl.tar.gz" \
        ""
}

# starship - brew only (curl installer requires sudo)
install_starship() {
    install_tool "starship" "$1" \
        "starship" \
        "" "" "" \
        "none" "" "" ""
}

# qrencode - apt/brew only, no GitHub release
install_qrencode() {
    install_tool "qrencode" "$1" \
        "qrencode" \
        "qrencode" "" "" \
        "none" "" "" ""
}

# 7z (p7zip) - apt/brew only
install_7z() {
    install_tool "7z (p7zip)" "$1" \
        "p7zip" \
        "p7zip-full" "" "" \
        "none" "" "" ""
}

# wslview - WSL only
install_wslview() {
    # Check if running in WSL first
    if [ "$OS" != "linux" ] || ! grep -qi microsoft /proc/version 2>/dev/null; then
        echo -e "${YELLOW}wslview is only available on WSL (Windows Subsystem for Linux)${NC}"
        return 1
    fi
    
    install_tool "wslview (wslu)" "$1" \
        "" \
        "wslu" "" "" \
        "none" "" "" ""
}

# ============================================
# Main Script
# ============================================

show_menu() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}        ${YELLOW}Shellkit Core Tools Installer${NC}                      ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo
    
    if [ "$DRY_RUN" = "true" ]; then
        echo -e "${MAGENTA}╔════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${MAGENTA}║${NC}                    ${YELLOW}DRY-RUN MODE${NC}                           ${MAGENTA}║${NC}"
        echo -e "${MAGENTA}║${NC}      Commands will be shown but not executed              ${MAGENTA}║${NC}"
        echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════╝${NC}"
        echo
    fi
    
    detect_system
    
    # Use command-line option or prompt for install mode
    if [ -n "$OPT_MODE" ]; then
        INSTALL_MODE="$OPT_MODE"
        case "$INSTALL_MODE" in
            brew)
                ensure_homebrew
                ;;
            user)
                setup_local_bin
                ;;
        esac
    else
        echo -e "${CYAN}Installation Mode:${NC}"
        echo -e "  ${GREEN}1)${NC} System-wide using apt-get (requires sudo)"
        echo -e "  ${GREEN}2)${NC} System-wide using Homebrew"
        echo -e "  ${GREEN}3)${NC} User install to ~/.shellkit/bin (no sudo)"
        echo
        read -rp "Select mode [1/2/3]: " mode_choice
        
        case "$mode_choice" in
            1) 
                INSTALL_MODE="apt"
                ;;
            2) 
                INSTALL_MODE="brew"
                ensure_homebrew
                ;;
            3) 
                INSTALL_MODE="user"
                setup_local_bin
                ;;
            *) 
                echo -e "${RED}Invalid choice${NC}"
                exit 1
                ;;
        esac
        echo
    fi
    
    # Use command-line options or prompt for tool selection
    if [ -n "$OPT_ALL" ] || [ -n "$OPT_TOOLS" ]; then
        if [ "$OPT_ALL" = "true" ]; then
            install_all
        elif [ -n "$OPT_TOOLS" ]; then
            install_selected_tools "$OPT_TOOLS"
        fi
    else
        echo -e "${CYAN}Select tools to install:${NC}"
        echo -e "  ${GREEN}1)${NC} All core tools"
        echo -e "  ${GREEN}2)${NC} Select individual tools"
        echo
        read -rp "Select [1/2]: " install_choice
        
        echo
        
        case "$install_choice" in
            1)
                install_all
                ;;
            2)
                select_tools
                ;;
            *)
                echo -e "${RED}Invalid choice${NC}"
                exit 1
                ;;
        esac
    fi
}

# Install specific tools from comma-separated list (for --tools option)
install_selected_tools() {
    local tool_list="$1"
    local valid_tools=("fzf" "fd" "rg" "bat" "eza" "zoxide" "starship" "qrencode" "7z" "wslview")
    
    # Convert comma-separated list to array
    IFS=',' read -ra tools <<< "$tool_list"
    
    for tool in "${tools[@]}"; do
        # Trim whitespace
        tool=$(echo "$tool" | xargs)
        
        # Check if tool is valid
        local is_valid="false"
        for valid in "${valid_tools[@]}"; do
            if [ "$tool" = "$valid" ]; then
                is_valid="true"
                break
            fi
        done
        
        if [ "$is_valid" = "false" ]; then
            echo -e "${RED}Unknown tool: $tool${NC}"
            echo -e "Available tools: ${valid_tools[*]}"
            continue
        fi
        
        if command_exists "$tool"; then
            echo -e "${YELLOW}Skipping $tool (already installed)${NC}"
        else
            install_"$tool" "$INSTALL_MODE"
        fi
        echo
    done
    
    echo -e "${GREEN}Installation complete!${NC}"
}

install_all() {
    local tools=("fzf" "fd" "rg" "bat" "eza" "zoxide" "starship" "qrencode" "7z")
    
    # Add wslview only if running in WSL
    if grep -qi microsoft /proc/version 2>/dev/null; then
        tools+=("wslview")
    fi
    
    for tool in "${tools[@]}"; do
        if command_exists "$tool"; then
            echo -e "${YELLOW}Skipping $tool (already installed)${NC}"
        else
            install_"$tool" "$INSTALL_MODE"
        fi
        echo
    done
    
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}              ${YELLOW}Installation Complete!${NC}                        ${GREEN}║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo
    echo -e "${CYAN}Restart your shell or run:${NC}"
    echo -e "  reload             ${YELLOW}# shellkit alias${NC}"
    echo -e "  source ~/.bashrc   ${YELLOW}# for bash${NC}"
    echo -e "  source ~/.zshrc    ${YELLOW}# for zsh${NC}"
}

select_tools() {
    local tools=("fzf" "fd" "rg" "bat" "eza" "zoxide" "starship" "qrencode" "7z")
    local descriptions=(
        "Fuzzy finder for interactive selection"
        "Fast file finder (alternative to find)"
        "Ripgrep - fast grep replacement"
        "Cat replacement with syntax highlighting"
        "Modern ls replacement with icons"
        "Smarter cd command with frecency"
        "Cross-shell customizable prompt"
        "QR code generator for terminal"
        "7-Zip archive utility"
    )
    
    # Add wslview only if running in WSL
    if grep -qi microsoft /proc/version 2>/dev/null; then
        tools+=("wslview")
        descriptions+=("WSL utility to open URLs/files in Windows")
    fi
    
    echo -e "${CYAN}Available tools:${NC}"
    for i in "${!tools[@]}"; do
        local status="${RED}✗${NC}"
        if command_exists "${tools[$i]}"; then
            status="${GREEN}✓${NC}"
        fi
        echo -e "  ${GREEN}$((i+1)))${NC} ${tools[$i]} - ${descriptions[$i]} [$status]"
    done
    echo
    echo -e "Enter tool numbers separated by spaces (e.g., '1 3 5'), or 'q' to quit:"
    read -rp "> " selections
    
    if [ "$selections" = "q" ]; then
        exit 0
    fi
    
    echo
    for num in $selections; do
        local idx=$((num - 1))
        if [ "$idx" -ge 0 ] && [ "$idx" -lt "${#tools[@]}" ]; then
            local tool="${tools[$idx]}"
            if command_exists "$tool"; then
                echo -e "${YELLOW}Skipping $tool (already installed)${NC}"
            else
                install_"$tool" "$INSTALL_MODE"
            fi
            echo
        else
            echo -e "${RED}Invalid selection: $num${NC}"
        fi
    done
    
    echo -e "${GREEN}Installation complete!${NC}"
}

# Run the installer
show_menu

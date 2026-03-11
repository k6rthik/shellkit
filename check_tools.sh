#!/usr/bin/env bash
# Check for missing optional tools used by shellkit
# Run this script to see which tools are not installed on your machine

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
installed_count=0
missing_count=0

# Function to check if a command exists
check_tool() {
    local tool="$1"
    local description="$2"
    
    if command -v "$tool" &> /dev/null; then
        echo -e "  ${GREEN}✓${NC} $tool - $description"
        ((installed_count++))
    else
        echo -e "  ${RED}✗${NC} $tool - $description"
        ((missing_count++))
    fi
}

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}          ${YELLOW}Shellkit Tool Availability Check${NC}                 ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo

# Core Enhanced Tools
echo -e "${YELLOW}Core Enhanced Tools:${NC}"
check_tool "fzf" "Fuzzy finder for interactive selection"
check_tool "fd" "Fast file finder (alternative to find)"
check_tool "rg" "Ripgrep - fast grep replacement"
check_tool "bat" "Cat replacement with syntax highlighting"
check_tool "eza" "Modern ls replacement with icons"
check_tool "zoxide" "Smarter cd command with frecency"
check_tool "starship" "Cross-shell customizable prompt"
echo

# Development Tools
echo -e "${YELLOW}Development Tools:${NC}"
check_tool "git" "Version control system"
check_tool "docker" "Container runtime"
check_tool "docker-compose" "Multi-container Docker applications"
check_tool "gh" "GitHub CLI"
check_tool "tmux" "Terminal multiplexer"
check_tool "code" "Visual Studio Code"
echo

# Version/Package Managers
echo -e "${YELLOW}Version/Package Managers:${NC}"
check_tool "asdf" "Multi-runtime version manager"
check_tool "brew" "Homebrew package manager"
check_tool "npm" "Node.js package manager"
check_tool "yarn" "Alternative Node.js package manager"
check_tool "pip" "Python package manager"
check_tool "pip3" "Python 3 package manager"
check_tool "poetry" "Python dependency management"
check_tool "cargo" "Rust package manager"
check_tool "composer" "PHP package manager"
echo

# Utilities
echo -e "${YELLOW}Utilities:${NC}"
check_tool "qrencode" "QR code generator"
check_tool "7z" "7-Zip archive tool"
check_tool "unrar" "RAR archive extractor"
check_tool "curl" "URL data transfer tool"
check_tool "wget" "Network file downloader"
check_tool "jq" "JSON processor"
check_tool "htop" "Interactive process viewer"
check_tool "tree" "Directory tree viewer"
echo

# Editors
echo -e "${YELLOW}Editors:${NC}"
check_tool "vim" "Vi IMproved text editor"
check_tool "nvim" "Neovim text editor"
check_tool "nano" "Simple text editor"
echo

# WSL-specific (only check if in WSL)
if grep -qi microsoft /proc/version 2>/dev/null; then
    echo -e "${YELLOW}WSL-specific Tools:${NC}"
    check_tool "wslview" "Open files in Windows default application"
    check_tool "wslpath" "Convert paths between Windows and WSL"
    echo
fi

# Summary
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}Summary:${NC}"
echo -e "  ${GREEN}Installed:${NC} $installed_count tools"
echo -e "  ${RED}Missing:${NC}   $missing_count tools"
echo

if [ "$missing_count" -gt 0 ]; then
    echo -e "${YELLOW}Tip:${NC} Install missing tools to get the full shellkit experience."
    echo -e "     Most tools can be installed via your package manager:"
    echo -e "     ${BLUE}apt:${NC}  sudo apt install <tool>"
    echo -e "     ${BLUE}brew:${NC} brew install <tool>"
    echo
fi

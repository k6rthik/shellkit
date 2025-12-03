#!/usr/bin/env bash
# shellkit installation script
# This script helps set up shellkit on a new machine

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      shellkit Installation Script      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo

# Detect shell
detect_shell() {
    if [ -n "$ZSH_VERSION" ]; then
        echo "zsh"
    elif [ -n "$BASH_VERSION" ]; then
        echo "bash"
    else
        echo "unknown"
    fi
}

CURRENT_SHELL=$(detect_shell)
echo -e "${BLUE}Detected shell:${NC} $CURRENT_SHELL"
echo

# Ask user which shell they want to configure
echo "Which shell would you like to configure?"
echo "1) bash (${HOME}/.bashrc)"
echo "2) zsh (${HOME}/.zshrc)"
echo "3) both"
echo "4) skip (manual configuration)"
read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        CONFIG_FILES=("$HOME/.bashrc")
        ;;
    2)
        CONFIG_FILES=("$HOME/.zshrc")
        ;;
    3)
        CONFIG_FILES=("$HOME/.bashrc" "$HOME/.zshrc")
        ;;
    4)
        CONFIG_FILES=()
        echo -e "${YELLOW}Skipping automatic configuration.${NC}"
        ;;
    *)
        echo -e "${RED}Invalid choice. Exiting.${NC}"
        exit 1
        ;;
esac

# Source line to add
SOURCE_LINE="[ -f \"${SCRIPT_DIR}/init.sh\" ] && source \"${SCRIPT_DIR}/init.sh\""

# Add source line to each config file
for config_file in "${CONFIG_FILES[@]}"; do
    echo
    echo -e "${BLUE}Configuring:${NC} $config_file"
    
    # Create file if it doesn't exist
    if [ ! -f "$config_file" ]; then
        touch "$config_file"
        echo -e "${GREEN}✓${NC} Created $config_file"
    fi
    
    # Check if already configured
    if grep -Fq "shellkit/init.sh" "$config_file"; then
        echo -e "${YELLOW}⚠${NC} shellkit already configured in $config_file"
    else
        # Backup existing file
        cp "$config_file" "${config_file}.backup-$(date +%Y%m%d-%H%M%S)"
        echo -e "${GREEN}✓${NC} Created backup"
        
        # Add source line
        echo "" >> "$config_file"
        echo "# Load shellkit configuration" >> "$config_file"
        echo "$SOURCE_LINE" >> "$config_file"
        echo -e "${GREEN}✓${NC} Added shellkit to $config_file"
    fi
done

# Create .env.local if it doesn't exist
echo
if [ ! -f "${SCRIPT_DIR}/.env.local" ]; then
    echo -e "${BLUE}Creating .env.local from template...${NC}"
    cp "${SCRIPT_DIR}/.env.example" "${SCRIPT_DIR}/.env.local"
    echo -e "${GREEN}✓${NC} Created .env.local (edit this file for local environment variables)"
else
    echo -e "${YELLOW}⚠${NC} .env.local already exists"
fi

# Create local.sh if it doesn't exist
if [ ! -f "${SCRIPT_DIR}/local.sh" ]; then
    echo -e "${BLUE}Creating local.sh...${NC}"
    cat > "${SCRIPT_DIR}/local.sh" << 'EOF'
#!/usr/bin/env bash
# Local Shell Configuration
# This file is not tracked in git - add machine-specific configurations here

# Example: Machine-specific aliases
# alias work='cd /path/to/work/directory'

# Example: Local PATH additions
# export PATH="$HOME/local/bin:$PATH"

# Add your local configurations below
# ============================================

EOF
    echo -e "${GREEN}✓${NC} Created local.sh (edit this file for local configurations)"
else
    echo -e "${YELLOW}⚠${NC} local.sh already exists"
fi

# Summary
echo
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║      Installation Complete! 🎉         ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo
echo "Next steps:"
echo
echo "1. Edit ${SCRIPT_DIR}/.env.local for environment variables"
echo "2. Edit ${SCRIPT_DIR}/local.sh for local configurations"
echo "3. Reload your shell:"
for config_file in "${CONFIG_FILES[@]}"; do
    echo "   source $config_file"
done
echo "   or open a new terminal"
echo
echo "4. Test the installation:"
echo "   echo \$SHELLKIT_DIR"
echo "   echo \$SHELLKIT_SHELL"
echo
echo "To enable verbose loading (for debugging):"
echo "   export SHELLKIT_VERBOSE=1"
echo
echo -e "${BLUE}For more information, see README.md${NC}"
echo

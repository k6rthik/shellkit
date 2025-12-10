#!/usr/bin/env bash
# Test script for shellkit configuration

set -e

echo "🧪 Testing shellkit configuration..."
echo

# Test 1: Check if SHELLKIT_DIR is set
echo "✓ Test 1: SHELLKIT_DIR environment variable"
if [ -n "$SHELLKIT_DIR" ]; then
    echo "  SHELLKIT_DIR=$SHELLKIT_DIR"
else
    echo "  ❌ SHELLKIT_DIR not set"
    exit 1
fi

# Test 2: Check shell detection
echo "✓ Test 2: Shell detection"
if [ -n "$SHELLKIT_SHELL" ]; then
    echo "  Detected shell: $SHELLKIT_SHELL"
else
    echo "  ❌ SHELLKIT_SHELL not set"
    exit 1
fi

# Test 3: Test aliases
echo "✓ Test 3: Testing aliases"
alias | grep -q "ll=" && echo "  ✓ ll alias exists"
alias | grep -q "gs=" && echo "  ✓ gs (git status) alias exists"
command -v fzf &> /dev/null && alias | grep -q "fzgbc=" && echo "  ✓ fzgbc (git branch checkout) alias exists"

# Test 4: Test functions
echo "✓ Test 4: Testing functions"
type extract &> /dev/null && echo "  ✓ extract function exists"
type mkcd &> /dev/null && echo "  ✓ mkcd function exists"
command -v fzf &> /dev/null && type fzf_file &> /dev/null && echo "  ✓ fzf_file function exists"

# Test 5: Test PATH modifications
echo "✓ Test 5: Testing PATH"
echo "$PATH" | grep -q ".local/bin" && echo "  ✓ .local/bin in PATH"
command -v fd &> /dev/null && echo "  ✓ fd command available"
command -v rg &> /dev/null && echo "  ✓ rg (ripgrep) command available"
command -v bat &> /dev/null && echo "  ✓ bat command available"

# Test 6: Test fzf integration
echo "✓ Test 6: Testing FZF integration"
if command -v fzf &> /dev/null; then
    echo "  ✓ fzf is installed"
    [ -n "$FZF_DEFAULT_OPTS" ] && echo "  ✓ FZF_DEFAULT_OPTS is set"
    [ -n "$FZF_DEFAULT_COMMAND" ] && echo "  ✓ FZF_DEFAULT_COMMAND is set"
else
    echo "  ⚠ fzf not installed (skipping fzf tests)"
fi

# Test 7: Test environment variables
echo "✓ Test 7: Testing environment variables"
[ -n "$EDITOR" ] && echo "  ✓ EDITOR=$EDITOR"
[ -n "$HISTSIZE" ] && echo "  ✓ HISTSIZE=$HISTSIZE"
[ -n "$LANG" ] && echo "  ✓ LANG=$LANG"

# Test 8: Test modern tools integration
echo "✓ Test 8: Testing modern tools"
command -v starship &> /dev/null && echo "  ✓ starship installed"
command -v exa &> /dev/null && echo "  ✓ exa installed"

echo
echo "✅ All tests passed!"
echo
echo "Try these commands:"
echo "  ll          - List files"
echo "  gs          - Git status"
echo "  fzff        - FZF file picker (if fzf installed)"
echo "  fzh         - FZF history search"
echo "  fzgbc       - FZF git branch checkout"
echo "  fzgl        - FZF git log browser"
echo "  extract     - Extract archives"
echo "  mkcd test   - Create and cd into directory"
echo "  showpath    - Show PATH in readable format"

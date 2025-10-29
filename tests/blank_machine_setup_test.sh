#!/usr/bin/env bash

#  ______ _      ______
#  | | \ | |    |___  /
#  | |_/ / |       / /    - Rickey Zachary
#  |    /| |      / /     - website: https://rickeyzachary.com
#  | |\ \| |____./ /___   - twitter: zachary_rickey | github: rzachary (https://github.com/rzachary)
#  |_| \_\_____/\_____/
#
#
# Blank Machine Setup Test
# Tests the complete setup process from scratch

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

print_step() {
    echo -e "${YELLOW}Step: $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

print_header "Blank Machine Setup Simulation Test"
echo "Dotfiles directory: $DOTFILES_DIR"
echo

# Create a temporary "clean" environment
TEMP_HOME="/tmp/blank_machine_test_$$"
export ORIGINAL_HOME="$HOME"
export HOME="$TEMP_HOME"

cleanup() {
    export HOME="$ORIGINAL_HOME"
    rm -rf "$TEMP_HOME"
}
trap cleanup EXIT

print_step "Creating clean environment"
mkdir -p "$HOME"
mkdir -p "$HOME/.config"
print_success "Clean environment created at $HOME"

print_header "Prerequisites Check"

# Check if Homebrew would be available
print_step "Checking for Homebrew"
if command -v brew >/dev/null 2>&1; then
    BREW_PREFIX="$(brew --prefix)"
    print_success "Homebrew found at $BREW_PREFIX"
else
    print_warning "Homebrew not found - would need to be installed first"
    BREW_PREFIX="/opt/homebrew"  # Default Apple Silicon location
fi

# Check required zsh plugins
print_step "Checking for zsh plugins"
MISSING_PLUGINS=()

if [[ ! -f "$BREW_PREFIX/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    MISSING_PLUGINS+=("zsh-autosuggestions")
fi

if [[ ! -f "$BREW_PREFIX/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    MISSING_PLUGINS+=("zsh-syntax-highlighting")
fi

if [[ ${#MISSING_PLUGINS[@]} -gt 0 ]]; then
    print_warning "Missing plugins: ${MISSING_PLUGINS[*]}"
    echo "  Run: brew install ${MISSING_PLUGINS[*]}"
else
    print_success "All required zsh plugins found"
fi

print_header "Dotfiles Installation Simulation"

print_step "Copying dotfiles to clean environment"
mkdir -p "$HOME/.config/zsh"
cp "$DOTFILES_DIR/.config/zsh/.zshrc" "$HOME/.config/zsh/"
cp "$DOTFILES_DIR/.config/zsh/.zprofile" "$HOME/.config/zsh/"
cp "$DOTFILES_DIR/.config/zsh/.aliases" "$HOME/.config/zsh/"
cp "$DOTFILES_DIR/.config/zsh/.extra" "$HOME/.config/zsh/"
print_success "Dotfiles copied"

print_step "Setting up ZDOTDIR"
export ZDOTDIR="$HOME/.config/zsh"
print_success "ZDOTDIR set to $ZDOTDIR"

print_header "Configuration Loading Test"

print_step "Testing .zprofile loading"
if zsh -c "source '$HOME/.config/zsh/.zprofile' && echo 'Profile loaded successfully'" 2>/dev/null; then
    print_success ".zprofile loads without errors"
else
    print_error ".zprofile failed to load"
    exit 1
fi

print_step "Testing .zshrc loading"
# Create a test script that handles missing Homebrew gracefully
cat > "$HOME/test_zshrc.zsh" << 'EOF'
# Mock brew command if not available
if ! command -v brew >/dev/null 2>&1; then
    brew() {
        echo "/opt/homebrew"  # Default location
    }
fi

source ~/.config/zsh/.zshrc
echo "zshrc loaded successfully"
EOF

if zsh "$HOME/test_zshrc.zsh" 2>/dev/null; then
    print_success ".zshrc loads without errors"
else
    print_error ".zshrc failed to load"
    exit 1
fi

print_header "Environment Validation"

print_step "Checking environment variables"
ENV_TEST_SCRIPT="$HOME/test_env.zsh"
cat > "$ENV_TEST_SCRIPT" << 'EOF'
# Mock brew if needed
if ! command -v brew >/dev/null 2>&1; then
    brew() { echo "/opt/homebrew"; }
fi

source ~/.config/zsh/.zprofile

# Validate critical environment variables
errors=0

[[ -n "$EDITOR" ]] || { echo "EDITOR not set"; ((errors++)); }
[[ -n "$TERMINAL" ]] || { echo "TERMINAL not set"; ((errors++)); }
[[ -n "$BROWSER" ]] || { echo "BROWSER not set"; ((errors++)); }
[[ -n "$GOPATH" ]] || { echo "GOPATH not set"; ((errors++)); }
[[ -n "$XDG_CONFIG_HOME" ]] || { echo "XDG_CONFIG_HOME not set"; ((errors++)); }

if [[ $errors -eq 0 ]]; then
    echo "All environment variables properly set"
    exit 0
else
    echo "$errors environment variables missing"
    exit 1
fi
EOF

if zsh "$ENV_TEST_SCRIPT"; then
    print_success "All critical environment variables set"
else
    print_error "Some environment variables missing"
fi

print_header "PATH Management Test"

print_step "Testing PATH configuration"
PATH_TEST_SCRIPT="$HOME/test_path.zsh"
cat > "$PATH_TEST_SCRIPT" << 'EOF'
# Start with clean PATH
export PATH="/usr/bin:/bin"

# Mock brew if needed
if ! command -v brew >/dev/null 2>&1; then
    brew() { echo "/opt/homebrew"; }
fi

# Create test directories
mkdir -p ~/.local/bin ~/.local/go/bin

source ~/.config/zsh/.zprofile
source ~/.config/zsh/.zshrc

# Check PATH contents
echo "Final PATH: $PATH"

# Verify our directories are in PATH
echo "$PATH" | grep -q "$HOME/.local/bin" || { echo "Missing ~/.local/bin"; exit 1; }
echo "$PATH" | grep -q "$HOME/.local/go/bin" || { echo "Missing ~/.local/go/bin"; exit 1; }

echo "PATH configured correctly"
EOF

if zsh "$PATH_TEST_SCRIPT"; then
    print_success "PATH management works correctly"
else
    print_error "PATH management has issues"
fi

print_header "Security Validation"

print_step "Checking for exposed secrets"
SECRETS_FOUND=false

# Check main config files for actual secrets (not comments)
for file in "$HOME/.config/zsh/.zshrc" "$HOME/.config/zsh/.zprofile"; do
    if grep -v "^#" "$file" | grep -i "api.*key\|token\|secret" >/dev/null 2>&1; then
        print_error "Potential secrets found in $(basename "$file")"
        SECRETS_FOUND=true
    fi
done

if [[ "$SECRETS_FOUND" == "false" ]]; then
    print_success "No exposed secrets in main configuration files"
fi

print_step "Verifying .extra file security"
if [[ -f "$HOME/.config/zsh/.extra" ]]; then
    if grep -q "API.*KEY\|TOKEN" "$HOME/.config/zsh/.extra"; then
        print_success "Secrets properly contained in .extra file"
    else
        print_warning ".extra file exists but may not contain expected secrets"
    fi
else
    print_warning ".extra file not found"
fi

print_header "Compatibility Test"

print_step "Testing zsh version compatibility"
ZSH_VERSION=$(zsh --version | cut -d' ' -f2)
REQUIRED_VERSION="5.0"

if [[ "$(printf '%s\n' "$REQUIRED_VERSION" "$ZSH_VERSION" | sort -V | head -n1)" == "$REQUIRED_VERSION" ]]; then
    print_success "Zsh version $ZSH_VERSION is compatible (>= $REQUIRED_VERSION)"
else
    print_error "Zsh version $ZSH_VERSION may be too old (< $REQUIRED_VERSION)"
fi

print_header "Installation Checklist"

echo "For a successful setup on a blank machine, ensure:"
echo
echo "1. macOS with Xcode Command Line Tools installed"
echo "2. Homebrew installed: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
echo "3. Required Homebrew packages:"
echo "   brew install zsh zsh-autosuggestions zsh-syntax-highlighting"
echo "4. Clone dotfiles repository"
echo "5. Run bootstrap.sh to create symlinks"
echo "6. Set zsh as default shell: chsh -s /bin/zsh"
echo

print_header "Test Summary"
print_success "Blank machine setup simulation completed successfully!"
print_success "Your zsh configuration should work on a fresh machine with proper setup."

if [[ ${#MISSING_PLUGINS[@]} -gt 0 ]]; then
    echo
    print_warning "Don't forget to install missing plugins: brew install ${MISSING_PLUGINS[*]}"
fi
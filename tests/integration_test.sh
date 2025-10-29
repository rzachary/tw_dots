#!/usr/bin/env bash

#  ______ _      ______
#  | | \ | |    |___  /
#  | |_/ / |       / /    - Rickey Zachary
#  |    /| |      / /     - website: https://rickeyzachary.com
#  | |\ \| |____./ /___   - twitter: zachary_rickey | github: rzachary (https://github.com/rzachary)
#  |_| \_\_____/\_____/
#
#
# Integration Test Script
# Simulates loading zsh configuration on a blank machine

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

print_test() {
    echo -e "${YELLOW}Testing: $1${NC}"
    ((TESTS_RUN++))
}

pass_test() {
    echo -e "${GREEN}✓ PASS: $1${NC}"
    ((TESTS_PASSED++))
}

fail_test() {
    echo -e "${RED}✗ FAIL: $1${NC}"
    echo -e "${RED}  Error: $2${NC}"
    ((TESTS_FAILED++))
}

# Get dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_DIR="/tmp/zsh_config_test_$$"
ZSH_CONFIG_DIR="$TEST_DIR/.config/zsh"

cleanup() {
    rm -rf "$TEST_DIR"
}
trap cleanup EXIT

print_header "Zsh Configuration Integration Test"
echo "Creating test environment in: $TEST_DIR"

# Create test environment
mkdir -p "$ZSH_CONFIG_DIR"
cp "$DOTFILES_DIR/.config/zsh/.zshrc" "$ZSH_CONFIG_DIR/"
cp "$DOTFILES_DIR/.config/zsh/.zprofile" "$ZSH_CONFIG_DIR/"
cp "$DOTFILES_DIR/.config/zsh/.aliases" "$ZSH_CONFIG_DIR/"
cp "$DOTFILES_DIR/.config/zsh/.extra" "$ZSH_CONFIG_DIR/"

# Create mock directories that might not exist on blank machine
mkdir -p "$TEST_DIR/.local/bin"
mkdir -p "$TEST_DIR/.local/go/bin"
mkdir -p "$TEST_DIR/.config/nvm"

# Create fake homebrew structure for testing
FAKE_BREW_PREFIX="/tmp/fake_homebrew_$$"
mkdir -p "$FAKE_BREW_PREFIX/opt/zsh-autosuggestions/share/zsh-autosuggestions"
mkdir -p "$FAKE_BREW_PREFIX/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting"

# Create mock plugin files
touch "$FAKE_BREW_PREFIX/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
touch "$FAKE_BREW_PREFIX/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

print_header "Environment Setup Tests"

print_test "Test environment created"
if [[ -d "$TEST_DIR" ]]; then
    pass_test "Test environment created"
else
    fail_test "Test environment created" "Failed to create test directory"
fi

print_test "Configuration files copied"
if [[ -f "$ZSH_CONFIG_DIR/.zshrc" && -f "$ZSH_CONFIG_DIR/.zprofile" ]]; then
    pass_test "Configuration files copied"
else
    fail_test "Configuration files copied" "Missing configuration files"
fi

print_header "Zsh Loading Simulation Tests"

# Test 1: Load configuration without errors
print_test "Load zsh configuration without errors"

# Create a test script that simulates loading the configuration
cat > "$TEST_DIR/test_load.zsh" << 'EOF'
#!/usr/bin/env zsh
set -e

# Mock environment variables
export HOME="__TEST_HOME__"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export ZDOTDIR="$HOME/.config/zsh"

# Mock brew command
brew() {
    case "$1" in
        "--prefix")
            echo "__FAKE_BREW_PREFIX__"
            ;;
        *)
            echo "/fake/brew/path"
            ;;
    esac
}

# Source the configuration files
source "$HOME/.config/zsh/.zprofile"
source "$HOME/.config/zsh/.zshrc"

echo "Configuration loaded successfully"
EOF

# Replace placeholders
sed -i.bak \
    -e "s|__TEST_HOME__|$TEST_DIR|g" \
    -e "s|__FAKE_BREW_PREFIX__|$FAKE_BREW_PREFIX|g" \
    "$TEST_DIR/test_load.zsh"

if zsh "$TEST_DIR/test_load.zsh" > "$TEST_DIR/load_output.log" 2>&1; then
    pass_test "Load zsh configuration without errors"
else
    fail_test "Load zsh configuration without errors" "$(cat "$TEST_DIR/load_output.log")"
fi

# Test 2: Check environment variables are set correctly
print_test "Environment variables set correctly"

cat > "$TEST_DIR/test_env.zsh" << 'EOF'
#!/usr/bin/env zsh
export HOME="__TEST_HOME__"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# Mock brew command
brew() { echo "__FAKE_BREW_PREFIX__"; }

source "$HOME/.config/zsh/.zprofile"

# Check critical environment variables
[[ -n "$GOPATH" ]] || { echo "GOPATH not set"; exit 1; }
[[ -n "$EDITOR" ]] || { echo "EDITOR not set"; exit 1; }
[[ -n "$TERMINAL" ]] || { echo "TERMINAL not set"; exit 1; }

echo "Environment variables OK"
EOF

sed -i.bak \
    -e "s|__TEST_HOME__|$TEST_DIR|g" \
    -e "s|__FAKE_BREW_PREFIX__|$FAKE_BREW_PREFIX|g" \
    "$TEST_DIR/test_env.zsh"

if zsh "$TEST_DIR/test_env.zsh" > "$TEST_DIR/env_output.log" 2>&1; then
    pass_test "Environment variables set correctly"
else
    fail_test "Environment variables set correctly" "$(cat "$TEST_DIR/env_output.log")"
fi

# Test 3: PATH management works correctly
print_test "PATH management works correctly"

cat > "$TEST_DIR/test_path.zsh" << 'EOF'
#!/usr/bin/env zsh
export HOME="__TEST_HOME__"
export PATH="/usr/bin:/bin"  # Start with minimal PATH

# Mock brew command
brew() { echo "__FAKE_BREW_PREFIX__"; }

source "$HOME/.config/zsh/.zprofile"
source "$HOME/.config/zsh/.zshrc"

# Check that our local bin directories were added
echo "$PATH" | grep -q "$HOME/.local/bin" || { echo "local bin not in PATH"; exit 1; }
echo "$PATH" | grep -q "$HOME/.local/go/bin" || { echo "go bin not in PATH"; exit 1; }

# Check for no duplicates (simple check)
local_bin_count=$(echo "$PATH" | tr ':' '\n' | grep -c "$HOME/.local/bin" || true)
[[ $local_bin_count -eq 1 ]] || { echo "Duplicate paths detected"; exit 1; }

echo "PATH management OK"
EOF

sed -i.bak \
    -e "s|__TEST_HOME__|$TEST_DIR|g" \
    -e "s|__FAKE_BREW_PREFIX__|$FAKE_BREW_PREFIX|g" \
    "$TEST_DIR/test_path.zsh"

if zsh "$TEST_DIR/test_path.zsh" > "$TEST_DIR/path_output.log" 2>&1; then
    pass_test "PATH management works correctly"
else
    fail_test "PATH management works correctly" "$(cat "$TEST_DIR/path_output.log")"
fi

# Test 4: Plugin loading with missing plugins (should show warnings but not fail)
print_test "Plugin loading handles missing dependencies gracefully"

# Remove the mock plugin files to test error handling
rm -f "$FAKE_BREW_PREFIX/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

cat > "$TEST_DIR/test_plugins.zsh" << 'EOF'
#!/usr/bin/env zsh
export HOME="__TEST_HOME__"

# Mock brew command
brew() { echo "__FAKE_BREW_PREFIX__"; }

# Capture warnings
source "$HOME/.config/zsh/.zshrc" 2>&1 | grep -q "Warning.*zsh-autosuggestions" && echo "Warning displayed correctly"
EOF

sed -i.bak \
    -e "s|__TEST_HOME__|$TEST_DIR|g" \
    -e "s|__FAKE_BREW_PREFIX__|$FAKE_BREW_PREFIX|g" \
    "$TEST_DIR/test_plugins.zsh"

if zsh "$TEST_DIR/test_plugins.zsh" > "$TEST_DIR/plugin_output.log" 2>&1; then
    if grep -q "Warning displayed correctly" "$TEST_DIR/plugin_output.log"; then
        pass_test "Plugin loading handles missing dependencies gracefully"
    else
        fail_test "Plugin loading handles missing dependencies gracefully" "Warning not displayed"
    fi
else
    fail_test "Plugin loading handles missing dependencies gracefully" "$(cat "$TEST_DIR/plugin_output.log")"
fi

print_header "Dependency Check Tests"

# Test 5: Check for required tools
print_test "Required tools availability check"

MISSING_TOOLS=()
for tool in zsh git curl; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        MISSING_TOOLS+=("$tool")
    fi
done

if [[ ${#MISSING_TOOLS[@]} -eq 0 ]]; then
    pass_test "Required tools availability check"
else
    fail_test "Required tools availability check" "Missing tools: ${MISSING_TOOLS[*]}"
fi

# Cleanup fake homebrew
rm -rf "$FAKE_BREW_PREFIX"

print_header "Test Summary"
echo "Tests run: $TESTS_RUN"
echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"

if [[ $TESTS_FAILED -eq 0 ]]; then
    echo -e "${GREEN}All integration tests passed! ✓${NC}"
    echo "Your zsh configuration should work correctly on a blank machine."
    exit 0
else
    echo -e "${RED}Some integration tests failed! ✗${NC}"
    echo "Check the configuration before deploying to a blank machine."
    exit 1
fi
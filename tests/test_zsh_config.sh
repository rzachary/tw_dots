#!/usr/bin/env bash

#  ______ _      ______
#  | | \ | |    |___  /
#  | |_/ / |       / /    - Rickey Zachary
#  |    /| |      / /     - website: https://rickeyzachary.com
#  | |\ \| |____./ /___   - twitter: zachary_rickey | github: rzachary (https://github.com/rzachary)
#  |_| \_\_____/\_____/
#
#
# Zsh Configuration Test Suite
# Tests to ensure dotfiles work correctly on a blank machine

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test framework functions
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

test_assertion() {
    local test_name="$1"
    local condition="$2"
    local error_msg="${3:-Assertion failed}"
    
    print_test "$test_name"
    
    if eval "$condition"; then
        pass_test "$test_name"
        return 0
    else
        fail_test "$test_name" "$error_msg"
        return 1
    fi
}

# Get the directory of the dotfiles
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ZSH_CONFIG_DIR="$DOTFILES_DIR/.config/zsh"

print_header "Zsh Configuration Test Suite"
echo "Testing dotfiles in: $DOTFILES_DIR"
echo

# Test 1: File existence
print_header "File Existence Tests"

test_assertion "zshrc file exists" \
    '[[ -f "$ZSH_CONFIG_DIR/.zshrc" ]]' \
    ".zshrc file not found at $ZSH_CONFIG_DIR/.zshrc"

test_assertion "zprofile file exists" \
    '[[ -f "$ZSH_CONFIG_DIR/.zprofile" ]]' \
    ".zprofile file not found at $ZSH_CONFIG_DIR/.zprofile"

test_assertion "aliases file exists" \
    '[[ -f "$ZSH_CONFIG_DIR/.aliases" ]]' \
    ".aliases file not found at $ZSH_CONFIG_DIR/.aliases"

test_assertion "extra file exists" \
    '[[ -f "$ZSH_CONFIG_DIR/.extra" ]]' \
    ".extra file not found at $ZSH_CONFIG_DIR/.extra"

# Test 2: Security - No exposed secrets in main files
print_header "Security Tests"

test_assertion "No API keys in .zshrc" \
    '! grep -i "api.*key\|token\|secret" "$ZSH_CONFIG_DIR/.zshrc"' \
    "Found potential API keys or tokens in .zshrc"

test_assertion "No API keys in .zprofile" \
    '! grep -E "(GEMINI_API_KEY|GITHUB_TOKEN|AUTH_GITHUB)" "$ZSH_CONFIG_DIR/.zprofile"' \
    "Found exposed API keys in .zprofile"

test_assertion "API keys properly secured in .extra" \
    'grep -q "GEMINI_API_KEY\|GITHUB_TOKEN" "$ZSH_CONFIG_DIR/.extra"' \
    "API keys not found in .extra file"

# Test 3: Configuration validation
print_header "Configuration Validation Tests"

# Test zsh syntax
test_assertion "zshrc has valid syntax" \
    'zsh -n "$ZSH_CONFIG_DIR/.zshrc"' \
    "Syntax error in .zshrc"

test_assertion "zprofile has valid syntax" \
    'zsh -n "$ZSH_CONFIG_DIR/.zprofile"' \
    "Syntax error in .zprofile"

# Test for required configurations
test_assertion "History configuration present" \
    'grep -q "HISTSIZE.*50000" "$ZSH_CONFIG_DIR/.zshrc"' \
    "HISTSIZE not set to 50000"

test_assertion "History options configured" \
    'grep -q "HIST_IGNORE_DUPS\|SHARE_HISTORY" "$ZSH_CONFIG_DIR/.zshrc"' \
    "History options not properly configured"

test_assertion "Plugin error checking present" \
    'grep -q "Warning.*zsh-autosuggestions" "$ZSH_CONFIG_DIR/.zshrc"' \
    "Plugin error checking not implemented"

# Test 4: PATH management
print_header "PATH Management Tests"

test_assertion "No duplicate GOPATH definitions" \
    '[ $(grep -c "GOPATH.*=" "$ZSH_CONFIG_DIR/.zshrc" "$ZSH_CONFIG_DIR/.zprofile" 2>/dev/null) -eq 1 ]' \
    "Multiple GOPATH definitions found"

test_assertion "Smart PATH management implemented" \
    'grep -q "case.*PATH.*already in PATH" "$ZSH_CONFIG_DIR/.zshrc"' \
    "Smart PATH deduplication not implemented"

# Test 5: Alias validation
print_header "Alias Tests"

test_assertion "No typos in aliases" \
    '! grep -q "coloflag" "$ZSH_CONFIG_DIR/.aliases"' \
    "Found typo: coloflag should be colorflag"

test_assertion "Essential aliases present" \
    'grep -q "alias.*exa\|alias.*nvim" "$ZSH_CONFIG_DIR/.aliases"' \
    "Essential aliases not found"

echo
print_header "Test Summary"
echo "Tests run: $TESTS_RUN"
echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"

if [[ $TESTS_FAILED -eq 0 ]]; then
    echo -e "${GREEN}All tests passed! ✓${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed! ✗${NC}"
    exit 1
fi
#!/usr/bin/env bash

#  ______ _      ______
#  | | \ | |    |___  /
#  | |_/ / |       / /    - Rickey Zachary
#  |    /| |      / /     - website: https://rickeyzachary.com
#  | |\ \| |____./ /___   - twitter: zachary_rickey | github: rzachary (https://github.com/rzachary)
#  |_| \_\_____/\_____/
#
#
# Run All Tests - Master Test Runner
# Executes all test suites for zsh configuration validation

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_banner() {
    echo -e "${BLUE}${BOLD}"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                    ZSH CONFIGURATION TEST SUITE               ║"
    echo "║                         Rickey Zachary                        ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_header() {
    echo -e "${BLUE}${BOLD}=== $1 ===${NC}"
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

run_test_suite() {
    local test_name="$1"
    local test_script="$2"
    local description="$3"
    
    echo
    print_header "$test_name"
    echo "$description"
    echo
    
    if [[ ! -f "$test_script" ]]; then
        print_error "Test script not found: $test_script"
        return 1
    fi
    
    if [[ ! -x "$test_script" ]]; then
        chmod +x "$test_script"
    fi
    
    if "$test_script"; then
        print_success "$test_name completed successfully"
        return 0
    else
        print_error "$test_name failed"
        return 1
    fi
}

# Initialize test results
TOTAL_SUITES=0
PASSED_SUITES=0
FAILED_SUITES=0

print_banner

echo "Testing zsh configuration for reliability on blank machines"
echo "Dotfiles location: $(dirname "$SCRIPT_DIR")"
echo

# Test Suite 1: Configuration Validation
((TOTAL_SUITES++))
if run_test_suite \
    "Configuration Validation Tests" \
    "$SCRIPT_DIR/test_zsh_config.sh" \
    "Validates syntax, security, and configuration correctness"; then
    ((PASSED_SUITES++))
else
    ((FAILED_SUITES++))
fi

# Test Suite 2: Integration Tests
((TOTAL_SUITES++))
if run_test_suite \
    "Integration Tests" \
    "$SCRIPT_DIR/integration_test.sh" \
    "Tests configuration loading and runtime behavior"; then
    ((PASSED_SUITES++))
else
    ((FAILED_SUITES++))
fi

# Test Suite 3: Blank Machine Setup
((TOTAL_SUITES++))
if run_test_suite \
    "Blank Machine Setup Simulation" \
    "$SCRIPT_DIR/blank_machine_setup_test.sh" \
    "Simulates complete setup process on a fresh machine"; then
    ((PASSED_SUITES++))
else
    ((FAILED_SUITES++))
fi

# Final Results
echo
print_header "Final Test Results"
echo -e "Total test suites: ${BOLD}$TOTAL_SUITES${NC}"
echo -e "Passed: ${GREEN}${BOLD}$PASSED_SUITES${NC}"
echo -e "Failed: ${RED}${BOLD}$FAILED_SUITES${NC}"

if [[ $FAILED_SUITES -eq 0 ]]; then
    echo
    print_success "All test suites passed! Your zsh configuration is ready for deployment."
    echo
    echo -e "${GREEN}${BOLD}Deployment Checklist:${NC}"
    echo "1. ✓ Configuration files validated"
    echo "2. ✓ Security checks passed"
    echo "3. ✓ Integration tests successful"
    echo "4. ✓ Blank machine compatibility verified"
    echo
    echo -e "${BLUE}Your dotfiles are ready to deploy to any macOS machine!${NC}"
    exit 0
else
    echo
    print_error "Some test suites failed. Please review and fix issues before deployment."
    echo
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Review failed test output above"
    echo "2. Fix any configuration issues"
    echo "3. Re-run tests: ./tests/run_all_tests.sh"
    exit 1
fi
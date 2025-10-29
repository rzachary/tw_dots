# Zsh Configuration Test Suite

This directory contains comprehensive tests to ensure your zsh configuration works reliably on blank machines.

## Test Scripts

### `simple_validation.sh` ⭐ **Recommended**
Quick validation script that checks:
- ✅ All configuration files exist
- ✅ No secrets exposed in main files
- ✅ Syntax validation for zsh files
- ✅ Configuration improvements applied

**Usage:**
```bash
./tests/simple_validation.sh
```

### `blank_machine_setup_test.sh`
Comprehensive simulation of setting up the configuration on a fresh machine:
- Environment simulation
- Prerequisite checking
- Configuration loading tests
- PATH management validation
- Security verification

**Usage:**
```bash
./tests/blank_machine_setup_test.sh
```

### `integration_test.sh`
Integration tests that verify configuration loading and runtime behavior:
- Mock environment creation
- Plugin loading tests
- Environment variable validation
- PATH deduplication testing

### `test_zsh_config.sh`
Static configuration validation:
- File existence checks
- Security auditing
- Configuration correctness

### `run_all_tests.sh`
Master test runner that executes all test suites (note: some may have issues with bash/zsh compatibility).

## What These Tests Validate

### Security ✅
- No API keys or tokens in main configuration files
- Sensitive data properly isolated in `.extra` file
- Comments vs actual secrets differentiation

### Performance ✅
- History optimization (50K entries, deduplication)
- Smart PATH management without duplicates
- Plugin loading with error handling

### Reliability ✅
- Graceful handling of missing dependencies
- Error checking for Homebrew plugins
- Compatibility with blank machine environments

### Configuration Quality ✅
- Syntax validation for all zsh files
- Proper GOPATH configuration
- Fixed typos and inconsistencies

## Deployment Checklist

The tests verify your configuration is ready when these prerequisites are met:

1. **macOS** with Xcode Command Line Tools
2. **Homebrew** installed
3. **Required packages**: `brew install zsh zsh-autosuggestions zsh-syntax-highlighting`
4. **Repository cloned** to target machine
5. **Bootstrap script** executed to create symlinks
6. **Zsh set as default shell**: `chsh -s /bin/zsh`

## Quick Start

For a fast validation of your configuration:

```bash
# Quick validation (recommended)
./tests/simple_validation.sh

# Comprehensive blank machine test
./tests/blank_machine_setup_test.sh
```

Both tests passing means your dotfiles are ready for deployment! 🚀
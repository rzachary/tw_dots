# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository (`tw_dots`) containing comprehensive macOS development environment setup and configuration files. It's designed to bootstrap a complete development environment with tools, applications, and custom configurations for productivity.

## Key Setup Commands

### Initial System Setup
- `./install.sh` - Main installation script that sets up Homebrew, development tools, and applications
- `./bootstrap.sh` - Creates symbolic links for dotfiles and clones additional themes

The installation process is designed for macOS and includes:
- Homebrew package manager
- Development languages (Go, Python, TypeScript)
- Terminal tools (zsh, tmux, neovim, fzf, exa)
- Security tools (CTF/pentesting utilities)
- Applications via Homebrew Cask
- System preference customizations

### No Build/Test Commands
This repository contains configuration files only - there are no build, test, or lint commands to run.

## Architecture and Structure

### Configuration Layout
```
.config/
├── alacritty/          # Terminal emulator config (Nord theme)
├── aerospace/          # macOS window manager (i3-like)
├── nvim_rename/        # Neovim configuration (Lua-based)
├── zsh/               # Z Shell configuration and dotfiles
└── [various other app configs]
```

### Key Configuration Files
- `.config/zsh/.zshrc` - Main shell configuration with aliases and paths
- `.config/alacritty/alacritty.toml` - Terminal emulator with Nord color scheme
- `.config/aerospace/aerospace.toml` - Tiling window manager configuration
- `.tmux.conf` - Terminal multiplexer with vim-aware pane switching
- `bootstrap.sh` - Symlink creation for dotfiles
- `install.sh` - Complete system setup automation

### Development Environment Features

**Shell Environment:**
- Custom zsh configuration with Nord theme compatibility
- Extensive aliases for navigation, development tools, and system management
- Path configuration for Go, Ruby, Python, and Node.js development
- Integration with Homebrew, nvm, and various development tools

**Window Management:**
- AeroSpace window manager with i3-like keybindings
- Workspace assignments for different application types (browser, development, terminal, etc.)
- Alt-based keybindings for window focus and movement

**Terminal Setup:**
- Tmux configuration with vim-aware pane navigation
- Custom session management scripts
- Nord color scheme consistency across tools

**Editor Configuration:**
- Neovim setup with Lua configuration (in nvim_rename directory)
- Plugin management and custom keybindings
- Integration with development workflow

### Personal Workflow Integration
The configuration includes personal workspace paths and project shortcuts in tmux configuration, indicating this is a working development environment with specific project integrations.

## Important Notes

- This is a personal dotfiles repository with macOS-specific configurations
- Many paths and configurations are user-specific (`rzachary`)
- The setup assumes a clean macOS installation
- Includes both security/CTF tools and general development tools
- No version control or dependency management for the configs themselves
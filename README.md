# tw_dots

Personal macOS dotfiles and development environment configuration.

## Quick Start

```bash
# Clone the repository
git clone <your-repo-url> ~/tw_dots
cd ~/tw_dots

# Run the installation script
./install.sh

# Create symbolic links for dotfiles
./bootstrap.sh
```

## What's Included

### Development Tools
- **Languages**: Go, Python, TypeScript, Ruby, Node.js
- **Terminal**: zsh with custom configuration, tmux, Neovim
- **Utilities**: fzf, exa, ripgrep, bat, and more
- **Security Tools**: CTF and penetration testing utilities

### Applications
Installs essential development applications via Homebrew Cask including browsers, editors, and productivity tools.

### Configuration Files

| Tool | Location | Description |
|------|----------|-------------|
| Alacritty | `.config/alacritty/` | Terminal emulator with Nord theme |
| AeroSpace | `.config/aerospace/` | i3-like window manager for macOS |
| Neovim | `.config/nvim_rename/` | Lua-based editor configuration |
| Zsh | `.config/zsh/` | Shell configuration with aliases and themes |
| Tmux | `.tmux.conf` | Terminal multiplexer with vim integration |

## Key Features

- **Nord Theme**: Consistent color scheme across terminal, editor, and applications
- **Window Management**: AeroSpace provides i3-like tiling window management
- **Shell Environment**: Custom zsh configuration with extensive aliases and path management
- **Development Workflow**: Integrated setup for multiple programming languages
- **Security Tools**: Collection of CTF and pentesting utilities

## System Requirements

- macOS (designed for Apple Silicon)
- Administrative privileges for system modifications

## Installation Details

The `install.sh` script will:
1. Install Homebrew package manager
2. Install development tools and languages
3. Install applications via Homebrew Cask
4. Apply system preference customizations

The `bootstrap.sh` script creates symbolic links from the repository to your home directory.

## Notes

This is a personal dotfiles repository tailored for a specific development workflow. You may want to review and modify configurations before installation.
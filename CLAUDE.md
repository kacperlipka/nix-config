# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Core Commands

### Deployment and Configuration Management
```bash
# Cross-platform deployment (automatically detects macOS/Linux)
./deploy.sh
# Or remote one-liner:
curl -fsSL https://raw.githubusercontent.com/kacperlipka/nix-config/main/deploy.sh | bash

# Configuration management (use these aliases after deployment)
nix-rebuild    # Rebuild and switch configuration
nix-update     # Update flake dependencies

# Manual system-specific commands (if aliases not available)
# macOS: darwin-rebuild switch --flake ~/.config/nix-config#macos
# Linux: home-manager switch --flake ~/.config/nix-config#linux
```

### Maintenance Commands
```bash
# Validate configuration
nix flake check ~/.config/nix-config

# Clean old generations
nix-collect-garbage -d
# macOS system-wide cleanup:
sudo nix-collect-garbage -d
```

## Architecture Overview

This is a **portable, cross-platform Nix configuration** designed to work identically on macOS and Linux with dynamic user detection. The key architectural principle is **modularity with portability**.

### Configuration Structure
- **`flake.nix`**: Main entry point defining configurations for different platforms and users
- **`deploy.sh`**: Automated deployment script with OS detection and Nix installation
- **`hosts/macos/`**: Darwin-specific system configurations (GUI apps, fonts, system settings)
- **`users/`**: User-specific configurations (git, home directory settings)
- **`home/`**: Home Manager modules organized by function
  - **`packages/`**: Software package definitions (base.nix for core tools)
  - **`shell/`**: Terminal and development environment (bash, neovim, starship, tmux)

### Key Design Patterns

**Dynamic Configuration**: The flake uses helper functions (`mkUserConfig`, `mkDarwinConfig`) to generate configurations dynamically:
- `darwinConfigurations.macos`: Full system integration with nix-darwin + home-manager
- `homeConfigurations.linux*`: Portable user-only configurations for different architectures
- `homeConfigurations.devcontainer*`: Container-specific configurations

**Multi-Architecture Support**: Separate configurations for x86_64 and aarch64 Linux to handle Apple Silicon containers and cross-platform development.

**Modular Package Management**: Base packages defined in `home/packages/base.nix` include development essentials (git, nodejs, claude-code, devpod) and are consistently applied across all environments.

### Platform-Specific Behavior
- **macOS**: Uses nix-darwin for system-level integration (apps, fonts, shell configuration)
- **Linux**: Uses home-manager only for user-space configuration (portable, no system changes)
- **Containers**: Special devcontainer configurations that avoid user/permission conflicts

## Development Environment

### Editor Configuration
- **Neovim with LazyVim**: Configured in `home/shell/neovim.nix` with automatic lazy.nvim bootstrapping
- **Language servers**: nil (Nix), lua-language-server pre-installed
- **Development tools**: ripgrep, fd, fzf, bat, eza for enhanced editor integration

### Shell Environment
- **Bash**: Primary shell with forced UTF-8 locale configuration
- **Starship**: Configured prompt across all environments
- **Tmux**: Terminal multiplexer with consistent configuration
- **Aliases**: Custom `nix-rebuild` and `nix-update` commands defined in `home/shell/default.nix`

### Container Development
- **DevPod integration**: Package included in base.nix
- **Container configurations**: Special user configs (`devcontainer`, `devcontainer-aarch64`) for containerized development
- **Architecture awareness**: Automatic detection and appropriate package selection for ARM/x86 containers

## Important Implementation Details

### Determinate Systems Integration
Uses Determinate Systems Nix installer for improved reliability and performance across platforms.

### Locale Handling
Locale settings are handled in shell configuration rather than system-wide for better portability, with explicit UTF-8 enforcement in `home/shell/bash.nix`.

### Font Management
Nerd Fonts (FiraCode, JetBrains Mono, etc.) are installed both system-wide (macOS) and user-level (Linux/containers) to ensure consistent terminal rendering.

### User Portability
The configuration dynamically detects usernames and adapts home directory paths, making it truly portable across different user accounts and systems.

### Package Management Strategy
- **Unfree packages**: Allowed system-wide on macOS, user-level on Linux
- **Base packages**: Defined once in `base.nix`, applied consistently
- **Specialized packages**: Additional packages in separate modules (git.nix, ui.nix)
- **Development focus**: Emphasizes command-line tools and development environments over GUI applications
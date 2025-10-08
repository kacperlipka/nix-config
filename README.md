# Portable Nix Configuration

Cross-platform, declarative Nix configuration supporting macOS, Linux, and development containers with dynamic user detection.

## Quick Start

**One-command deployment (automatically detects macOS/Linux):**
```bash
curl -fsSL https://raw.githubusercontent.com/kacperlipka/nix-config/main/deploy.sh | bash
```

**Regular management (after deployment):**
```bash
nix-rebuild    # Rebuild and switch configuration
nix-update     # Update flake dependencies
```

## Architecture Overview

This is a **portable, cross-platform Nix configuration** designed for:
- **macOS**: Full system integration with nix-darwin + home-manager
- **Linux**: User-space configuration with home-manager only
- **Containers**: Special devcontainer configurations for cross-platform development

## Project Structure

```
~/.config/nix-config/
├── flake.nix              # Multi-platform configurations and package exports
├── flake.lock             # Locked dependency versions
├── deploy.sh              # Cross-platform deployment with OS detection
├── hosts/                 # Platform-specific system configurations
│   └── macos/             # macOS system settings (nix-darwin)
│       └── default.nix    # System packages, fonts, Nix settings
├── users/                 # User-specific configurations
│   └── kacperlipka.nix    # User profile with dynamic home directory detection
└── home/                  # Home Manager modules
    └── packages/          # Package definitions
        ├── default.nix    # Git configuration and package imports
        ├── base.nix       # Core development packages
        └── devcontainer.nix # Container-specific packages
```

## Platform Configurations

### macOS (darwinConfigurations.macos)
- **Target**: `aarch64-darwin` (Apple Silicon)
- **Integration**: nix-darwin + home-manager for full system management
- **Features**: System packages, fonts, GUI applications, shell configuration

### Linux (homeConfigurations.linux*)
- **Targets**: `x86_64-linux`, `aarch64-linux`
- **Integration**: home-manager only (user-space, no system changes)
- **Features**: Portable development environment without root privileges

### Containers (homeConfigurations.devcontainer*)
- **Targets**: `x86_64-linux`, `aarch64-linux`
- **Integration**: Specialized for container environments
- **Features**: Avoids user/permission conflicts, optimized for DevPod

## Key Features

### Dynamic Configuration
- **Cross-platform package exports**: Packages available for all architectures
- **User detection**: Automatically adapts home directory paths
- **OS-specific optimizations**: Different package sets per platform

### Development Environment
- **Core tools**: git, nodejs, neovim, ripgrep, fzf, bat, eza, claude-code
- **Container support**: DevPod integration for cloud development
- **Language servers**: nil (Nix), lua-language-server for enhanced editing
- **Shell enhancements**: starship prompt, tmux, comprehensive bash configuration

### Package Management
- **Base packages**: Consistent across all platforms (`home/packages/base.nix`)
- **Font management**: Nerd Fonts installed system-wide (macOS) and user-level (Linux)
- **Unfree packages**: Properly configured for GUI applications and development tools

## Deployment

### Automatic (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/kacperlipka/nix-config/main/deploy.sh | bash
```

**What happens:**
1. **OS Detection**: Automatically determines macOS vs Linux
2. **Nix Installation**: Uses Determinate Systems installer for reliability
3. **Configuration Application**: Applies appropriate configuration for your platform
4. **Development Setup**: Installs all development tools and shell configuration

### Manual
```bash
git clone https://github.com/kacperlipka/nix-config.git ~/.config/nix-config
cd ~/.config/nix-config

# macOS
darwin-rebuild switch --flake .#macos

# Linux
home-manager switch --flake .#linux
```

### Container Development
For DevPod or other container environments:
```bash
# Inside container
home-manager switch --flake .#devcontainer
# or for ARM containers
home-manager switch --flake .#devcontainer-aarch64
```

## Package Inventory

### Core Development Tools
- **Version Control**: git, gh (GitHub CLI)
- **Programming**: nodejs_24, claude-code
- **Text Editing**: neovim with LazyVim, language servers (nil, lua-language-server)
- **Search & Navigation**: ripgrep, fd, fzf, bat, eza, tree
- **Container Development**: devpod for cloud-native development

### System Utilities
- **Network**: curl, wget, nmap, netcat
- **Monitoring**: htop, btop, neofetch
- **Compression**: zip, unzip
- **Shell**: bash (with starship prompt), tmux
- **Build Tools**: gnumake

### macOS-Specific
- **GUI Applications**: alacritty (terminal), rectangle (window management)
- **System Integration**: Full nix-darwin integration
- **Font Management**: System-wide Nerd Font installation

### Git Configuration
Pre-configured with:
- User credentials and sensible defaults
- Useful aliases (st, co, br, ci, lg, etc.)
- Neovim as default editor
- Enhanced diff and merge tools

## Architecture Benefits

### Portability
- **User-agnostic**: Dynamically detects usernames and home directories
- **Platform-aware**: Different optimizations for macOS, Linux, and containers
- **No root required**: Linux configurations work in user-space only

### Maintainability
- **Modular design**: Packages organized by function and platform
- **Consistent patterns**: Same base packages across all environments
- **Single source of truth**: All configuration managed declaratively

### Development Focus
- **Modern tooling**: Includes latest development tools and editors
- **Container-ready**: Special configurations for DevPod and containerized development
- **Language support**: Pre-configured language servers and development environment

## Daily Usage

### After Installation
All commands available in your shell:
```bash
nix-rebuild    # Rebuild and switch configuration
nix-update     # Update flake dependencies
```

### Maintenance Commands
```bash
# Validate configuration
nix flake check ~/.config/nix-config

# Clean old generations
nix-collect-garbage -d
# macOS system-wide cleanup:
sudo nix-collect-garbage -d

# Update dependencies and rebuild
nix-update && nix-rebuild
```

### Development Workflow
- **Neovim**: Pre-configured with LazyVim for immediate productivity
- **Shell**: Enhanced with starship prompt, useful aliases, UTF-8 locale
- **Git**: Ready to use with sensible defaults and helpful aliases
- **Containers**: DevPod integration for cloud development environments

## Customization

To modify this configuration for your use:

1. **Fork the repository**
2. **Update user configuration** in `users/kacperlipka.nix`:
   - Change username, email, and home directory
3. **Modify packages** in `home/packages/base.nix`:
   - Add or remove development tools as needed
4. **Adjust system settings** in `hosts/macos/default.nix`:
   - Customize GUI applications and system preferences
5. **Deploy your changes**:
   ```bash
   git clone https://github.com/yourusername/nix-config.git ~/.config/nix-config
   cd ~/.config/nix-config
   nix-rebuild
   ```
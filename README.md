# Portable Nix Configuration

Cross-platform, declarative Nix configuration for macOS with parametrized user support.

## Quick Start

**One-command deployment (macOS only):**
```bash
curl -fsSL https://raw.githubusercontent.com/kacperlipka/nix-config/main/deploy.sh | bash
```

**Regular management (after deployment):**
```bash
nix-rebuild    # Rebuild and switch configuration
nix-update     # Update flake dependencies
```

## Architecture Overview

This is a **parametrized Nix configuration** designed for:
- **macOS**: Full system integration with nix-darwin + home-manager
- **User-agnostic**: Easily customizable for different users via parameter changes

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
│   ├── mkUser.nix         # Parametrized user configuration function
│   └── kacperlipka.nix    # Legacy user profile (can be removed)
└── home/                  # Home Manager modules
    └── packages/          # Package definitions
        ├── default.nix    # Git configuration and package imports
        └── base.nix       # Core development packages
```

## Configuration

### macOS (darwinConfigurations.macos)
- **Target**: `aarch64-darwin` (Apple Silicon)
- **Integration**: nix-darwin + home-manager for full system management
- **Features**: System packages, fonts, GUI applications, shell configuration
- **User Support**: Parametrized username and email configuration

## Key Features

### Parametrized Configuration
- **User-agnostic**: Username and email configurable via parameters
- **Dynamic paths**: Automatically adapts home directory paths for any user
- **Reusable**: Easy to fork and customize for different users

### Development Environment
- **Core tools**: git, nodejs, neovim, ripgrep, fzf, bat, eza, claude-code
- **Language servers**: nil (Nix), lua-language-server for enhanced editing
- **Shell enhancements**: starship prompt, tmux, comprehensive bash configuration

### Package Management
- **Base packages**: Consistent development tools (`home/packages/base.nix`)
- **Font management**: Nerd Fonts installed system-wide
- **Unfree packages**: Properly configured for GUI applications and development tools

## Deployment

### Automatic (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/kacperlipka/nix-config/main/deploy.sh | bash
```

**What happens:**
1. **OS Detection**: Verifies macOS environment
2. **Nix Installation**: Uses Determinate Systems installer for reliability
3. **Configuration Application**: Full system integration with nix-darwin + home-manager
4. **Development Setup**: Installs all development tools and shell configuration

### Manual
```bash
git clone https://github.com/kacperlipka/nix-config.git ~/.config/nix-config
cd ~/.config/nix-config

# macOS
darwin-rebuild switch --flake .#macos
```

## Package Inventory

### Core Development Tools
- **Version Control**: git, gh (GitHub CLI)
- **Programming**: nodejs_24, claude-code
- **Text Editing**: neovim with LazyVim, language servers (nil, lua-language-server)
- **Search & Navigation**: ripgrep, fd, fzf, bat, eza

### System Utilities
- **Network**: curl, wget, nmap, netcat
- **Shell**: bash (with starship prompt), tmux
- **Utilities**: tree

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

## Customization

To modify this configuration for your use:

### Option 1: Quick Parameter Change
1. **Fork the repository**
2. **Update user parameters** in `flake.nix`:
   ```nix
   let
     # User configuration - CHANGE THESE
     username = "yourusername";
     email = "your.email@example.com";
   ```
3. **Deploy your changes**:
   ```bash
   git clone https://github.com/yourusername/nix-config.git ~/.config/nix-config
   cd ~/.config/nix-config
   nix-rebuild
   ```

### Option 2: Multiple Users
Create different configurations in `flake.nix`:
```nix
darwinConfigurations = {
  "user1-macos" = darwinSystem {
    # ... with user1 parameters
  };
  "user2-macos" = darwinSystem {
    # ... with user2 parameters
  };
};
```

### Additional Customization
- **Modify packages** in `home/packages/base.nix`: Add or remove development tools
- **Adjust system settings** in `hosts/macos/default.nix`: Customize GUI applications and system preferences
- **Update git configuration** in `users/mkUser.nix`: Modify git settings and aliases
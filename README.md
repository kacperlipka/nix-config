# Portable Nix Configuration

Portable Nix configuration for macOS and Linux systems using nix-darwin and home-manager.

## Structure

```
~/.config/nix-config/
├── flake.nix            # Main entry point - defines configurations
├── flake.lock           # Locked dependency versions
├── deploy.sh            # Cross-platform deployment script for macOS and Linux
├── hosts/               # Host-specific system configurations
│   └── macos/           # macOS system settings (nix-darwin)
│       └── default.nix  # System packages, fonts, Nix settings
├── users/               # User-specific configurations
│   └── kacperlipka.nix  # User profile (git, home directory)
└── home/                # Home Manager modules
    ├── packages/        # Package definitions
    │   ├── default.nix  # Imports other package modules
    │   ├── base.nix     # Base packages for all systems
    │   └── git.nix      # Git-specific package configuration
    └── shell/           # Shell and terminal configurations
        ├── default.nix  # Imports all shell modules + locale settings
        ├── bash.nix     # Bash configuration
        ├── tmux.nix     # Terminal multiplexer settings
        ├── starship.nix # Shell prompt configuration
        ├── neovim.nix   # Text editor configuration
        └── alacritty.nix# Terminal emulator settings
```

## Key Components

### flake.nix
The main configuration file that defines:
- Input sources (nixpkgs, home-manager, nix-darwin)
- Generic configurations that work with any user:
  - `macos`: macOS with nix-darwin + home-manager (dynamic user detection)
  - `linux`: Linux with home-manager only (portable, dynamic user detection)
- Backward compatibility configurations:
  - `macbook-kacperlipka`: Legacy macOS configuration
  - `kacperlipka@ubuntu`: Legacy Linux configuration

### Portable Design
- **No system-specific dependencies**: Ubuntu config uses only home-manager
- **Locale settings in shell**: Moved from system to user environment
- **No hostname management**: Removed for better portability
- **Dynamic user detection**: Automatically adapts to any username
- **Single user configuration**: Same user config works across all systems and users

### home/
Home Manager modules organized by function:
- **packages/**: Software packages and applications
- **shell/**: Terminal, shell, development tools, and locale settings

## Usage

### macOS Setup

**Initial Setup (first time):**
```bash
# Install nix-darwin (one-time setup)
nix run nix-darwin -- switch --flake ~/.config/nix-config#macos
```

**Regular Operations:**
```bash
# Rebuild system
sudo darwin-rebuild switch --flake ~/.config/nix-config#macos

# Update dependencies
cd ~/.config/nix-config
nix flake update
sudo darwin-rebuild switch --flake .#macos
```

### Cross-Platform Deployment (macOS and Linux)

**One-command deployment (works on both macOS and Linux):**
```bash
# Download and run the cross-platform deployment script
curl -fsSL https://raw.githubusercontent.com/yourusername/your-repo/main/deploy.sh | bash
```

**Manual deployment:**
```bash
# Clone this repository
git clone https://github.com/kacperlipka/nix-config.git ~/.config/nix-config
cd ~/.config/nix-config

# Run deployment script (auto-detects OS)
./deploy.sh
```

**What the deployment script does:**
- **Detects your operating system** (macOS or Linux)
- **Installs Nix** using the reliable Determinate Systems installer
- **Configures Nix** with flakes and Determinate enhancements
- **Deploys appropriate configuration**:
  - macOS: nix-darwin + home-manager (full system integration)
  - Linux: home-manager only (portable, no system changes)

**Installation Details:**
- **macOS**: Uses multi-user installation (recommended and secure)
- **Linux**: Uses multi-user installation (more reliable than single-user)
- **No sudo required** during configuration deployment
- **Safe and reversible** with built-in uninstallation support

**Regular Operations (All Systems):**
```bash
# Use the convenient aliases (available after deployment):
nix-rebuild  # Rebuild and switch configuration
nix-update   # Update flake dependencies

# Or use full commands:
# macOS: darwin-rebuild switch --flake ~/.config/nix-config#macos
# Linux: home-manager switch --flake ~/.config/nix-config#linux
```

### Common Operations (All Systems)

**Check configuration:**
```bash
nix flake check ~/.config/nix-config
```

**Clean old generations:**
```bash
# macOS (system-wide)
sudo nix-collect-garbage -d

# All systems (user profiles)
nix-collect-garbage -d
```

## Configuration Details

### System Packages (macOS only)
- **Applications**: alacritty, rectangle
- **Fonts**: Multiple Nerd Fonts (FiraCode, JetBrains Mono, etc.)
- **Shell**: bash as default shell

### Home Manager Features (All Systems)
- **Development tools**: git, gh, nodejs, claude-code, neovim
- **Shell tools**: ripgrep, fd, fzf, bat, eza, starship, tmux
- **System utilities**: htop, btop, curl, wget, tree, nmap
- **Git**: Configured with user credentials
- **Shell aliases**: Common shortcuts and nix-specific commands
- **Locale settings**: UTF-8 configured in shell environment
- **Cross-platform**: Same user config works on macOS and Linux

### Nix Settings
- Flakes and nix-command enabled
- Unfree packages allowed (macOS system-wide, Linux user-only)
- Determinate Systems enhancements for better performance and reliability

### Cross-Platform Benefits
- **Universal deployment**: One script works on macOS and Linux
- **Reliable installer**: Uses Determinate Systems' battle-tested installer
- **Appropriate for each OS**: Multi-user on both platforms for better reliability
- **No system interference**: Linux config uses home-manager only
- **Instant setup**: One command deployment with all your tools
- **Consistent environment**: Same shell, tools, and configs everywhere
- **Easy cleanup**: Built-in uninstallation support (`/nix/nix-installer uninstall`)
- **Production ready**: Used by thousands of developers daily
# macOS Nix Configuration

Simple, declarative Nix configuration for macOS using nix-darwin with portable devcontainer support.

## Structure

```
~/.config/nix-config/
├── flake.nix            # Main entry point - Darwin-only configuration
├── flake.lock           # Locked dependency versions
├── deploy.sh            # Simplified macOS deployment script
├── .devcontainer/       # Portable devcontainer configuration
│   ├── devcontainer.json# VS Code devcontainer settings
│   ├── devcontainer.nix # Declarative Nix environment with dotfiles
│   └── setup.sh         # Devcontainer initialization script
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
Simple Darwin-only configuration that defines:
- Input sources (nixpkgs, home-manager, nix-darwin)
- Single `macos` configuration using nix-darwin + home-manager
- No helper functions - straightforward and maintainable

### .devcontainer/
Portable development environment for any machine:
- **devcontainer.nix**: Declarative Nix shell with same packages as main config
- **Dotfiles managed by Nix**: Neovim (LazyVim), tmux, starship, bash configs
- **Complete portability**: Works on any machine with Nix support
- **No manual setup**: Everything configured declaratively

### home/
Home Manager modules organized by function:
- **packages/**: Software packages shared between macOS and devcontainer
- **shell/**: Terminal, shell, development tools, and locale settings

## Usage

### macOS Deployment

**One-command deployment:**
```bash
curl -fsSL https://raw.githubusercontent.com/kacperlipka/nix-config/main/deploy.sh | bash
```

**Manual deployment:**
```bash
git clone https://github.com/kacperlipka/nix-config.git ~/.config/nix-config
cd ~/.config/nix-config
./deploy.sh
```

**What the deployment script does:**
- **Installs Nix** using the reliable Determinate Systems installer
- **Configures nix-darwin** with home-manager integration
- **Sets up your entire development environment** automatically

**Regular Operations (after deployment):**
```bash
# Use the convenient aliases (available in your shell):
nix-rebuild  # Rebuild and switch configuration
nix-update   # Update flake dependencies

# Or use full command:
# darwin-rebuild switch --flake ~/.config/nix-config#macos
```

### Devcontainer Development

**Use with DevPod (recommended):**
```bash
# Install devpod (if not already installed)
# macOS: brew install devpod
# Or download from: https://devpod.sh

# Launch devcontainer from this repository
devpod up https://github.com/kacperlipka/nix-config --ide none

# SSH into the development environment
ssh nix-config.devpod

# Enter the declarative Nix environment
cd /workspaces/nix-config
nix-shell .devcontainer/devcontainer.nix
```

**Use with VS Code:**
1. Clone this repository
2. Open in VS Code
3. Click "Reopen in Container" when prompted
4. VS Code will build and start the devcontainer automatically

**What you get in the devcontainer:**
- **Same packages** as the main macOS configuration
- **Neovim with LazyVim** (automatically bootstrapped)
- **Configured dotfiles**: tmux, starship, bash (managed by Nix)
- **Development tools**: git, gh, nodejs, ripgrep, fd, fzf, bat, eza
- **Language servers**: nil (Nix), lua-language-server
- **Completely portable** - works on any machine with Nix support

## Configuration Details

### macOS System Packages
- **Applications**: alacritty, rectangle
- **Fonts**: Multiple Nerd Fonts (FiraCode, JetBrains Mono, etc.)
- **Shell**: bash as default shell

### Development Environment (macOS + Devcontainer)
- **Development tools**: git, gh, nodejs, neovim, ripgrep, fd, fzf, bat, eza
- **Shell tools**: starship, tmux, htop, btop, curl, wget, tree, nmap
- **Language servers**: nil (Nix), lua-language-server
- **Build tools**: gnumake
- **Git**: Configured with user credentials
- **Shell aliases**: Common shortcuts and nix-specific commands
- **Locale settings**: UTF-8 configured in shell environment

### Nix Settings
- Flakes and nix-command enabled
- Unfree packages allowed
- Determinate Systems enhancements for better performance and reliability

### Key Benefits
- **Simple architecture**: Darwin-only, no complex helper functions
- **Declarative dotfiles**: All configurations managed by Nix
- **Portable development**: Identical environment in devcontainers
- **Zero manual setup**: Everything configured automatically
- **Easy maintenance**: Straightforward, readable configuration
- **Container friendly**: Perfect for remote development and CI/CD

## Maintenance

```bash
# Check configuration
nix flake check ~/.config/nix-config

# Clean old generations
nix-collect-garbage -d
sudo nix-collect-garbage -d  # macOS system-wide cleanup

# Update and rebuild
nix-update && nix-rebuild
```
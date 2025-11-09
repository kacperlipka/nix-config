# Nix Configuration

Declarative Nix configuration for macOS using nix-darwin and home-manager.

## Quick Start

```bash
# Clone repository
git clone https://github.com/kacperlipka/nix-config.git ~/.config/nix-config
cd ~/.config/nix-config

# Run deployment
./bootstrap.sh
```

## System Requirements

- macOS (Apple Silicon - aarch64-darwin)
- Nix (installed automatically via Determinate Systems installer)

## Architecture

### Components

- **nix-darwin**: System-level macOS integration
- **home-manager**: User environment and dotfile management
- **nixpkgs**: Package source (nixos-unstable channel)

### Directory Structure

```
.
├── flake.nix              # Flake configuration with inputs and outputs
├── flake.lock             # Locked dependency versions
├── bootstrap.sh           # Automated deployment script
├── hosts/
│   └── macos/
│       └── default.nix    # System configuration (fonts, environment, packages)
├── users/
│   └── mkUser.nix         # User configuration factory function
└── home/
    └── packages/
        ├── default.nix    # Git configuration and package imports
        └── base.nix       # Package list
```

## Configuration Details

### User Parameters

Configured in `flake.nix`:

- Username: `kacperlipka`
- Email: `kacper.lipka.02@gmail.com`

### System Configuration

Defined in `hosts/macos/default.nix`:

- Default shell: Bash with completion
- Locale: en_US.UTF-8
- GUI applications: Alacritty, Rectangle
- Experimental Nix features: flakes, nix-command
- Unfree packages: Enabled

### Installed Packages

Core utilities:

- curl, wget, unzip, zip, tree, htop, btop

Cloud and infrastructure:

- azure-cli, kubectl, kubectx, kubernetes-helm, terraform, argocd, kubecolor, ansible

Development tools:

- git, gh, jq, yq, nodejs_24, claude-code, devpod, lazygit, pyenv

Text editors and search:

- neovim, ripgrep, fd, fzf, bat, eza

Rust toolchain:

- rustc, cargo

Shell enhancements:

- starship, tmux

## Deployment

### Automatic

```bash
./bootstrap.sh
```

The script performs the following:

1. Installs Nix using Determinate Systems installer (if not present)
2. Applies darwin configuration using `darwin-rebuild switch --flake ".#macos"`

### Manual

```bash
# With darwin-rebuild available
darwin-rebuild switch --flake ~/.config/nix-config#macos

# Without darwin-rebuild
nix run nix-darwin -- switch --flake ~/.config/nix-config#macos
```

## Maintenance

```bash
# Update flake inputs
nix flake update ~/.config/nix-config

# Rebuild system
darwin-rebuild switch --flake ~/.config/nix-config#macos

# Validate configuration
nix flake check ~/.config/nix-config

# Garbage collection
nix-collect-garbage -d
sudo nix-collect-garbage -d
```

## Customization

### Modify User Parameters

Edit `flake.nix`:

```nix
let
  username = "your-username";
  email = "your-email@example.com";
in
```

### Add Packages

Edit `home/packages/base.nix` and add package names to the list.

### Modify System Settings

Edit `hosts/macos/default.nix` to change system packages, fonts, or environment variables.

### Update Git Configuration

Edit `home/packages/default.nix` to modify git aliases and settings.

## Nix Flake Inputs

- nixpkgs: `github:NixOS/nixpkgs/nixos-unstable`
- home-manager: `github:nix-community/home-manager`
- nix-darwin: `github:LnL7/nix-darwin`

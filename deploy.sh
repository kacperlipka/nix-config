#!/bin/bash
set -e

CONFIG_DIR="$HOME/.config/nix-config"

# Install Nix if not present
if ! command -v nix &> /dev/null; then
    echo "Installing Nix..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate
    source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# Clone/update config
if [ -d "$CONFIG_DIR" ]; then
    cd "$CONFIG_DIR" && git pull
else
    git clone "https://github.com/kacperlipka/nix-config.git" "$CONFIG_DIR"
    cd "$CONFIG_DIR"
fi

# Apply configuration based on platform
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - use nix-darwin
    if command -v darwin-rebuild &> /dev/null; then
        darwin-rebuild switch --flake ".#macos"
    else
        nix run nix-darwin -- switch --flake ".#macos"
    fi
else
    # Linux - use home-manager
    # Detect architecture for correct configuration
    if [[ $(uname -m) == "aarch64" ]]; then
        CONFIG="linux-aarch64"
    else
        CONFIG="linux"
    fi

    echo "Applying home-manager configuration for Linux..."
    if command -v home-manager &> /dev/null; then
        home-manager switch --flake ".#${CONFIG}"
    else
        nix run home-manager -- switch --flake ".#${CONFIG}"
    fi
fi

echo "Configuration applied! Restart your terminal."
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

# Apply configuration
if command -v darwin-rebuild &> /dev/null; then
    darwin-rebuild switch --flake ".#macos"
else
    nix run nix-darwin -- switch --flake ".#macos"
fi

echo "Configuration applied! Restart your terminal."
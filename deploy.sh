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
    # Linux - use nix-env for simple package installation
    # Detect architecture for correct configuration
    if [[ $(uname -m) == "aarch64" ]]; then
        ARCH="aarch64"
    else
        ARCH="x86_64"
    fi

    echo "Installing packages for Linux ${ARCH}..."
    nix-env -iA "packages.${ARCH}-linux.base" -f .
fi

echo "Configuration applied! Restart your terminal."
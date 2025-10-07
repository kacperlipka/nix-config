#!/bin/bash
set -e

echo "Setting up declarative Nix development environment..."

# Clone the nix-config repository
CONFIG_DIR="$HOME/.config/nix-config"
REPO_URL="https://github.com/kacperlipka/nix-config.git"

if [ ! -d "$CONFIG_DIR" ]; then
    echo "Cloning nix-config repository..."
    git clone "$REPO_URL" "$CONFIG_DIR"
else
    echo "Updating nix-config repository..."
    cd "$CONFIG_DIR" && git pull
fi

cd "$CONFIG_DIR"

echo "Entering declarative Nix development environment..."
echo "All dotfiles and configurations will be managed by Nix"

# Enter the Nix shell which will handle all configuration declaratively
exec nix-shell .devcontainer/devcontainer.nix
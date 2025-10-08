#!/bin/bash
set -e

CONFIG_DIR="$HOME/.config/nix-config"

# Install Nix if not present
if ! command -v nix &>/dev/null; then
  echo "Installing Nix..."
  curl -fsSL https://install.determinate.systems/nix | sh -s -- install
  source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# Apply configuration
if [[ "$OSTYPE" == "darwin"* ]]; then
  if command -v darwin-rebuild &>/dev/null; then
    darwin-rebuild switch --flake ".#macos"
  else
    nix run nix-darwin -- switch --flake ".#macos"
  fi
else
  echo "Unsupported platform"
  exit 1
fi

echo "Configuration applied! Restart your terminal."

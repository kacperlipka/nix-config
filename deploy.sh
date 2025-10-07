#!/bin/bash
set -e

# Cross-platform portable deployment script for macOS and Linux
# This script installs Nix using Determinate Systems installer and deploys the configuration

REPO_URL="https://github.com/kacperlipka/nix-config.git"  # Update this to your actual repo URL
CONFIG_DIR="$HOME/.config/nix-config"

echo "🚀 Starting cross-platform Nix deployment..."

# Detect operating system
if [[ "$OSTYPE" == "darwin"* ]]; then
    SYSTEM="macos"
    CONFIG_NAME="macos"
    echo "🍎 Detected macOS"
    echo "👤 Current user: $USER"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    SYSTEM="linux"
    CONFIG_NAME="linux"
    echo "🐧 Detected Linux"
    echo "👤 Current user: $USER"
else
    echo "❌ Error: Unsupported operating system: $OSTYPE"
    echo "This script supports macOS and Linux only."
    exit 1
fi

# Check if Nix is already installed
if command -v nix &> /dev/null; then
    echo "✅ Nix is already installed"
else
    echo "📦 Installing Nix using Determinate Systems installer..."

    if [[ "$SYSTEM" == "macos" ]]; then
        echo "ℹ️  Note: On macOS, this will install Nix in multi-user mode (recommended)"
        echo "ℹ️  Single-user mode on macOS is complex and not recommended by Nix maintainers"
        echo "ℹ️  The multi-user installation is secure and won't interfere with your workflow"

        # Install Determinate Nix on macOS (multi-user, but user-friendly)
        curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate

        # Source nix environment for current session
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
            source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi

    elif [[ "$SYSTEM" == "linux" ]]; then
        echo "🔧 Installing Nix in multi-user mode (recommended for reliability)"

        # Install Determinate Nix on Linux (multi-user by default, but can be single-user)
        curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate

        # Source nix environment for current session
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
            source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        elif [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
            source "$HOME/.nix-profile/etc/profile.d/nix.sh"
        fi
    fi

    echo "✅ Nix installed successfully"
fi

# Ensure nix command is available
if ! command -v nix &> /dev/null; then
    echo "🔄 Sourcing Nix environment..."

    # Try different possible locations for nix environment
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    elif [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        source "$HOME/.nix-profile/etc/profile.d/nix.sh"
    else
        echo "❌ Error: Cannot find Nix installation"
        echo "💡 Try opening a new terminal session and running this script again"
        exit 1
    fi
fi

# Verify nix is working
if ! command -v nix &> /dev/null; then
    echo "❌ Error: Nix command not available after installation"
    echo "💡 Please open a new terminal session and run this script again"
    exit 1
fi

# Clone or update configuration
if [ -d "$CONFIG_DIR" ]; then
    echo "🔄 Updating existing configuration..."
    cd "$CONFIG_DIR"
    git pull
else
    echo "📥 Cloning configuration..."
    git clone "$REPO_URL" "$CONFIG_DIR"
    cd "$CONFIG_DIR"
fi

echo "🏗️  Building configuration for $SYSTEM..."

# Apply configuration based on system
if [[ "$SYSTEM" == "macos" ]]; then
    echo "🍎 Applying macOS configuration with nix-darwin..."

    # Check if nix-darwin is already installed
    if command -v darwin-rebuild &> /dev/null; then
        echo "✅ nix-darwin already installed, applying configuration..."
        darwin-rebuild switch --flake ".#$CONFIG_NAME"
    else
        echo "📦 Installing nix-darwin and applying configuration..."
        nix run nix-darwin -- switch --flake ".#$CONFIG_NAME"
    fi

elif [[ "$SYSTEM" == "linux" ]]; then
    echo "🐧 Applying Linux configuration with home-manager..."

    # Install and apply home-manager configuration
    nix run nixpkgs#home-manager -- switch --flake ".#$CONFIG_NAME"
fi

echo "✅ Configuration applied successfully!"
echo ""
echo "🎉 Setup complete! Your environment is now configured."

if [[ "$SYSTEM" == "linux" ]]; then
    echo "💡 Run 'source ~/.bashrc' or start a new shell session to activate all changes."
else
    echo "💡 Restart your terminal or start a new shell session to activate all changes."
fi

echo ""
echo "📝 Available commands:"
if [[ "$SYSTEM" == "macos" ]]; then
    echo "   darwin-rebuild switch --flake ~/.config/nix-config#$CONFIG_NAME  - Rebuild system"
else
    echo "   home-manager switch --flake ~/.config/nix-config#$CONFIG_NAME   - Rebuild config"
fi
echo "   nix-rebuild  - Rebuild and switch configuration (alias)"
echo "   nix-update   - Update flake dependencies (alias)"
echo ""
echo "🔄 To update configuration in the future, simply run this script again."
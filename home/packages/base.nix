{ config, pkgs, lib, ... }:

{
  # Base packages for all environments (headless and UI)
  home.packages = with pkgs; [
    # Core utilities
    curl
    wget
    unzip
    zip
    tree
    htop
    btop

    # Development tools
    git
    gh # GitHub CLI
    jq
    yq
    nodejs_24
    claude-code

    # Text editors and tools
    ripgrep
    fd
    fzf
    bat
    eza # modern ls replacement

    # Network tools
    nmap
    netcat

    # System monitoring
    neofetch

    # Language servers for Neovim
    nil # Nix language server
    lua-language-server

    # Build tools
    gnumake

    # Shell enhancements (these will be configured via home-manager)
    starship
    tmux

    # Fonts for terminal applications (available in headless)
    # These fonts will be available to terminal apps like neovim even without GUI
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.sauce-code-pro
    nerd-fonts.droid-sans-mono
    nerd-fonts.hack
    nerd-fonts.ubuntu
  ];

  # Font configuration for headless environments
  fonts.fontconfig.enable = true;
}
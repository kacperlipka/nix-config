{ config, pkgs, lib, ... }:

{
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
  ];
}

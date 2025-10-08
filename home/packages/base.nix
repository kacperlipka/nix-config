{ pkgs }:

with pkgs; [
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
  gh
  jq
  yq
  nodejs_24
  claude-code
  devpod

  # Text editors and tools
  neovim
  ripgrep
  fd
  fzf
  bat
  eza

  # Network tools
  nmap
  netcat

  # System monitoring
  neofetch

  # Language servers for Neovim
  nil
  lua-language-server

  # Build tools
  gnumake

  # Shell enhancements
  starship
  tmux
]
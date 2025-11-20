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
  # azure-cli # Install azure-cli with homebrew because of the extensions installation issues
  # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # brew install azure-cli
  kubectl
  kubectx
  kubernetes-helm
  terraform
  argocd
  kubecolor
  lazygit
  ansible
  pyenv

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

  # Rust toolchain
  rustc
  cargo

  # Shell enhancements
  starship
  tmux
]

{ config, pkgs, lib, ... }:

{
  imports = [
    ./bash.nix
    ./tmux.nix
    ./starship.nix
    ./neovim.nix
    ./alacritty.nix
  ];

  # Locale settings - force English for all applications
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_MESSAGES = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_COLLATE = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
    # Additional language settings
    LANGUAGE = "en_US:en";
  };

  # Common shell aliases that work across all shells
  home.shellAliases = {
    ll = "ls -alF";
    la = "ls -A";
    l = "ls -CF";
    grep = "grep --color=auto";
    fgrep = "fgrep --color=auto";
    egrep = "egrep --color=auto";

    # Nix-specific aliases
    nix-rebuild = if pkgs.stdenv.isDarwin then "darwin-rebuild switch --flake" else "home-manager switch --flake";
    nix-update = "nix flake update";
  };
}

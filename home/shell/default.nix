{ config, pkgs, lib, ... }:

{
  imports = [
    ./bash.nix
    ./tmux.nix
    ./starship.nix
    ./neovim.nix
    ./alacritty.nix
  ];

  # Locale settings (portable across systems)
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
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

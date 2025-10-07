{ config, pkgs, lib, inputs, ... }:

let
  # Get the current user dynamically
  currentUser = builtins.getEnv "USER";
  # Fallback to a default if USER env var is not set
  username = if currentUser != "" then currentUser else "user";
in
{
  # System-level configuration for macOS
  system.stateVersion = 5;

  # Dynamic user account - creates user entry for whoever is running this
  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.bashInteractive;
  };

  environment.shells = [ pkgs.bashInteractive ];

  fonts = {
    packages = with pkgs; [
      # nerdfonts
      # https://github.com/NixOS/nixpkgs/blob/nixos-unstable-small/pkgs/data/fonts/nerd-fonts/manifests/fonts.json
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.sauce-code-pro
      nerd-fonts.ubuntu
    ];
  };

  environment.systemPackages = with pkgs; [
    alacritty
    rectangle
  ];

  # link apps to ~/Applications
  environment.pathsToLink = [ "/Applications" ];

  # Nix configuration - trust the current user dynamically
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" username ];
    };
  };

  nixpkgs.config.allowUnfree = true;
}

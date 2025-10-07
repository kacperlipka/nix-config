{ config, pkgs, lib, inputs, ... }:

{
  # System-level configuration for macOS
  system.stateVersion = 5;

  # User account for kacperlipka
  users.users.kacperlipka = {
    home = "/Users/kacperlipka";
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

  # Nix configuration
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "kacperlipka" ];
    };
  };

  nixpkgs.config.allowUnfree = true;
}

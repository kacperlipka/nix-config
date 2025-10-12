{ config, pkgs, lib, inputs, username, ... }:

{
  # System-level configuration for macOS
  system.stateVersion = 5;

  # User account
  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.bashInteractive;
  };

  environment.shells = [ pkgs.bashInteractive ];
  
  programs.bash = {
    enable = true;
    completion.enable= true;
  };

  # System-level locale settings
  environment.variables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_MESSAGES = "en_US.UTF-8";
    LANGUAGE = "en_US.UTF-8:en_US:en";
  };

  fonts = {
    packages = with pkgs; [
      # nerdfonts
      # https://github.com/NixOS/nixpkgs/blob/nixos-unstable-small/pkgs/data/fonts/nerd-fonts/manifests/fonts.json
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.sauce-code-pro
      nerd-fonts.droid-sans-mono
      nerd-fonts.hack
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
      trusted-users = [ "root" username ];
    };
  };

  nixpkgs.config.allowUnfree = true;
}

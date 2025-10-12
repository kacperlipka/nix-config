{ username, email }:
{ config, pkgs, lib, ... }:

{
  imports = [
    ../home/packages/default.nix
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = username;
    userEmail = email;
  };

  # Home Manager configuration
  home = {
    username = username;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
    stateVersion = "24.05"; # Please read the comment before changing
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
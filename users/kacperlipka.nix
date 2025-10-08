{ config, pkgs, lib, ... }:

{
  imports = [
    ../home/packages
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = "kacperlipka";
    userEmail = "kacper.lipka.02@gmail.com";
  };

  # Home Manager configuration
  home = {
    username = "kacperlipka";
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/kacperlipka" else "/home/kacperlipka";
    stateVersion = "24.05"; # Please read the comment before changing
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}

{ config, pkgs, lib, ... }:

let
  # Get the current user dynamically
  currentUser = builtins.getEnv "USER";
  # Fallback to a default if USER env var is not set
  username = if currentUser != "" then currentUser else "user";
in
{
  imports = [
    ../home/shell
    ../home/packages
  ];

  # Git configuration - keep your identity
  programs.git = {
    enable = true;
    userName = "kacperlipka";
    userEmail = "kacper.lipka.02@gmail.com";
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage - adapt to current user
  home = {
    username = username;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
    stateVersion = "24.05"; # Please read the comment before changing
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}

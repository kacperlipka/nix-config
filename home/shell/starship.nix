{ config, pkgs, lib, ... }:

{
  programs.starship = {
    enable = true;
    enableBashIntegration = true; # use bash instead of zsh
  };
}

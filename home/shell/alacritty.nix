  
{ config, pkgs, lib, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "JetBrainsMonoNL Nerd Font Mono";
          style  = "Regular";
        };
      };
    };
  };
}

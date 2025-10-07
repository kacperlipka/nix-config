{ config, pkgs, lib, ... }:

{
  imports = [
    ./git.nix
    ./base.nix
  ];
}

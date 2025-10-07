{ config, pkgs, lib, ... }:

{
  # UI-specific packages (desktop applications)
  home.packages = with pkgs; [
    # Terminal emulator
    alacritty

    # Docker Desktop (on macOS) or Docker Engine (on Linux)
    docker
    docker-compose
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    # macOS-specific GUI applications
    rectangle # Window management
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    # Linux-specific GUI applications
    # Add Linux GUI apps here as needed
  ];

  # Docker configuration
  programs.docker = {
    enable = true;
  };
}
{ config, pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;

    # Add locale settings to bashrc to ensure they're loaded
    bashrcExtra = ''
      # Force English locale for all applications
      export LANG="en_US.UTF-8"
      export LC_ALL="en_US.UTF-8"
      export LC_MESSAGES="en_US.UTF-8"
      export LC_CTYPE="en_US.UTF-8"
      export LC_COLLATE="en_US.UTF-8"
      export LC_MONETARY="en_US.UTF-8"
      export LC_NUMERIC="en_US.UTF-8"
      export LC_TIME="en_US.UTF-8"
      export LANGUAGE="en_US:en"

      # Override macOS system locale
      export LANG_BACKUP=$LANG
      unset LC_CTYPE 2>/dev/null || true
      export LC_CTYPE="en_US.UTF-8"

      # Force English for system messages
      export LANGUAGE="en_US.UTF-8:en_US:en"
    '';
  };
}

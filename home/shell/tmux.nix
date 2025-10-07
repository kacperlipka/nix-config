{ config, pkgs, lib, ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    historyLimit = 100000;
    prefix = "C-a";
    
    extraConfig = ''
      # Basic settings
      set -g mouse on
      set -g base-index 1
      setw -g pane-base-index 1
      
      # Key bindings
      bind-key v split-window -h
      bind-key s split-window -v
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R
      
      # Resize panes
      bind-key -r H resize-pane -L 5
      bind-key -r J resize-pane -D 5
      bind-key -r K resize-pane -U 5
      bind-key -r L resize-pane -R 5
      
      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"
    '';
  };
}

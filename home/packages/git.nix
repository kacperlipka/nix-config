{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
      pull.rebase = false;
      push.default = "simple";
      
      # Better diffs
      diff.tool = "vimdiff";
      merge.tool = "vimdiff";
      
      # Useful aliases
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        df = "diff";
        lg = "log --oneline --graph --decorate --all";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        visual = "!gitk";
      };
    };
  };
}

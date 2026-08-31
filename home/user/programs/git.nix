{
  programs.git = {
    enable = true;

    # replace with your own details
    userName = "Change Me";
    userEmail = "you@example.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "vim";
      push.autoSetupRemote = true;
    };

    aliases = {
      st = "status -sb";
      co = "checkout";
      lg = "log --oneline --graph --decorate --all";
    };
  };
}
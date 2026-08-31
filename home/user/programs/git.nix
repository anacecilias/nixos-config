{
  programs.git = {
    enable = true;

    # ⚠️ Ajuste para seus dados reais
    userName = "Change Me";
    userEmail = "you@example.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "vim";
      push.autoSetupRemote = true;
    };

    # Aliases úteis (equivalentes a `git config --global alias.xxx`)
    aliases = {
      st = "status -sb";
      co = "checkout";
      lg = "log --oneline --graph --decorate --all";
    };
  };
}

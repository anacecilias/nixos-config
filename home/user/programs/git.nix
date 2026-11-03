{
  programs.git = {
    enable = true;

    settings = {
      # ⚠️ Ajuste para seus dados reais
      user.name = "Change Me";
      user.email = "you@example.com";

      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "vim";
      push.autoSetupRemote = true;

      # Aliases úteis (equivalentes a `git config --global alias.xxx`)
      alias = {
        st = "status -sb";
        co = "checkout";
        lg = "log --oneline --graph --decorate --all";
      };
    };
  };
}

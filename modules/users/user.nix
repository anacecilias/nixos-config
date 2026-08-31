{ pkgs, username, ... }:
{
  # Precisa estar habilitado no nível do sistema para o shell aparecer
  # em /etc/shells e poder ser usado como login shell.
  programs.zsh.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = "Change Me"; # ⚠️ ajuste para o seu nome de exibição
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    shell = pkgs.zsh;

    # Defina uma senha inicial (para o primeiro login) com:
    #   mkpasswd -m sha-512
    # e cole o hash aqui. Sem isso, a conta fica sem senha utilizável.
    # hashedPassword = "$6$...";
  };

  services.flatpak.enable = true;
}

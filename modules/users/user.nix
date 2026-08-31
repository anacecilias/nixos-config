{ pkgs, username, ... }:

{
  # system-wide shell registration (required for /etc/shells)
  programs.zsh.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = "change me"; # replace with your display name
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    shell = pkgs.zsh;

    # set an initial password hash generated via: mkpasswd -m sha-512
    # hashedPassword = "$6$...";
  };

  services.flatpak.enable = true;
}
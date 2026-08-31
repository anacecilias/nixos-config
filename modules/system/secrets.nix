{ config, ... }:

{
  # default encrypted secrets file path
  sops.defaultSopsFile = ../../secrets/secrets.yaml;

  # path to the age private key used for decryption at rebuild time
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

  # uncomment and declare secrets defined in secrets/secrets.yaml.
  # secrets will be available at /run/secrets/<name>.
  #
  # sops.secrets."wifi/password" = {};
  # sops.secrets."user/password_hash" = {
  #   neededForUsers = true; # required if used with users.users.<name>.hashedPasswordFile
  # };
}
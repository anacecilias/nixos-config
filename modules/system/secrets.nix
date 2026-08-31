{ config, ... }:
{
  # Onde o sops-nix procura o arquivo de segredos criptografado por padrão.
  # Veja secrets/README.md para instruções de como criá-lo.
  sops.defaultSopsFile = ../../secrets/secrets.yaml;

  # Chave privada age usada para descriptografar em tempo de rebuild.
  # NUNCA vai para o Git — vive só na máquina, fora do /nix/store.
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

  # Descomente e declare aqui os segredos definidos em secrets/secrets.yaml.
  # Cada um vira um arquivo legível apenas pelo dono em /run/secrets/<nome>.
  #
  # sops.secrets."wifi/senha" = {};
  # sops.secrets."usuario/senha_hash" = {
  #   neededForUsers = true; # necessário se for usado em users.users.<x>.hashedPasswordFile
  # };
}

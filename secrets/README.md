# Segredos (sops-nix)

Este repositório está preparado para gerenciar segredos (senhas, tokens,
chaves de API) de forma segura com [sops-nix](https://github.com/Mic92/sops-nix):
os segredos ficam **criptografados dentro do próprio Git**, e só são
descriptografados na máquina de destino durante o `nixos-rebuild`.

Nada aqui funciona "pronto" — é preciso gerar sua própria chave primeiro.
Enquanto isso, `modules/system/secrets.nix` fica inofensivo (não referencia
nenhum segredo real).

## 1. Entre no ambiente com as ferramentas necessárias

Na raiz do repositório:

```bash
nix develop
```

Isso te dá acesso aos comandos `age` e `sops` nesta shell.

## 2. Gere sua chave age

```bash
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
```

O comando imprime uma linha como:

```
Public key: age1qyqszqgpqyqszqgpqyqszqgpqyqszqgpqyqszqgpqyqszqgpqyqszqgpqyq
```

## 3. Cole a chave pública no `.sops.yaml`

Edite `.sops.yaml` na raiz do repositório e substitua
`age1SUBSTITUA_PELA_SUA_CHAVE_PUBLICA_AGE` pela chave pública gerada acima.

## 4. Crie o arquivo de segredos

```bash
sops secrets/secrets.yaml
```

Isso abre um editor (respeitando `$EDITOR`) com um arquivo YAML em texto
plano. Ao salvar, o `sops` criptografa automaticamente antes de gravar em
disco — o que fica no Git já sai criptografado. Exemplo de conteúdo:

```yaml
wifi:
    senha: minha-senha-do-wifi
usuario:
    senha_hash: $6$rounds=...   # gerada com `mkpasswd -m sha-512`
```

## 5. Declare o segredo em `modules/system/secrets.nix`

```nix
sops.secrets."wifi/senha" = {};
```

Depois do rebuild, o valor descriptografado aparece em
`/run/secrets/wifi/senha` (arquivo legível só pelo dono, nunca em texto
plano no `/nix/store`).

## 6. Coloque a chave privada na máquina de destino

A chave privada (`~/.config/sops/age/keys.txt`) **nunca** vai para o Git.
Em cada máquina onde você aplicar essa configuração, copie-a manualmente
para o caminho esperado por `sops.age.keyFile`:

```bash
sudo mkdir -p /var/lib/sops-nix
sudo cp ~/.config/sops/age/keys.txt /var/lib/sops-nix/key.txt
sudo chmod 600 /var/lib/sops-nix/key.txt
```

## Editando segredos depois

```bash
sops secrets/secrets.yaml
```

O `sops` descriptografa, abre no editor, e recriptografa ao salvar — o
diff no Git mostra que o arquivo mudou, mas o conteúdo continua ilegível
para quem não tem a chave privada.

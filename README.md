# nixos-config

Template de configuração declarativa multi-host de NixOS via Nix Flakes,
com [home-manager](https://github.com/nix-community/home-manager) para
dotfiles e [sops-nix](https://github.com/Mic92/sops-nix) para segredos.

Inclui: KDE Plasma 6, Pipewire, drivers NVIDIA, gestão de energia para
notebook, ambiente de gaming (Steam/Lutris/Gamemode) e dotfiles (zsh +
starship + kitty + git).

> 🍴 Isto é um **template genérico** pensado para ser usado como ponto de
> partida — clone/fork e siga o checklist abaixo antes de aplicar em uma
> máquina real.

## ✅ Checklist antes de usar

| O quê | Onde | O que fazer |
|---|---|---|
| Nome de usuário | `flake.nix` (`username = "changeme"`) | Troque para o seu username real. Isso propaga automaticamente para `users.users`, home-manager, etc. |
| Nome/e-mail do git | `home/user/programs/git.nix` | Substitua `"Change Me"` / `"you@example.com"`. |
| Nome de exibição da conta | `modules/users/user.nix` | Substitua `description = "Change Me"`. |
| Senha inicial do usuário | `modules/users/user.nix` | Gere com `mkpasswd -m sha-512` e descomente `hashedPassword` (ou configure via sops, veja abaixo). |
| Hostname de cada máquina | `hosts/desktop/configuration.nix`, `hosts/laptop/configuration.nix` | Ajuste `networking.hostName` se quiser outro nome. |
| Hardware real | `hosts/*/hardware-configuration.nix` | Substitua pelo gerado por `nixos-generate-config` na sua máquina (os arquivos aqui são placeholders com UUID falso). |
| Timezone/idioma/teclado | `modules/system/locale.nix` | Vem configurado como `America/Sao_Paulo` / `pt_BR` / ABNT2 — ajuste para o seu. |
| Chave de segredos | `.sops.yaml` | Só necessário se for usar segredos — veja [`secrets/README.md`](./secrets/README.md). |
| Pacotes instalados | `modules/system/packages.nix` | Lista de exemplo — adicione/remova o que fizer sentido para você. |

Depois disso, veja a seção [Primeiro uso](#primeiro-uso-em-uma-máquina-nova)
abaixo.

## Hosts incluídos (exemplo)

- **desktop** — GPU NVIDIA dedicada, sem gestão de energia de notebook.
- **laptop** — sem NVIDIA (ajuste se o seu tiver GPU dedicada/Optimus),
  com TLP/thermald para bateria.

Renomeie, remova ou adicione hosts livremente — veja
[Adicionando um novo host](#adicionando-um-novo-host).

## Estrutura

```
.
├── flake.nix                          # Inputs + variável `username` + os nixosConfigurations
├── flake.lock                         # Gerado automaticamente (nix flake lock)
├── .sops.yaml                         # Config do sops (chaves age autorizadas)
├── .github/workflows/check.yml        # CI: valida a config a cada push/PR
├── secrets/
│   ├── README.md                      # Passo a passo do sops-nix
│   └── secrets.yaml                   # Criado por você (ver secrets/README.md)
├── hosts/
│   ├── desktop/
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix # Específico da máquina (gerado no install)
│   └── laptop/
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── modules/
│   ├── system/
│   │   ├── boot.nix                   # Bootloader e kernel
│   │   ├── locale.nix                 # Timezone, idioma, teclado
│   │   ├── maintenance.nix            # GC automático, flakes habilitado
│   │   ├── packages.nix               # Pacotes globais do sistema
│   │   ├── fonts.nix                  # Fontes do sistema
│   │   └── secrets.nix                # Integração sops-nix
│   ├── desktop/
│   │   ├── plasma.nix                 # KDE Plasma 6 + SDDM
│   │   ├── audio.nix                  # Pipewire + Bluetooth
│   │   └── gaming.nix                 # Steam, Gamemode, Lutris, MangoHud
│   ├── hardware/
│   │   ├── graphics.nix               # Aceleração 3D + 32-bit (comum a todos)
│   │   ├── nvidia.nix                 # Drivers proprietários NVIDIA (só desktop)
│   │   └── laptop-power.nix           # TLP/thermald/lid (só laptop)
│   └── users/
│       └── user.nix                   # Conta de usuário genérica (username via flake.nix)
└── home/
    └── user/
        ├── home.nix                   # Orquestra os dotfiles abaixo
        └── programs/
            ├── git.nix                # git + aliases
            ├── shell.nix               # zsh + starship + aliases
            └── terminal.nix            # kitty
```

Módulos em `modules/` comuns a todos os hosts (boot, locale, pacotes,
fontes, plasma, áudio, gaming, gráficos, usuário) ficam listados uma vez em
`commonModules` dentro do `flake.nix`. Cada host só adiciona por cima o que
é específico dele (NVIDIA vs. gestão de energia de notebook).

## Primeiro uso em uma máquina nova

1. Complete o [checklist](#-checklist-antes-de-usar) acima.

2. Copie o `hardware-configuration.nix` real da instalação para o host
   correspondente:

   ```bash
   cp /etc/nixos/hardware-configuration.nix ./hosts/desktop/hardware-configuration.nix
   # ou, no laptop:
   cp /etc/nixos/hardware-configuration.nix ./hosts/laptop/hardware-configuration.nix
   ```

3. (Opcional, mas recomendado) Configure segredos seguindo
   [`secrets/README.md`](./secrets/README.md).

4. Gere o `flake.lock`:

   ```bash
   nix flake lock
   ```

5. Aplique a configuração — o nome depois do `#` deve bater com a chave
   escolhida em `nixosConfigurations` (`desktop` ou `laptop`):

   ```bash
   sudo nixos-rebuild switch --flake .#desktop
   # ou
   sudo nixos-rebuild switch --flake .#laptop
   ```

## Uso do dia a dia

- Testar mudanças sem aplicar permanentemente:
  ```bash
  sudo nixos-rebuild test --flake .#desktop
  ```
- Atualizar todos os inputs (nixpkgs, home-manager, sops-nix):
  ```bash
  nix flake update
  ```
- Atualizar um input específico:
  ```bash
  nix flake lock --update-input nixpkgs
  ```
- Voltar para a geração anterior do sistema (caso algo quebre):
  ```bash
  sudo nixos-rebuild switch --rollback
  ```
- Editar um segredo existente:
  ```bash
  nix develop   # dá acesso ao comando `sops`
  sops secrets/secrets.yaml
  ```

O alias `update` já configurado no zsh (via home-manager) resume o passo 5
acima — ajuste o caminho do repositório em
`home/user/programs/shell.nix` se clonar em outro lugar que não `~/nixos-config`.

## Adicionando um novo host

Crie `hosts/<nome>/` com seu próprio `configuration.nix` e
`hardware-configuration.nix`, reaproveitando os módulos existentes, e
adicione uma nova entrada em `nixosConfigurations` no `flake.nix` (copie o
bloco de `desktop` ou `laptop` como ponto de partida).

## Notas sobre gaming

- `programs.steam.enable` já cuida de abrir as portas de firewall
  necessárias e habilitar 32-bit + Gamescope.
- Use `protonup-qt` para instalar Proton-GE (melhor compatibilidade em
  jogos que o Proton oficial não roda bem).
- `mangohud %command%` nas opções de lançamento de um jogo na Steam mostra
  overlay de FPS/temperatura.

## Notas sobre o laptop

- Os limites de carga de bateria (`START_CHARGE_THRESH_BAT0` /
  `STOP_CHARGE_THRESH_BAT0` em `modules/hardware/laptop-power.nix`) só
  funcionam em hardware compatível (comum em Thinkpads/alguns Dell). Se o
  rebuild falhar por causa deles, remova essas duas linhas.
- Se o laptop tiver GPU NVIDIA em setup Optimus, você vai precisar de
  configuração adicional (`hardware.nvidia.prime`), não incluída aqui.

## CI

`.github/workflows/check.yml` roda `nix flake check` e um build "dry-run"
de cada host a cada push/PR — ajuda a pegar erro de sintaxe antes de puxar
a config numa máquina real. Ele não substitui testar `hardware-configuration.nix`
verdadeiro, já que o CI usa os placeholders.

## Segurança / privacidade

- **Nunca** comite `~/.config/sops/age/keys.txt` nem qualquer chave privada
  (o `.gitignore` já bloqueia arquivos `keys.txt`).
- `secrets/secrets.yaml` é seguro de comitar *depois* de criptografado pelo
  `sops` — nunca edite/comite esse arquivo como texto plano.
- Revise `hosts/*/hardware-configuration.nix` antes de publicar: se você
  colar o arquivo real gerado pela sua instalação, ele pode conter UUIDs de
  disco (não são segredos, mas identificam sua máquina).

## Ideias para evoluir o repositório

- Adicionar [nixos-hardware](https://github.com/NixOS/nixos-hardware) como
  input caso seu laptop tenha quirks conhecidos.
- Trocar `kitty` por outro terminal, ou `zsh` por `fish`, em
  `home/user/programs/`.
- Adicionar um segundo usuário reaproveitando `modules/users/user.nix` como
  base (parametrizando mais de um `username`).

## Licença

[MIT](./LICENSE) — use, copie e adapte livremente.

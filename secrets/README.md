# Secrets management (sops-nix)

This repository uses [sops-nix](https://github.com/Mic92/sops-nix) for declarative secrets management (passwords, tokens, API keys) 

Secrets are encrypted directly inside Git and decrypted only on the target machine during `nixos-rebuild`

`modules/system/secrets.nix` is neutral by default. Follow the steps below to configure your own encryption keys

---

## 1. Enter the secrets shell

Run the following command from the repository root:

```bash
nix develop
```

This shell provides access to the `age` and `sops` CLI tools

---

## 2. Generate an age key pair

```bash
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
```

The output will display your public key, similar to:

```
Public key: age1qyqszqgpqyqszqgpqyqszqgpqyqszqgpqyqszqgpqyqszqgpqyqszqgpqyq
```

---

## 3. Update `.sops.yaml`

Open `.sops.yaml` in the root directory and replace
`age1REPLACE_WITH_YOUR_AGE_PUBLIC_KEY` with your generated public key

---

## 4. Create the encrypted secrets file

```bash
sops secrets/secrets.yaml
```

This opens your default editor `($EDITOR)`
Upon saving, `sops` automatically encrypts the contents using your public key

Example structure:

```yaml
wifi:
    password: my-wifi-password
user:
    password_hash: $6$rounds=... # generated via mkpasswd -m sha-512
```

---

## 5. Declare secrets in nixos

In `modules/system/secrets.nix`, declare your secrets:

```nix
sops.secrets."wifi/password" = {};
```

After running `nixos-rebuild switch`, the decrypted value will be available at `/run/secrets/wifi/password`

---

## 6. Install the private key on the target System

The private key (`~/.config/sops/age/keys.txt`) **must** never be committed to git
Copy it to the destination path expected by `sops.age.keyFile`:

```bash
sudo mkdir -p /var/lib/sops-nix
sudo cp ~/.config/sops/age/keys.txt /var/lib/sops-nix/key.txt
sudo chmod 600 /var/lib/sops-nix/key.txt
```

---

## Editing existing secrets

```bash
sops secrets/secrets.yaml
```

`sops` will handle decryption on open and re-encryption upon saving
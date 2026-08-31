{
  # enable new nix command line tool and flakes support
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # automatic garbage collection of old generations
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # automatically optimize and deduplicate the nix store
  nix.settings.auto-optimise-store = true;
}
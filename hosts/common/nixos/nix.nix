{ ... }:

{
  nix = {
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://skm-nixos.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "skm-nixos.cachix.org-1:/vQ9eIf7dL0imfHCWQGI1W/TVKceo6OYBsX0RvS55xs="
      ];

      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = true;
    };

    # package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';

    gc = {
      automatic = true;
      dates = "monthly";
    };
  };

  nixpkgs.config.allowUnfree = true;
}

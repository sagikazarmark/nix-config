{ ... }:

{
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes impure-derivations
    '';

    settings = {
      trusted-users = [
        "root"
        "mark"
      ];
    };
  };
}

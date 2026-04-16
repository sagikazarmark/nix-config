{ ... }:

{
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes impure-derivations ca-derivations
    '';

    settings = {
      trusted-users = [
        "root"
        "mark"
      ];
    };
  };
}

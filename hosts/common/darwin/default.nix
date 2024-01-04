{ config, pkgs, ... }:

{
  imports = [
    ./shell.nix
    ./nix.nix
    ./security.nix
    ./settings.nix
    ./wm.nix
    ./homebrew.nix
  ];
}

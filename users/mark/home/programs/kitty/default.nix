{ lib, stdenv, ... }:

{
  imports = [
    ./reset.nix
    ./config.nix
    ./darwin.nix
  ];
}

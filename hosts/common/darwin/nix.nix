{ config, pkgs, ... }:

{
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # nix.useDaemon = true;
  services.nix-daemon.enable = true;
  # services.nix-daemon.enableSocketListener = true;
}

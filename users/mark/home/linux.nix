{ pkgs, ... }:

{
  home.packages = with pkgs; [
    firefox-devedition-bin
    _1password-gui

    spotify
    gnomeExtensions.spotify-tray
  ];
}

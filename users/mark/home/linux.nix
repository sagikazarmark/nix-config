{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    (firefox-devedition-bin.override
      {
        cfg = {
          enableTridactylNative = true;
        };
      })

    _1password-gui

    spotify
    gnomeExtensions.spotify-tray

    tdesktop
    slack

    python310Packages.pip
  ];

  programs.gpg = {
    enable = true;

    homedir = "${config.xdg.dataHome}/gnupg";
  };

  services.gpg-agent.enable = true;
}

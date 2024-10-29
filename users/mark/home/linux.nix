{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # (firefox-devedition-bin.override
    #   {
    #     cfg = {
    #       enableTridactylNative = true;
    #     };
    #   })

    (firefox-wayland.override {
      nativeMessagingHosts = [
        pkgs.tridactyl-native
      ];
    })

    # _1password-gui

    gnome.nautilus

    spotify
    gnomeExtensions.spotify-tray

    tdesktop
    slack
    # jitsi-meet
    # jitsi-meet-prosody
    # jitsi-meet-electron

    python310Packages.pip

    pavucontrol

    unzip

    onlyoffice-bin
    obs-studio
    vlc
    obsidian

    darktable
    rawtherapee
  ];

  programs.gpg = {
    enable = true;

    homedir = "${config.xdg.dataHome}/gnupg";
  };

  services.gpg-agent = {
    enable = true;

    pinentryPackage = pkgs.pinentry-gnome3;

    defaultCacheTtl = 34560000;
    maxCacheTtl = 34560000;
  };
}

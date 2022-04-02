{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # (firefox-devedition-bin.override
    #   {
    #     cfg = {
    #       enableTridactylNative = true;
    #     };
    #   })

    (firefox-wayland.override
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

  programs.direnv = {
    nix-direnv = {
      # Can ber removed in the next version
      enableFlakes = true;
    };
  };

  programs.gpg = {
    enable = true;

    homedir = "${config.xdg.dataHome}/gnupg";
  };

  services.gpg-agent = {
    enable = true;

    pinentryFlavor = "gnome3";

    defaultCacheTtl = 34560000;
    maxCacheTtl = 34560000;
  };
}

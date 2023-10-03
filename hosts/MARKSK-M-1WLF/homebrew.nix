{ config, pkgs, ... }:

{
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    taps = [
      "homebrew/cask"
      "homebrew/cask-drivers"
    ];

    brews = [
      "mas"
      "trash"

      # Nix version is broken at the moment
      # "oci-cli"
    ];

    casks = [
      # Apps
      "1password"
      "1password-cli"
      "adobe-acrobat-reader"
      "caffeine"
      "calibre"
      "chromium"
      "colorsnapper"
      "daisydisk"
      "discord"
      "gpg-suite"
      "firefox"
      "flux"
      "insync"
      "karabiner-elements"
      "little-snitch"
      "micro-snitch"
      "microsoft-teams"
      "monitorcontrol"
      "notion"
      "obs"
      "obs-websocket"
      "spotify"
      "todoist"
      "transmit"
      "tuxera-ntfs"
      "vuescan"
      "vlc"
      "raycast"

      "signal"
      "postbox"
      "telegram"
      # "telegram-desktop"
      "whatsapp"

      "darktable"
      "inkscape"

      # Dev
      "docker"
      "tableplus"
      "postman"
      "kube-forwarder"

      "logitech-options"

      "morgen"

      "camtasia"
    ];

    masApps = {
      "DaVinci Resolve" = 571213070;
    };
  };
}

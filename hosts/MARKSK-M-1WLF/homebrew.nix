{ config, pkgs, lib, ... }:

let
  brewPrefix =
    if pkgs.stdenv.hostPlatform.isAarch64
    then "/opt/homebrew"
    else "/usr/local";
in
{
  # $ brew shellenv
  #
  # Based on:
  #   - https://github.com/montchr/dotfield/commit/52f5b09927b9c68003331a5e386ed19cd9fae464
  #   - https://github.com/LnL7/nix-darwin/issues/596
  environment.systemPath = lib.mkBefore [ "${brewPrefix}/bin" "${brewPrefix}/sbin" ];
  environment.variables = {
    HOMEBREW_PREFIX = brewPrefix;
    HOMEBREW_CELLAR = "${brewPrefix}/Cellar";
    HOMEBREW_REPOSITORY = brewPrefix;
    MANPATH = "${brewPrefix}/share/man\${MANPATH+:$MANPATH}:";
    INFOPATH = "${brewPrefix}/share/info:\${INFOPATH:-}";
  };

  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    taps = [
      "homebrew/cask"
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

      "microsoft-office"
      "grammarly"
      "grammarly-desktop"

      "signal"
      "postbox"
      "telegram"
      # "telegram-desktop"
      "webex"
      "whatsapp"

      "darktable"
      "inkscape"
      "affinity-designer"
      "affinity-photo"
      "figma"

      # Dev
      "docker"
      "tableplus"
      "postman"
      "kube-forwarder"

      "logitech-options"

      "morgen"
      "sunsama"

      "camtasia"

      "bartender"
    ];

    masApps = {
      "DaVinci Resolve" = 571213070;
    };
  };
}

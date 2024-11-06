{ pkgs, lib, ... }:

let
  brewPrefix = if pkgs.stdenv.hostPlatform.isAarch64 then
    "/opt/homebrew"
  else
    "/usr/local";
in {
  # $ brew shellenv
  #
  # Based on:
  #   - https://github.com/montchr/dotfield/commit/52f5b09927b9c68003331a5e386ed19cd9fae464
  #   - https://github.com/LnL7/nix-darwin/issues/596
  environment.systemPath =
    lib.mkBefore [ "${brewPrefix}/bin" "${brewPrefix}/sbin" ];
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

    taps = [ ];

    brews = [
      "mas"
      "trash"
      "cocoapods"

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
      "todoist"
      "transmit"
      "tuxera-ntfs"
      "vuescan"
      "vlc"
      "raycast"

      "roon"
      "spotify"
      "xld"

      "microsoft-office"
      "notion-calendar"
      "grammarly-desktop"

      "signal"
      "postbox"
      "telegram"
      # "telegram-desktop"
      "webex"
      "whatsapp"
      "messenger"
      "beeper"

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
      "gitbutler"

      "logitech-options"
      "logi-options+"

      # "morgen"
      "sunsama"
      "anytype"
      "linear-linear"

      "camtasia"

      "bartender"

      "launchcontrol"
    ];

    masApps = {
      # "DaVinci Resolve" = 571213070;
      "Darkroom" = 953286746;
      "Tailscale" = 1475387142;
    };
  };
}

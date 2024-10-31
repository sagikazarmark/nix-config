{ config, lib, pkgs, ... }:

with lib;

# Adds extraConfig to hypridle
let
  cfg = config.services.hypridle;
in
{
  options = {
    services.hypridle = {
      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra configuration lines to add to `~/.config/hypr/hypridle.conf`.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile."hypr/hypridle.conf" =
      let shouldGenerate = cfg.extraConfig != "" || cfg.settings != { };
      in mkIf shouldGenerate {
        text = lib.optionalString (cfg.settings != { })
          (lib.hm.generators.toHyprconf {
            attrs = cfg.settings;
            inherit (cfg) importantPrefixes;
          }) + lib.optionalString (cfg.extraConfig != null) cfg.extraConfig;
      };

    # hypridle service doesn't find these for some reason
    # systemd.user.services.hypridle.path = with pkgs; [
    #   procps
    #   hyprlock
    # ];
  };
}

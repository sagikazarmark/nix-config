{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.wakatime;

  iniFormat = pkgs.formats.ini { };

  iniFile = iniFormat.generate ".wakatime.cfg" cfg.settings;
in
{
  options.programs.wakatime = {
    enable = mkEnableOption "WakaTime command line interface";

    package = mkOption {
      type = types.package;
      default = pkgs.wakatime;
      defaultText = literalExpression "pkgs.wakatime";
      description = "Package providing the <command>wakatime</command>.";
    };

    settings = mkOption {
      type = iniFormat.type;
      default = { };
      example = {
        settings = {
          debug = false;
        };
      };
      description = ''
        Configuration to use for Flameshot. See
        <link xlink:href="https://github.com/wakatime/wakatime-cli/blob/develop/USAGE.md#ini-config-file"/>
        for available options.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    # WakaTime CLI puts its config and data files in $HOME by default.
    # Unfortunately, there is no way to configure a separate location for config and runtime data files (following the XDG specification).
    # As a compormise, the WakaTime home is set to XDG Data home.
    home.sessionVariables = {
      WAKATIME_HOME = "${config.xdg.dataHome}/wakatime";
    };

    xdg.dataFile."wakatime/.wakatime.cfg" = {
      source = iniFile;
    };
  };
}

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.jankyborders;
in
{
  options.programs.jankyborders = {
    enable = mkEnableOption "JankyBorders is a lightweight tool designed to add colored borders to user windows on macOS 14.0+";

    package = mkOption {
      type = types.package;
      default = pkgs.jankyborders;
      defaultText = literalExpression "pkgs.jankyborders";
      description = "Package providing the <command>borders</command> tool.";
    };

    # TODO: improve options
    # https://github.com/FelixKratz/JankyBorders/wiki/Man-Page
    options = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        style = "round";
        width = "6.0";
        hidpi = "off";
        active_color = "0xffe2e2e3";
        inactive_color = "0xff414550";
      };
      description = "Options for the borders command saved in a bordersrc file.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."borders/bordersrc" = {
      text = ''
        #!/bin/bash

        options=(
        ${ lib.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "\t${name}=${value}") cfg.options) }
        )

        borders "''${options[@]}"
      '';

      executable = true;
    };
  };
}

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.colorscheme;

  cs = if config.programs.kitty.colorscheme.override == null then config.colorscheme else config.programs.kitty.colorscheme.override;

  colorschemeType = {
    slug = mkOption {
      type = types.str;
      default = "";
      description = ''
        Color scheme slug (sanitized name)
      '';
    };
    name = mkOption {
      type = types.str;
      default = "";
      description = ''
        Color scheme (pretty) name
      '';
    };
    author = mkOption {
      type = types.str;
      default = "";
      description = ''
        Color scheme author
      '';
    };
    kind = mkOption {
      type = types.enum [ "dark" "light" ];
      default =
        if builtins.substring 0 1 cfg.colors.base00 < "5" then
          "dark"
        else
          "light";
      description = ''
        Whether the scheme is dark or light
      '';
    };

    colors =
      let
        mkColorOption = name: {
          inherit name;
          value = mkOption {
            type = types.strMatching "[a-fA-F0-9]{6}";
            description = "${name} color.";
          };
        };
      in
      listToAttrs (map mkColorOption [
        "base00"
        "base01"
        "base02"
        "base03"
        "base04"
        "base05"
        "base06"
        "base07"
        "base08"
        "base09"
        "base0A"
        "base0B"
        "base0C"
        "base0D"
        "base0E"
        "base0F"
      ]);
  };

  colorschemeModule = types.submodule {
    options = colorschemeType;
  };
in
{
  options = {
    programs.kitty.colorscheme = {
      enable = mkEnableOption "Kitty terminal emulator colorscheme";

      override = mkOption {
        default = null;
        type = types.nullOr colorschemeModule;
        description = "Override global colorscheme";
      };
    };
  };

  config = mkMerge [
    (mkIf config.programs.kitty.colorscheme.enable {
      programs.kitty.settings = {
        foreground = "#${cs.colors.base05}";
        background = "#${cs.colors.base00}";
        selection_background = "#${cs.colors.base05}";
        selection_foreground = "#${cs.colors.base00}";
        url_color = "#${cs.colors.base04}";
        cursor = "#${cs.colors.base05}";
        active_border_color = "#${cs.colors.base03}";
        inactive_border_color = "#${cs.colors.base01}";
        active_tab_background = "#${cs.colors.base00}";
        active_tab_foreground = "#${cs.colors.base05}";
        inactive_tab_background = "#${cs.colors.base01}";
        inactive_tab_foreground = "#${cs.colors.base04}";
        tab_bar_background = "#${cs.colors.base01}";

        color0 = "#${cs.colors.base00}";
        color1 = "#${cs.colors.base08}";
        color2 = "#${cs.colors.base0B}";
        color3 = "#${cs.colors.base0A}";
        color4 = "#${cs.colors.base0D}";
        color5 = "#${cs.colors.base0E}";
        color6 = "#${cs.colors.base0C}";
        color7 = "#${cs.colors.base05}";

        color8 = "#${cs.colors.base03}";
        color9 = "#${cs.colors.base09}";
        color10 = "#${cs.colors.base01}";
        color11 = "#${cs.colors.base02}";
        color12 = "#${cs.colors.base04}";
        color13 = "#${cs.colors.base06}";
        color14 = "#${cs.colors.base0F}";
        color15 = "#${cs.colors.base07}";
      };
    })
  ];
}

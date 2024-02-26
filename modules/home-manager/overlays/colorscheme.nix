{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.colorscheme;

  hexColorType = mkOptionType {
    name = "hex-color";
    descriptionClass = "noun";
    description = "RGB color in hex format";
    check = x: isString x && !(hasPrefix "#" x);
  };

  cs = if config.programs.kitty.colorscheme.override == null then config.colorscheme else config.programs.kitty.colorscheme.override;

  colorschemeType = types.submodule {
    imports = [
      (mkRenamedOptionModule [ "kind" ] [ "variant" ])
      (mkRenamedOptionModule [ "colors" ] [ "palette" ])
    ];

    options = {
      slug = mkOption {
        type = types.str;
        example = "awesome-scheme";
        description = ''
          Color scheme slug (sanitized name)
        '';
      };
      name = mkOption {
        type = types.str;
        default = "";
        example = "Awesome Scheme";
        description = ''
          Color scheme (pretty) name
        '';
      };
      description = mkOption {
        type = types.str;
        default = "";
        example = "A very nice theme";
        description = ''
          Color scheme author
        '';
      };
      author = mkOption {
        type = types.str;
        default = "";
        example = "Gabriel Fontes (https://m7.rs)";
        description = ''
          Color scheme author
        '';
      };
      variant = mkOption {
        type = types.enum [ "dark" "light" ];
        default =
          if builtins.substring 0 1 cfg.palette.base00 < "5" then
            "dark"
          else
            "light";
        description = ''
          Whether the scheme is dark or light
        '';
      };

      palette = mkOption {
        type = with types; attrsOf (
          coercedTo str (removePrefix "#") hexColorType
        );
        default = { };
        example = literalExpression ''
          {
            base00 = "002635";
            base01 = "00384d";
            base02 = "517F8D";
            base03 = "6C8B91";
            base04 = "869696";
            base05 = "a1a19a";
            base06 = "e6e6dc";
            base07 = "fafaf8";
            base08 = "ff5a67";
            base09 = "f08e48";
            base0A = "ffcc1b";
            base0B = "7fc06e";
            base0C = "14747e";
            base0D = "5dd7b9";
            base0E = "9a70a4";
            base0F = "c43060";
          }
        '';
        description = ''
          Atribute set of hex colors.

          These are usually base00-base0F, but you may use any name you want.
          For example, these can have meaningful names (bg, fg), or be base24.

          The colorschemes provided by nix-colors follow the base16 standard.
          Some might leverage base24 and have 24 colors, but these can be safely
          used as if they were base16.

          You may include a leading #, but it will be stripped when accessed from
          config.colorscheme.palette.
        '';
      };
    };
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
        foreground = "#${cs.palette.base05}";
        background = "#${cs.palette.base00}";
        selection_background = "#${cs.palette.base05}";
        selection_foreground = "#${cs.palette.base00}";
        url_color = "#${cs.palette.base04}";
        cursor = "#${cs.palette.base05}";
        active_border_color = "#${cs.palette.base03}";
        inactive_border_color = "#${cs.palette.base01}";
        active_tab_background = "#${cs.palette.base00}";
        active_tab_foreground = "#${cs.palette.base05}";
        inactive_tab_background = "#${cs.palette.base01}";
        inactive_tab_foreground = "#${cs.palette.base04}";
        tab_bar_background = "#${cs.palette.base01}";

        color0 = "#${cs.palette.base00}";
        color1 = "#${cs.palette.base08}";
        color2 = "#${cs.palette.base0B}";
        color3 = "#${cs.palette.base0A}";
        color4 = "#${cs.palette.base0D}";
        color5 = "#${cs.palette.base0E}";
        color6 = "#${cs.palette.base0C}";
        color7 = "#${cs.palette.base05}";

        color8 = "#${cs.palette.base03}";
        color9 = "#${cs.palette.base09}";
        color10 = "#${cs.palette.base01}";
        color11 = "#${cs.palette.base02}";
        color12 = "#${cs.palette.base04}";
        color13 = "#${cs.palette.base06}";
        color14 = "#${cs.palette.base0F}";
        color15 = "#${cs.palette.base07}";
      };
    })
  ];
}

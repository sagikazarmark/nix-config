{ config, lib, ... }:

with lib;

let
  csTypes = import ../types.nix { inherit config lib; };

  cfg = config.programs.kitty;
  colorscheme = cfg.nix-colors.colorscheme;
in
{
  options = {
    programs.kitty.nix-colors = mkOption {
      type = csTypes.nix-colors;
      default = { };
    };
  };

  config = mkIf cfg.nix-colors.enable {
    programs.kitty.settings =
      # https://github.com/catppuccin/kitty
      if strings.hasPrefix "catppuccin-" colorscheme.slug then
        {
          foreground = "#${colorscheme.palette.base05}";
          background = "#${colorscheme.palette.base00}";
          selection_background = "#${colorscheme.palette.base05}";
          selection_foreground = "#${colorscheme.palette.base00}";
          url_color = "#${colorscheme.palette.base04}";
          cursor = "#${colorscheme.palette.base05}";
          active_border_color = "#${colorscheme.palette.base03}";
          inactive_border_color = "#${colorscheme.palette.base01}";
          active_tab_background = "#${colorscheme.palette.base00}";
          active_tab_foreground = "#${colorscheme.palette.base05}";
          inactive_tab_background = "#${colorscheme.palette.base01}";
          inactive_tab_foreground = "#${colorscheme.palette.base04}";
          tab_bar_background = "#${colorscheme.palette.base01}";

          color0 = "#${colorscheme.palette.base00}";
          color1 = "#${colorscheme.palette.base08}";
          color2 = "#${colorscheme.palette.base0B}";
          color3 = "#${colorscheme.palette.base0A}";
          color4 = "#${colorscheme.palette.base0D}";
          color5 = "#${colorscheme.palette.base0E}";
          color6 = "#${colorscheme.palette.base0C}";
          color7 = "#${colorscheme.palette.base05}";

          color8 = "#${colorscheme.palette.base03}";
          color9 = "#${colorscheme.palette.base09}";
          color10 = "#${colorscheme.palette.base01}";
          color11 = "#${colorscheme.palette.base02}";
          color12 = "#${colorscheme.palette.base04}";
          color13 = "#${colorscheme.palette.base06}";
          color14 = "#${colorscheme.palette.base0F}";
          color15 = "#${colorscheme.palette.base07}";
        }
      # https://github.com/kdrag0n/base16-kitty
      else
        {
          foreground = "#${colorscheme.palette.base05}";
          background = "#${colorscheme.palette.base00}";
          selection_background = "#${colorscheme.palette.base05}";
          selection_foreground = "#${colorscheme.palette.base00}";
          url_color = "#${colorscheme.palette.base04}";
          cursor = "#${colorscheme.palette.base05}";
          active_border_color = "#${colorscheme.palette.base03}";
          inactive_border_color = "#${colorscheme.palette.base01}";
          active_tab_background = "#${colorscheme.palette.base00}";
          active_tab_foreground = "#${colorscheme.palette.base05}";
          inactive_tab_background = "#${colorscheme.palette.base01}";
          inactive_tab_foreground = "#${colorscheme.palette.base04}";
          tab_bar_background = "#${colorscheme.palette.base01}";

          color0 = "#${colorscheme.palette.base00}";
          color1 = "#${colorscheme.palette.base08}";
          color2 = "#${colorscheme.palette.base0B}";
          color3 = "#${colorscheme.palette.base0A}";
          color4 = "#${colorscheme.palette.base0D}";
          color5 = "#${colorscheme.palette.base0E}";
          color6 = "#${colorscheme.palette.base0C}";
          color7 = "#${colorscheme.palette.base05}";

          color8 = "#${colorscheme.palette.base03}";
          color9 = "#${colorscheme.palette.base09}";
          color10 = "#${colorscheme.palette.base01}";
          color11 = "#${colorscheme.palette.base02}";
          color12 = "#${colorscheme.palette.base04}";
          color13 = "#${colorscheme.palette.base06}";
          color14 = "#${colorscheme.palette.base0F}";
          color15 = "#${colorscheme.palette.base07}";
        }
    ;
  };
}

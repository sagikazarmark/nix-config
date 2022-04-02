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
    # https://github.com/kdrag0n/base16-kitty
    programs.kitty.settings = {
      foreground = "#${colorscheme.colors.base05}";
      background = "#${colorscheme.colors.base00}";
      selection_background = "#${colorscheme.colors.base05}";
      selection_foreground = "#${colorscheme.colors.base00}";
      url_color = "#${colorscheme.colors.base04}";
      cursor = "#${colorscheme.colors.base05}";
      active_border_color = "#${colorscheme.colors.base03}";
      inactive_border_color = "#${colorscheme.colors.base01}";
      active_tab_background = "#${colorscheme.colors.base00}";
      active_tab_foreground = "#${colorscheme.colors.base05}";
      inactive_tab_background = "#${colorscheme.colors.base01}";
      inactive_tab_foreground = "#${colorscheme.colors.base04}";
      tab_bar_background = "#${colorscheme.colors.base01}";

      color0 = "#${colorscheme.colors.base00}";
      color1 = "#${colorscheme.colors.base08}";
      color2 = "#${colorscheme.colors.base0B}";
      color3 = "#${colorscheme.colors.base0A}";
      color4 = "#${colorscheme.colors.base0D}";
      color5 = "#${colorscheme.colors.base0E}";
      color6 = "#${colorscheme.colors.base0C}";
      color7 = "#${colorscheme.colors.base05}";

      color8 = "#${colorscheme.colors.base03}";
      color9 = "#${colorscheme.colors.base09}";
      color10 = "#${colorscheme.colors.base01}";
      color11 = "#${colorscheme.colors.base02}";
      color12 = "#${colorscheme.colors.base04}";
      color13 = "#${colorscheme.colors.base06}";
      color14 = "#${colorscheme.colors.base0F}";
      color15 = "#${colorscheme.colors.base07}";
    };
  };
}

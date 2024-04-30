{ config, lib, ... }:

with lib;

let
  csTypes = import ../types.nix { inherit config lib; };

  cfg = config.programs.fzf;
  colorscheme = cfg.nix-colors.colorscheme;
in
{
  options = {
    programs.fzf.nix-colors = mkOption {
      type = csTypes.nix-colors;
      default = { };
    };
  };

  config = mkIf cfg.nix-colors.enable {
    # https://github.com/junegunn/fzf/blob/master/ADVANCED.md#color-themes
    programs.fzf.colors =
      # https://github.com/catppuccin/fzf
      if strings.hasPrefix "catppuccin-" colorscheme.slug then
        {
          "bg+" = "#${colorscheme.palette.base02}";
          bg = "#${colorscheme.palette.base00}";
          spinner = "#${colorscheme.palette.base06}";
          hl = "#${colorscheme.palette.base08}";
          fg = "#${colorscheme.palette.base05}";
          header = "#${colorscheme.palette.base08}";
          info = "#${colorscheme.palette.base0E}";
          pointer = "#${colorscheme.palette.base06}";
          marker = "#${colorscheme.palette.base06}";
          "fg+" = "#${colorscheme.palette.base06}";
          prompt = "#${colorscheme.palette.base0E}";
          "hl+" = "#${colorscheme.palette.base08}";
        }
      # https://github.com/tinted-theming/tinted-fzf
      # Old: https://github.com/fnune/base16-fzf
      else
        {
          "bg+" = "#${colorscheme.palette.base00}";
          bg = "#${colorscheme.palette.base01}";
          spinner = "#${colorscheme.palette.base0C}";
          hl = "#${colorscheme.palette.base0D}";
          fg = "#${colorscheme.palette.base04}";
          header = "#${colorscheme.palette.base0D}";
          info = "#${colorscheme.palette.base0A}";
          pointer = "#${colorscheme.palette.base0C}";
          marker = "#${colorscheme.palette.base0C}";
          "fg+" = "#${colorscheme.palette.base05}";
          prompt = "#${colorscheme.palette.base0A}";
          "hl+" = "#${colorscheme.palette.base0D}";
        }
    ;
  };
}

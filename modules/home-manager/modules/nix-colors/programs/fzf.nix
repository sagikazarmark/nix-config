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
    # https://github.com/fnune/base16-fzf
    programs.fzf.colors = {
      bg = "#${colorscheme.palette.base01}";
      "bg+" = "#${colorscheme.palette.base00}";
      fg = "#${colorscheme.palette.base04}";
      "fg+" = "#${colorscheme.palette.base06}";
      hl = "#${colorscheme.palette.base0D}";
      "hl+" = "#${colorscheme.palette.base0D}";
      spinner = "#${colorscheme.palette.base0C}";
      header = "#${colorscheme.palette.base0D}";
      info = "#${colorscheme.palette.base0A}";
      pointer = "#${colorscheme.palette.base0C}";
      marker = "#${colorscheme.palette.base0C}";
      prompt = "#${colorscheme.palette.base0A}";
    };
  };
}

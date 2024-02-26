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
    programs.fzf.defaultOptions = [
      # https://github.com/fnune/base16-fzf
      "--color=bg+:#${ colorscheme.palette.base01 },bg:#${ colorscheme.palette.base00 },spinner:#${ colorscheme.palette.base0C },hl:#${ colorscheme.palette.base0D }"
      "--color=fg:#${ colorscheme.palette.base04 },header:#${ colorscheme.palette.base0D },info:#${ colorscheme.palette.base0A },pointer:#${ colorscheme.palette.base0C }"
      "--color=marker:#${ colorscheme.palette.base0C },fg+:#${ colorscheme.palette.base06 },prompt:#${ colorscheme.palette.base0A },hl+:#${ colorscheme.palette.base0D }"
    ];
  };
}

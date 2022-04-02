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
      "--color=bg+:#${ colorscheme.colors.base01 },bg:#${ colorscheme.colors.base00 },spinner:#${ colorscheme.colors.base0C },hl:#${ colorscheme.colors.base0D }"
      "--color=fg:#${ colorscheme.colors.base04 },header:#${ colorscheme.colors.base0D },info:#${ colorscheme.colors.base0A },pointer:#${ colorscheme.colors.base0C }"
      "--color=marker:#${ colorscheme.colors.base0C },fg+:#${ colorscheme.colors.base06 },prompt:#${ colorscheme.colors.base0A },hl+:#${ colorscheme.colors.base0D }"
    ];
  };
}

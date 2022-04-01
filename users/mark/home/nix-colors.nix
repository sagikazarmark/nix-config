{ config, pkgs, lib, inputs, ... }:

let
  colorSchemes = inputs.nix-colors.colorSchemes;
in
{
  colorscheme = colorSchemes.tokyo-night-storm;

  programs.kitty.nix-colors = {
    enable = true;
    colorscheme = lib.recursiveUpdate colorSchemes.tokyo-night-terminal-storm {
      colors = {
        base05 = "A9B1D6";
      };
    };
  };

  gtk.nix-colors.enable = true;
}

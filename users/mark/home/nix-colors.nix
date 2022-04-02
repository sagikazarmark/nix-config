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

  programs.fzf.nix-colors.enable = true;

  gtk.nix-colors.enable = true;

  wayland.windowManager.sway.nix-colors.enable = true;

  programs.waybar.nix-colors.enable = true;

  programs.rofi.nix-colors.enable = true;
}

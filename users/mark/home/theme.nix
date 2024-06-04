{ inputs, ... }:

{

  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  # https://github.com/catppuccin/nix
  catppuccin.flavor = "macchiato";

  programs.bat.catppuccin.enable = true;
  programs.fzf.catppuccin.enable = true;
  programs.kitty.catppuccin.enable = true;


  wayland.windowManager.sway.catppuccin.enable = true;
  # programs.waybar.catppuccin.enable = true;
  programs.rofi.catppuccin.enable = true;
  services.dunst.catppuccin.enable = true;
}

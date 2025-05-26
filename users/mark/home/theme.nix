{ inputs, ... }:

{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  # https://github.com/catppuccin/nix
  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  catppuccin.bat.enable = true;
  catppuccin.fzf.enable = true;
  catppuccin.kitty.enable = true;
  catppuccin.delta.enable = true;

  catppuccin.sway.enable = true;
  # catppuccin.waybar.enable = true;
  catppuccin.rofi.enable = true;
  catppuccin.dunst.enable = true;
}

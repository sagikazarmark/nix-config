{ pkgs, lib, ... }:

{
  home.packages = [ pkgs.wezterm ];

  xdg.configFile."wezterm/wezterm.lua".source = ./config.lua;

  programs.zsh.initContent = lib.mkOrder 1001 ''
    source "${pkgs.wezterm}/etc/profile.d/wezterm.sh"
  '';
}

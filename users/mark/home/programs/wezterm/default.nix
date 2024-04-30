{ pkgs, ... }:

{
  home.packages = [ pkgs.wezterm ];

  xdg.configFile."wezterm/wezterm.lua".source = ./config.lua;

  programs.zsh.initExtra = ''
    source "${pkgs.wezterm}/etc/profile.d/wezterm.sh"
  '';
}

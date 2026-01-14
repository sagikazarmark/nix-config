{ pkgs, config, ... }:

{
  programs.tmux = {
    enable = true;
  };

  catppuccin.tmux.enable = true;
}

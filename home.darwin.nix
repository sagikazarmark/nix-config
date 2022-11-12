{ pkgs, ... }:

{
  home.packages = with pkgs; [
    obsidian

    vscodium

    _1password-gui
    _1password
  ];

  xdg.configFile = {
    karabiner = {
      source = ./dotfiles/karabiner;

      # Karabiner does not work well with symlinks
      # https://karabiner-elements.pqrs.org/docs/manual/misc/configuration-file-path/#about-symbolic-link
      recursive = false;
      # onChange = "launchctl kickstart -k gui/`id -u`/org.pqrs.karabiner.karabiner_console_user_server";
    };

    skhd = {
      source = ./dotfiles/skhd;
      recursive = true;
    };

    yabai = {
      source = ./dotfiles/yabai;
      recursive = true;
    };
  };
}

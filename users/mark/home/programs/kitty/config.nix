{ lib, inputs, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "Iosevka Nerd Font"; # Previously: JetBrainsMono Nerd Font
      size = 13;
    };

    settings = {
      allow_remote_control = "yes";
    };

    keybindings = {
      # Scrolling
      "alt+k" = "scroll_line_up";
      "alt+j" = "scroll_line_down";

      "alt+ctrl+b" = "scroll_page_up";
      "alt+ctrl+f" = "scroll_page_down";

      "alt+g>alt+g" = "scroll_home";
      "alt+shift+g" = "scroll_end";

      # Font size
      "ctrl+." = "change_font_size all +2.0";
      "ctrl+minus" = "change_font_size all -2.0";
      "ctrl+backspace" = "change_font_size all 0";
    };
  };
}

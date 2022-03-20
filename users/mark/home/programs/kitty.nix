{ lib, inputs, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "Iosevka Nerd Font"; # Previously: JetBrainsMono Nerd Font
      size = 13;
    };

    colorscheme = {
      enable = true;
      override = lib.recursiveUpdate inputs.nix-colors.colorSchemes.tokyo-night-terminal-storm
        {
          colors = {
            base05 = "A9B1D6";
          };
        };
    };

    settings = {
      allow_remote_control = "yes";

      # Darwin (TODO: move this to conditional)
      open_url_modifiers = "cmd"; # TODO: normally this is ctrl
      mac_option_as_alt = "left";

      macos_titlebar_color = "#1f2335";
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

      # Darwin (TODO: move this to conditional)

      # Required for option (alt) + left/right to jump to next/previous word
      # https://github.com/kovidgoyal/kitty/issues/838#issuecomment-417455803
      "alt+left" = "send_text all \\x1b\\x62";
      "alt+right" = "send_text all \\x1b\\x66";

      # Required for option (alt) + some key combos to work
      # https://github.com/kovidgoyal/kitty/issues/1022#issuecomment-436809049
      # "alt+c" = "send_text all \x1bc";

      "cmd+plus" = "change_font_size all +2.0";
      "cmd+minus" = "change_font_size all -2.0";
      "cmd+0" = "change_font_size all 0";


      # Unmap

      ## Window management
      "kitty_mod+enter" = "no_op";
      "cmd+enter" = "no_op";

      "kitty_mod+n" = "no_op";
      "cmd+n" = "no_op";

      "kitty_mod+w" = "no_op";
      "kitty_mod+]" = "no_op";
      "kitty_mod+[" = "no_op";
      "kitty_mod+f" = "no_op";
      "kitty_mod+b" = "no_op";
      "kitty_mod+`" = "no_op";
      "kitty_mod+r" = "no_op";
      "kitty_mod+1" = "no_op";
      "kitty_mod+2" = "no_op";
      "kitty_mod+3" = "no_op";
      "kitty_mod+4" = "no_op";
      "kitty_mod+5" = "no_op";
      "kitty_mod+6" = "no_op";
      "kitty_mod+7" = "no_op";
      "kitty_mod+8" = "no_op";
      "kitty_mod+9" = "no_op";
      "kitty_mod+0" = "no_op";

      "cmd+r" = "no_op";

      ## Tab management
      "kitty_mod+right" = "no_op";
      "kitty_mod+left" = "no_op";
      "kitty_mod+t" = "no_op";
      "kitty_mod+q" = "no_op";
      "shift+cmd+w" = "no_op";
      "kitty_mod+." = "no_op";
      "kitty_mod+," = "no_op";
      "kitty_mod+alt+t" = "no_op";

      "shift+cmd+j" = "no_op";
      "cmd+t" = "no_op";
      "cmd+w" = "no_op";
      # "shift+cmd+w" = "no_op";

      ## Layout management
      "kitty_mod+l" = "no_op";
    };
  };
}

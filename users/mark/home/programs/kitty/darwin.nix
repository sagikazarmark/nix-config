{ ... }:

{
  programs.kitty = {
    darwinLaunchOptions = [
      "--single-instance"
      "--directory=~"
    ];

    settings = {
      open_url_modifiers = "cmd"; # TODO: normally this is ctrl
      mac_option_as_alt = "left";

      macos_titlebar_color = "#1f2335";
    };

    keybindings = {
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
    };
  };
}

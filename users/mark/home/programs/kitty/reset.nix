{ ... }:

# Reset some default settings
{
  programs.kitty = {
    keybindings = {
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

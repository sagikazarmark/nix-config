{ ... }:

{
  services.xserver = {
    displayManager.gdm.wayland = true;
    displayManager.gdm.nvidiaWayland = true;
  };

  programs.xwayland.enable = true;

  services.keyd = {
    enable = true;

    configuration = {
      default = {
        text = ''
            [ids]
            *

          # Logitech MX Master 3
          -046d:4082
          -046d:b023

            [main]
            # Maps capslock to escape when pressed and control when held.
            capslock = overload(meta, esc)
        '';
      };
    };
  };
}

{ pkgs, ... }:

{
  services.xserver = {
    displayManager.gdm.wayland = true;
  };

  programs.xwayland.enable = true;

  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];

  services.keyd = {
    enable = true;

    keyboards = {
      default = {
        ids = [
          "*"

          # Logitech MX Master 3
          "-046d:4082"
          "-046d:b023"
        ];

        settings = {
          main = {
            # Maps capslock to escape when pressed and control when held.
            capslock = "overload(meta, esc)";
          };
        };
      };
    };
  };
}

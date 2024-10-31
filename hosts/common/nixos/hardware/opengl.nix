{ ... }:

{
  hardware.opengl = {
    enable = true;
    # extraPackages = with pkgs; [ amdvlk ];
    driSupport = true;
    # driSupport32Bit = true;
  };
}

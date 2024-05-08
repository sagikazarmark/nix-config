{ config, pkgs, ... }:

{
  environment.systemPackages = [
    # Install skhd for manual invocations (the module does not install it in path)
    pkgs.skhd
  ];
  services.skhd.enable = true;

  services.yabai = {
    enable = true;
    enableScriptingAddition = false;

    package = pkgs.yabai;

    # package = pkgs.yabai.overrideAttrs (finalAttrs: previousAttrs: {
    #   src = ./bin/yabai-v5.0.1.tar.gz;
    # });
  };

  services.jankyborders.enable = true;
}

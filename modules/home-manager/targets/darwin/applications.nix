{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  appsEnv = pkgs.buildEnv {
    name = "home-manager-applications";
    paths = config.home.packages;
    pathsToLink = [ "/Applications" ];
  };
  apps = "${appsEnv}/Applications";
in
{
  # macOS tools (eg. Raycast) don't work well with symlinked directories
  config = mkIf pkgs.stdenv.hostPlatform.isDarwin {
    home.activation.linkApplications = hm.dag.entryAfter [ "writeBoundary" ] ''
      linkApplications() {
        rm -rf ${config.xdg.dataHome}/Applications || :
        mkdir -p ${config.xdg.dataHome}/Applications

        local f
        find -L "${apps}" -maxdepth 1 -name "*.app" -printf '%P\0' | while IFS= read -rd "" f; do
          $DRY_RUN_CMD ln -Tsf $VERBOSE_ARG "${apps}/$f" "${config.xdg.dataHome}/Applications/$f"
        done
      }
      linkApplications
    '';
  };
}

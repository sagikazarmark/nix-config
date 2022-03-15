{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.zsh;

  relToDotDir = file: (optionalString (cfg.dotDir != null) (cfg.dotDir + "/")) + file;

in
{
  options = {
    programs.zsh.zprofileExtraFirst = mkOption {
      default = "";
      type = types.lines;
      description = "Commands that should be added to the very beginning of <filename>.zprofile</filename>.";
    };

    programs.zsh.zprofileExtra = mkOption {
      default = "";
      type = types.lines;
      description = "Commands that should be added to <filename>.zprofile</filename>.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.file."${relToDotDir ".zprofile"}".text = ''
        ${cfg.zprofileExtraFirst}

        # Nix profile
        # . "${config.home.profileDirectory}/etc/profile.d/nix.sh"

        # Home Manager session variables
        . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"

        ${cfg.zprofileExtra}
      '';
    }
  ]);
}

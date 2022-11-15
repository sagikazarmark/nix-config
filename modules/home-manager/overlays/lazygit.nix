{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.lazygit;

  aliases = {
    # lg = "${pkgs.lazygit}/bin/lazygit";
    lg = "lazygit";
  };
in
{
  options = {
    programs.lazygit = {
      enableShellAliases = mkEnableOption "enable recommended lazygit shell aliases";
    };
  };

  config = mkIf cfg.enable {
    programs.bash.shellAliases = mkIf cfg.enableShellAliases aliases;

    programs.zsh.shellAliases = mkIf cfg.enableShellAliases aliases;

    programs.fish.shellAliases = mkIf cfg.enableShellAliases aliases;

    programs.lazygit.settings = mkIf cfg.enable (mkMerge [
      (mkIf config.programs.git.signing.signByDefault {
        git = {
          commit = {
            signOff = mkDefault true;
          };
        };
      })
    ]);
  };
}

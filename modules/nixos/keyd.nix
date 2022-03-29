# https://github.com/NixOS/nixpkgs/pull/158793
{ config, lib, pkgs, ... }:

with lib;

{
  meta = {
    maintainers = [ "cidkid" ];
  };

  options = {
    services.keyd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable keyd daemon for remapping keys
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.keyd;
        defaultText = literalExpression "pkgs.keyd";
        description = ''
          KeyD Package to use
        '';
      };

      configuration = mkOption {
        type = types.attrsOf (types.submodule ({ config, options, ... }: {
          options = {
            text = mkOption {
              type = types.lines;
              default = null;
            };
          };
        }));

        default = { };

        description = ''
          What the filename should be for configuration files for keyd (Multiple are allowed in keyd)
        '';
      };
    };
  };

  config = mkIf config.services.keyd.enable {
    users.groups.keyd = {
      gid = 994;
    };
    environment = {
      etc = lib.attrsets.mapAttrs' (name: cfg: nameValuePair "keyd/${name}.conf" { text = cfg.text; }) config.services.keyd.configuration;
      systemPackages = [ config.services.keyd.package ];
    };

    systemd.services.keyd = {
      description = "key remapping daemon";
      wantedBy = [ "sysinit.target" ];
      requires = [ "local-fs.target" ];
      after = [ "local-fs.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${config.services.keyd.package}/bin/keyd";
      };
    };
  };
}

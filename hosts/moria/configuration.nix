{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    inputs.sops-nix.nixosModules.sops
    inputs.matrix-appservices.nixosModule

    ../common/boot/efi.nix
    ../common/i18n.nix
    ../common/services/ssh.nix
    ../common/shell.nix

    # Users
    ../../users/mark/system
  ];

  networking.hostName = "moria";
  networking.domain = "skm.casa";

  security.pam.enableSSHAgentAuth = true;
  security.pam.services.sudo.sshAgentAuth = true;

  security.acme = {
    defaults = {
      email = "mark@sagikazarmark.hu";

      # DNS in my case caches negative results and causes DNS propagation check to fail
      extraLegoFlags = [ "--dns.disable-cp" ];
    };

    acceptTerms = true;
  };

  services.postgresql.enable = true;

  services.postgresql.initialScript = pkgs.writeText "synapse-init.sql" ''
    CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
    CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
      TEMPLATE template0
      LC_COLLATE = "C"
      LC_CTYPE = "C";
  '';

  services.matrix-synapse = {
    enable = true;

    settings = {
      server_name = "sagikazarmark.hu";
      # registration_shared_secret = "<from secret>";
      public_baseurl = "https://matrix.sagikazarmark.hu/";
      # tls_certificate_path = "/var/lib/acme/matrix.sagikazarmark.hu/fullchain.pem";
      # tls_private_key_path = "/var/lib/acme/matrix.sagikazarmark.hu/key.pem";
      #

      database = {
        name = "psycopg2";
        args = {
          user = "matrix-synapse";
          database = "matrix-synapse";
        };
      };

      listeners = [
        {
          port = 8008;
          bind_addresses = [ "::1" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [{
            names = [ "client" "federation" ];
            compress = true;
          }];
        }
        # {
        #   # federation
        #   bind_addresses = [
        #     "::"
        #     "0.0.0.0"
        #   ];
        #   port = 8448;
        #   resources = [
        #     { compress = true; names = [ "client" ]; }
        #     { compress = false; names = [ "federation" ]; }
        #   ];
        #   tls = true;
        #   type = "http";
        #   x_forwarded = false;
        # }
        # {
        #   # client
        #   port = 8008;
        #   resources = [
        #     { compress = true; names = [ "client" ]; }
        #   ];
        #   tls = false;
        #   type = "http";
        #   x_forwarded = true;
        # }
      ];
      extraConfig = ''
        max_upload_size: "100M"
      '';
      extraConfigFiles = [
        config.sops.secrets.matrix-reg-shared-secret.path
      ];
    };
  };

  sops = {
    defaultSopsFile = ./../../secrets/sops.yaml;

    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      matrix-reg-shared-secret = {
        owner = config.users.users.matrix-synapse.name;
        group = config.users.users.matrix-synapse.group;
        restartUnits = [ "matrix-synapse.service" ];
        mode = "0440";
      };
    };
  };

  services.matrix-appservices = {
    addRegistrationFiles = true;

    homeserverURL = "http://localhost:8008";
    homeserverDomain = "sagikazarmark.hu";

    services = {
      facebook = {
        port = 29185;
        format = "mautrix-python";
        package = (pkgs.mautrix-facebook.overrideAttrs (o: {
          buildInputs = [ pkgs.python3.pkgs.aiosqlite ];
        }));
      };
    };
  };

  services.nginx = {
    enable = true;

    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts."matrix.sagikazarmark.hu" = {
      forceSSL = true;
      enableACME = true;
      # useACMEHost = "skm.casa";

      # Forward all Matrix API calls to the synapse Matrix homeserver. A trailing slash
      # *must not* be used here.
      locations."/_matrix".proxyPass = "http://[::1]:8008";
      # Forward requests for e.g. SSO and password-resets.
      locations."/_synapse/client".proxyPass = "http://[::1]:8008";

      extraConfig = ''
        proxy_buffering off;
      '';
    };

    virtualHosts."element.sagikazarmark.hu" = {
      forceSSL = true;
      enableACME = true;
      # useACMEHost = "skm.casa";

      root = pkgs.element-web.override {
        conf = {
          default_server_config = {
            "m.homeserver" = {
              base_url = "https://matrix.sagikazarmark.hu/";
            };
          };
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}

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

    ./services/n8n.nix
    ./services/status.nix

    # Users
    ../../users/mark/system
  ];

  networking.hostName = "moria";
  networking.domain = "skm.casa";

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "n8n"
  ];

  security.pam = {
    sshAgentAuth.enable = true;

    services.sudo.sshAgentAuth = true;
  };

  security.acme = {
    defaults = {
      email = "mark@sagikazarmark.hu";

      # DNS in my case caches negative results and causes DNS propagation check to fail
      # Custom DNS resolver is needed due to local DNS
      extraLegoFlags = [ "--dns.resolvers" "1.1.1.1" ];
    };

    acceptTerms = true;
  };

  sops = {
    defaultSopsFile = ./../../secrets/sops.yaml;

    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = { };
  };

  services.nginx = {
    enable = true;

    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
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

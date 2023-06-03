{ ... }:

{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;

    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
    };
  };
}

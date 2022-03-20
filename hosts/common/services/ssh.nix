{ ... }:

{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;

    openFirewall = true;
    permitRootLogin = "no";
  };
}

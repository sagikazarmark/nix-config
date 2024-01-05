{ ... }:

{
  services.uptime-kuma = {
    enable = true;
  };

  services.nginx = {
    # https://github.com/louislam/uptime-kuma/wiki/Reverse-Proxy#nginx
    virtualHosts."status.skm.casa" = {
      forceSSL = true;
      enableACME = true;
      # useACMEHost = "skm.casa";

      locations."/" = {
        proxyPass = "http://127.0.0.1:3001";
        proxyWebsockets = true;
      };
    };
  };
}

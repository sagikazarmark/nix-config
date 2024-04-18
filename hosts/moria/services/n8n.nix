{ config, ... }:

{
  services.n8n = {
    enable = true;

    webhookUrl = "https://n8n.skm.casa";

    settings = {
      generic = {
        timezone = config.time.timeZone;
      };
      endpoints = {
        metrics = {
          enable = true;
        };
      };
    };
  };

  services.nginx = {
    # https://github.com/louislam/uptime-kuma/wiki/Reverse-Proxy#nginx
    virtualHosts."n8n.skm.casa" = {
      forceSSL = true;
      enableACME = true;
      # useACMEHost = "skm.casa";


      locations."~ ^/(webhook|webhook-test)" = {
        proxyPass = "http://127.0.0.1:${toString config.services.n8n.settings.port}";

        extraConfig = ''
          chunked_transfer_encoding off;
          proxy_buffering off;
          proxy_cache off;
        '';
      };

      locations."~ ^/rest/oauth2-credential/callback" = {
        proxyPass = "http://127.0.0.1:${toString config.services.n8n.settings.port}";

        extraConfig = ''
          chunked_transfer_encoding off;
          proxy_buffering off;
          proxy_cache off;
        '';
      };

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.n8n.settings.port}";
        proxyWebsockets = true;

        extraConfig = ''
          chunked_transfer_encoding off;
          proxy_buffering off;
          proxy_cache off;

          allow 192.168.1.0/24;
          deny all;
        '';
      };
    };
  };
}

{ ... }:

{
  services.tailscale = {
    enable = true;

    extraSetFlags = [
      # https://nixos.wiki/wiki/Tailscale#Tailscale_bypasses_the_firewall_for_all_incoming_traffic_on_tailscale0
      "--netfilter-mode=nodivert"

      # https://github.com/tailscale/tailscale/issues/4254#issuecomment-2952876707
      "--accept-dns=false"
    ];
  };
}

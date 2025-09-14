{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    virt-manager
    virtualbox
  ];
}

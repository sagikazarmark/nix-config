{ config, pkgs, ... }:

{
  security.pam.enableSudoTouchIdAuth = true;
}

# Custom defaults
{ lib, ... }:

{
  # Enable CUPS to print documents.
  services.printing.enable = lib.mkDefault true;
}

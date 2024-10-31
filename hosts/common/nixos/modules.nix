{ inputs, ... }:

{
  imports = [
    inputs.catppuccin.nixosModules.catppuccin;
  ];
}

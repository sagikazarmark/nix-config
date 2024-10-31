{ config, lib, pkgs, modulesPath, inputs, pkgs-unstable, ... }:

{
  imports = [
    ./generated.nix

    inputs.hardware.nixosModules.asus-zephyrus-ga503

    # ../../common/hardware/opengl.nix
  ];

  boot.initrd.luks.devices = {
    nixos-enc = {
      device = "/dev/nvme0n1p2";
      preLVM = true;

      # According to the documentation this setting has security implications.
      # https://search.nixos.org/options?channel=unstable&show=boot.initrd.luks.devices.%3Cname%3E.allowDiscards&from=0&size=50&sort=relevance&type=packages&query=boot.initrd.luks.devices
      # https://wiki.archlinux.org/title/Dm-crypt/Specialties#Discard/TRIM_support_for_solid_state_drives_(SSD)
      allowDiscards = true;
    };
  };

  networking.interfaces.enp3s0.useDHCP = true;

  # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.asusd.enable = true;

  hardware.bluetooth.enable = true;

  boot.kernelParams = [
    # Required to make OpenCL (and Davinci Resolve) work
    # https://github.com/NixOS/nixpkgs/issues/325378#issuecomment-2212732797
    # https://github.com/NixOS/nixpkgs/issues/324252#issuecomment-2205385051
    "nvidia.NVreg_EnableGpuFirmware=0"
  ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;

    powerManagement = {
      enable = true;
      finegrained = true;
    };

    # Required to make OpenCL (and Davinci Resolve) work
    open = false;

    # Required for Wayland
    modesetting.enable = true;
    nvidiaSettings = true;
  };

  hardware.opengl = {
    enable = true;
    # driSupport = true;
    # driSupport32Bit = true;
    extraPackages = with pkgs; [
      ocl-icd
      # rocmPackages.clr.icd
    ];
  };
}

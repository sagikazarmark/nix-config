# My Nix(OS) configurations

[![System](https://github.com/sagikazarmark/nix-config/workflows/System/badge.svg)](https://github.com/sagikazarmark/nix-config/actions)
[![Home](https://github.com/sagikazarmark/nix-config/workflows/Home/badge.svg)](https://github.com/sagikazarmark/nix-config/actions)

This repository hosts my [NixOS](https://nixos.org/) and [home-manager](https://github.com/nix-community/home-manager) configurations.


## Installation

### Preparation

Download the latest [ISO image](https://nixos.org/download.html#nixos-iso) and create a bootable USB key.

Turn off Secure Boot if it's enabled.

Before installing NixOS on a brand new computer, read the [Preparing a new machine](#preparing-a-new-machine) section.

#### Performing installation remotely over SSH

When moving to a new machine with access to an existing one,
it's easier to perform the installation remotely (eg. to sync hardware configuration).

After booting into the installer, set a password for the `nixos` user:

```shell
passwd
# Enter a new password when asked (eg. "nixos" to make things simple)
```

Then figure out your IP address:

```shell
ifconfig
```

SSH into the live environment from your existing machine:

```shell
ssh nixos@YOUR_IP
# Enter password when asked
```

---

**Important:** all commands below are expected to run as root.

**Pro tip:** Set the keymap to `hu` when using a Hungarian keyboard:
```shell
loadkeys hu
```

### Partitioning

**Note**: Replace `/dev/sda` below with your appropriate device.
In case of an NVMe SSD this could be `/dev/nvme0n1`.

You can use the `lsblk` command to detect devices in your system.

Create a partition table:

```shell
parted /dev/sda -- mklabel gpt
```

Create a boot partition:

```shell
parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
parted /dev/sda -- set 1 esp on
```

#### Unencrypted root (and swap) partition

Create a root partition:

```shell
parted /dev/sda -- mkpart primary 512MiB -8GiB
```

Create a swap partition:

```shell
parted /dev/sda -- mkpart primary linux-swap -8GiB 100%
```

**Note:** Swap size depends on the amount of RAM.


#### Encrypted root (and swap) partition with LVM

Create a partition using the rest of the disk space:

```shell
parted /dev/sda -- mkpart primary 512MiB 100%
```

Set up LUKS:

```shell
cryptsetup luksFormat /dev/sda2
# Enter a new passphrase when asked
```

Open the encrypted partition:

```shell
cryptsetup open /dev/sda2 nixos-enc
# Enter passphrase when asked
```

Create LVM physical volume:

```shell
pvcreate nixos-vg /dev/mapper/nixos-enc
```

Create LVM volume group:

```shell
vgcreate nixos-vg /dev/mapper/nixos-enc
```

Create a swap volume:

```shell
lvcreate -L 8G -n swap nixos-vg
```

**Note:** Swap size depends on the amount of RAM.

Create a root volume:

```shell
lvcreate -l 100%FREE -n root nixos-vg
```

### Filesystems

Reminder: this is how partitions look like based on different scenarios:

|                | Unencrypted | Unencrypted NVMe | Encrypted LVM      | Encrypted NVMe LVM |
|----------------|-------------|------------------|--------------------|--------------------|
| Boot partition | /dev/sda1   | /dev/nvme0n1p1   | /dev/sda1          | /dev/nvme0n1p1     |
| Root partition | /dev/sda2   | /dev/nvme0n1p2   | /dev/nixos-vg/root | /dev/nixos-vg/root |
| Swap partition | /dev/sda3   | /dev/nvme0n1p3   | /dev/nixos-vg/swap | /dev/nixos-vg/swap |

Create FAT32 filesystem for the boot partition:

```shell
mkfs.fat -F 32 -n boot /dev/sda1
```

Create EXT4 filesystem for the root partition:

```shell
mkfs.ext4 -L nixos /dev/sda2
```

Set up swap:

```shell
mkswap -L swap /dev/sda3
```

### Preparing for installation

Mount the target file system on which NixOS should be installed on `/mnt`:

```shell
mount /dev/disk/by-label/nixos /mnt
```

Mount the boot file system on `/mnt/boot`:

```shell
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
```

Turn swap on:

```shell
swapon /dev/disk/by-label/swap
```

Generate the initial config for your system:

```shell
nixos-generate-config --root /mnt
```

This is useful to detect the hardware in your system that will result in a file: `/mnt/etc/nixos/hardware-configuration.nix`

Launch a new shell with git installed:

```shell
nix-shell -p git
```

**Important:** For the time being you need to use `nixUnstable`, so the above command changes to:

```shell
nix-shell -p git nixUnstable
```

Checkout this repository:

```shell
git clone https://github.com/sagikazarmark/nix-config.git
cd nix-config
```

Synchronize the content of `/mnt/etc/nixos/hardware-configuration.nix` with the same file under `hosts/HOSTNAME/` in this repo.

When disk encryption is enabled, make sure to add the following (or similar) configuration to `hosts/HOSTNAME/hardware-configuration.nix`:

```shell
nano /mnt/etc/nixos/hardware-configuration.nix
```

```nix
{
  "..."

  boot.initrd.luks.devices = {
      nixos-enc = {
         device = "/dev/disk/by-id/<disk-name>-part2";
         allowDiscards = true;
      };
  };
}
```

Make sure to push the changes in your repository.

**Tip:** If the installation is performed remotely over SSH, you can make the changes on your local machine and pull them once they are available in the upstream repository.

You can remove the generate configuration if you want to:

```shell
rm -rf /mnt/etc/nixos/*
```

### Installing NixOS

Run the following command to install NixOS:

```shell
nixos-install --no-root-passwd --flake .#YOUR_HOSTNAME
```

Once the installation is ready, you can reboot the computer:

```shell
reboot
```

### Setting up the user environment

After booting your new NixOS for the first time, login to your user.

Checkout this repository again:

```shell
git clone https://github.com/sagikazarmark/nix-config.git
cd nix-config
```

Run the following command to bootstrap your home environment:

```shell
nix run --no-write-lock-file github:nix-community/home-manager/release-21.11 -- switch --flake .
```

Enjoy!


## Preparing a new machine

When installing NixOS for the first time, make sure you complete the following steps before completing the install guide:

1. Figure out a hostname for your machine.
1. Create a new system configuration under `nixosConfigurations` in `flake.nix`.
1. Create a new directory under `hosts/` for your new host.
1. Create a new home configuration under `homeConfigurations` in the form of `user@host`.

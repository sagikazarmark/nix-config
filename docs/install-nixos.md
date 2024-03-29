# Installing NixOS

## Preparation

Download the latest [ISO image](https://nixos.org/download.html#nixos-iso) and create a bootable USB key.

Turn off Secure Boot if it's enabled.

Before installing NixOS on a brand new computer, read the [Preparing a new machine](#preparing-a-new-machine) section.

### Connecting to the internet

The installer needs a working internet connection in order to download packages,
but it also makes remote installation possible through SSH.

For supported interfaces, wired connections should work automatically.

To connect to a wireless network, follow one of the following options:

**Option 1:**

```shell
wpa_passphrase ESSID KEY | sudo tee /etc/wpa_supplicant.conf
sudo systemctl restart wpa_supplicant
```

**Option 2:**

Start the `wpa_supplicant` service:

```shell
sudo systemctl start wpa_supplicant
```

Enter a `wpa_cli` prompt:

```shell
wpa_cli
```

Run the following commands:

```shell
add_network
set_network 0 ssid "myhomenetwork"
set_network 0 psk "mypassword"
set_network 0 key_mgmt WPA-PSK
enable_network 0
```

Exit `wpa_cli`:

```shell
quit
```

### Performing installation remotely over SSH

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

## Partitioning

**Note**: Replace `/dev/sda` below with your appropriate device.
In case of an NVMe SSD this could be `/dev/nvme0n1`.

> You can use the `lsblk` to detect devices in your system.

Launch a new `parted` prompt:

```shell
parted /dev/sda
```

Create a new partition table:

```shell
mklabel gpt
```

Create a boot partition:

```shell
mkpart ESP fat32 1MiB 512MiB
set 1 esp on
```

⚠️⚠️⚠️ **Make sure you follow the right section below.** ⚠️⚠️⚠️

### Unencrypted root (and swap) partition

Create a root partition:

```shell
mkpart primary 512MiB -8GiB
```

Create a swap partition:

```shell
mkpart primary linux-swap -8GiB 100%
```

**Note:** Swap size depends on the amount of RAM.

Exit `parted`:

```shell
quit
```

### Encrypted root (and swap) partition with LVM

Create a partition using the rest of the disk space:

```shell
mkpart primary 512MiB 100%
```

Exit `parted`:

```shell
quit
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

## Filesystems

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

## Preparing for installation

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

## Installing NixOS

Run the following command to install NixOS:

```shell
nixos-install --no-root-passwd --flake .#YOUR_HOSTNAME
```

Go and get yourself a cup of coffee while Nix does it's thing. ☕

Once the installation is ready, you can reboot the computer:

```shell
reboot
```

## Setting up the user environment

After booting your new NixOS for the first time, login to your user.

Checkout this repository again:

```shell
git clone https://github.com/sagikazarmark/nix-config.git
cd nix-config
```

Run the following command to bootstrap your home environment:

```shell
nix run --no-write-lock-file github:nix-community/home-manager/release-22.05 -- switch --flake .
```

Enjoy!

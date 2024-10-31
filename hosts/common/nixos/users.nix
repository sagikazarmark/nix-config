{ ... }:

{
  # You might still get asked for a root password during install despite this setting.
  # https://github.com/NixOS/nixpkgs/issues/95778
  users.mutableUsers = false;
  users.users.root.hashedPassword = "$6$pM4IARjHjdHpQOcl$B/9uv4QH9J38ImeRgAyqHhI5WDHZpCCNcKyRDV2f.iqL8wMvGZ38H.zAyqiCUoBD/8YMPvnTiOvncUOZorw6z.";
}

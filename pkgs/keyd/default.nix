# https://github.com/NixOS/nixpkgs/pull/158793
{ lib, stdenv, python39Packages, python39, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "keyd";
  version = "2.3.1-rc";

  src = fetchFromGitHub {
    owner = "rvaiya";
    repo = "keyd";
    rev = "v${version}";
    sha256 = "sha256-mb42IazLFOWYH0fDnNcMOpsq9X0xjWDfWyjszRGbwU8=";
  };

  makeFlags = [ "DESTDIR=${placeholder "out"}" "PREFIX=" ];

  buildInputs = [ python39 python39Packages.xlib ];

  meta = with lib; {
    homepage = "https://github.com/rvaiya/keyd";
    description = "A key remapping daemon for linux";
    longDescription = ''
      Keyd has several unique features many of which are traditionally
      only found in custom keyboard firmware like QMK as well as some
      which are unique to keyd.
      It expects a configuration file at /etc/keyd/default.conf. For
      more details check out the homepage.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya cidkid ];
    platforms = platforms.linux;
  };
}

{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "lr-tech-rofi-themes";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "lr-tech";
    repo = "rofi-themes-collection";
    rev = "5ae9b23ef58893229b0df57ad750ad84801a632e";
    sha256 = "sha256-ecCQcDVWXpSilER99OROW9wutIq58llUGjFTn9rH2RM=";
  };

  dontUnpack = true;
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;


  installPhase = ''
    mkdir -p $out/share/rofi/themes

    cp $src/themes/* $out/share/rofi/themes/
  '';
}

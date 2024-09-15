{ stdenv, pkgs, ... }:
let version = "0.0.1";
in stdenv.mkDerivation {

  name = "binwarden-${version}";

  src = ./src;

  buildInputs = [ pkgs.makeWrapper ];
  phases = [ "unpackPhase" "installPhase" "postInstall" ];

  installPhase = ''
    mkdir -p $out/binwarden
    cp -r $src/* $out/binwarden
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -fs "$out/binwarden/bin/binwarden" $out/bin/binwarden
  '';
}

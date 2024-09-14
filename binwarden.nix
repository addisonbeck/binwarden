{ stdenv, pkgs }:

let version = "0.0.1";
in stdenv.mkDerivation {

  name = "binwarden-${version}";

  src = ./src;

  nativeBuildInputs = [ ];
  buildInputs = [ pkgs.makeWrapper ];

  buildPhase = "";

  installPhase = ''
    cp -r $src $out
  '';
}

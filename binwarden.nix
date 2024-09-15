{ stdenv }:

let version = "0.0.1";
in stdenv.mkDerivation {

  name = "binwarden-${version}";

  src = ./src;

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r $src/d $out/
    install -D $src/bin/binwarden $out/bin
  '';
}

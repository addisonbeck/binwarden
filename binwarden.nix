{ stdenv }:

let version = "0.0.1";
in stdenv.mkDerivation {

  name = "binwarden-${version}";

  src = ./src;

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/binwarden
    cp -r $src/* $out/binwarden
  '';

  postFixup = ''
    wrapProgram $out/binwarden/bin/b --prefix PATH : $out/bin
  '';
}

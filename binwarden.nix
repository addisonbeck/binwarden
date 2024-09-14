{ stdenv, pkgs }:

let version = "0.0.1";
in stdenv.mkDerivation {

  name = "d-${version}";

  src = ./src;

  nativeBuildInputs = [ ];
  buildInputs = [ pkgs.makeWrapper ];

  buildPhase = "";

  installPhase = ''
    mkdir -p $out/binwarden/
    cp -r $src $out/binwarden
    install -D $src/bin/b $out/binwarden/bin/b
  '';

  postFixup = ''
     wrapProgram $out/binwarden/bin/b --prefix PATH : $out/bin
  '';
}

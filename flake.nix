{
  description = "A Bitwarden development automation toolbox";

  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; };

  outputs = { self, nixpkgs }:
    let
      systems =
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    in {
      packages = builtins.listToAttrs (builtins.map (system: {
        name = system;
        value = rec {
          binwarden =
            nixpkgs.legacyPackages.${system}.callPackage ./binwarden.nix { };
          default = binwarden;
        };
      }) systems);
    };
}

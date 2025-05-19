{
  description = "A Bitwarden development automation toolbox";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        devShells.default = pkgs.mkShell {
          name = "clients-devshell";

          buildInputs = with pkgs; [
            git
            openssh
            bash
            just
          ];

          shellHook = ''
            echo "Welcome to the Bitwarden Clients Devshell!"
            just --list
          '';

          packages = [ ];
        };
      });
}

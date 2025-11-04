let
  sources = import ./sources.nix;
in
{
  system ? builtins.currentSystem,
  nixpkgs ? sources.nixpkgs,
}:
let
  pkgs = import nixpkgs { inherit system; };
  inherit (pkgs) lib;
in
lib.fix (self: {
  mkFOD = pkgs.callPackage ./mkFOD { };

  fetchFromBuzzheavier = pkgs.callPackage ./fetchFromBuzzheavier {
    inherit (self) mkFOD;
  };
  fetchFromMega = pkgs.callPackage ./fetchFromMega {
    inherit (self) mkFOD;
  };
  fetchFromGofile = pkgs.callPackage ./fetchFromGofile {
    inherit (self) mkFOD;
  };

  tests.fetchFromGofile = pkgs.callPackage ./tests/fetchFromGofile.nix {
    inherit (self) fetchFromGofile;
  };

  # tests = {
  #   fetchFromMega = {
  #     folder = pkgs.callPackage ./tests/fetchFromMega/folder.nix {
  #       inherit (self) fetchFromMega;
  #     };
  #     file = pkgs.callPackage ./tests/fetchFromMega/file.nix {
  #       inherit (self) fetchFromMega;
  #     };
  #     folder-file = pkgs.callPackage ./tests/fetchFromMega/folder-file.nix {
  #       inherit (self) fetchFromMega;
  #     };
  #     folder-folder = pkgs.callPackage ./tests/fetchFromMega/folder-folder.nix {
  #       inherit (self) fetchFromMega;
  #     };
  #   };
  #   fetchFromBuzzheavier = {
  #     notFound = pkgs.callPackage ./tests/fetchFromBuzzheavier/notFound.nix {
  #       inherit (self) fetchFromBuzzeavier;
  #     };
  #   };
  # };
})

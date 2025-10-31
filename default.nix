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
  callPackageSet = lib.callPackageWith (pkgs // pkgSet);
  pkgSet = {
    mkFOD = callPackageSet ./mkFOD { };
    fetchFromBuzzheavier = callPackageSet ./fetchFromBuzzheavier { };
    fetchFromMega = callPackageSet ./fetchFromMega { };
    fetchFromGofile = callPackageSet ./fetchFromGofile { };
  };
in
pkgSet

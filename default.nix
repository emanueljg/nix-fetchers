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
    mkFOD = callPackageSet ./mkFOD.nix { };
    fetchFromBuzzheavier = callPackageSet ./fetchFromBuzzheavier { };
    fetchFromMega = callPackageSet ./fetchFromMega { };
  };
in
pkgSet

let sources = import ./sources.nix;
in {
  system ? builtins.currentSystem,
  nixpkgs ? sources.nixpkgs 
}: let
  pkgs = import nixpkgs { inherit system; };
  inherit (pkgs) lib;
  callPackageSet = lib.callPackageWith (pkgs // pkgSet);
  pkgSet = {
    mkCheckedFOD = callPackageSet ./mkCheckedFOD.nix { };
    fetchFromBuzzheavier = callPackageSet ./fetchFromBuzzheavier { };
  };
in pkgSet
  

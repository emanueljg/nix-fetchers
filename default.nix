{
  system ? builtins.currentSystem,
  
  nixpkgs ? builtins.fetchTree {
    type = "github";
    owner = "nixos";
    repo = "nixpkgs";
    ref = "nixos-unstable";
    narHash = "";
  }
}: let
  pkgs = import nixpkgs { inherit system; };
  callPackageSet = lib.callPackageWith (pkgs // pkgSet);
  pkgSet = {
    mkCheckedFOD = callPackageSet ./mkCheckedFOD.nix { };
    fetchFromBuzzheavier = callPackageSet ./fetchFromBuzzheavier { };
  };
      
in pkgSet
  

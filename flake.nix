{
  description = "A collection of custom Nix fetchers";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }@inputs:
    let
      inherit (nixpkgs) lib;
      systemPkgs = lib.getAttrs [ "x86_64-linux" ] nixpkgs.legacyPackages;
    in
    {
      lib = builtins.mapAttrs (_: pkgs: {
        fetchFromItch = pkgs.callPackage ./fetchFromItch { };
        fetchFromBuzzHeavier = pkgs.callPackage ./fetchFromBuzzHeavier { };
      }) systemPkgs;
    };
}

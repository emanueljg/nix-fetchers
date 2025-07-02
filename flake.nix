{
  description = "fetch-from-itch is a Nix FOD fetcher for free itch.io games.";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }@inputs:
    let
      systems = [
        "x86_64-linux"
      ];

      forAllSystems = f:
        inputs.nixpkgs.lib.genAttrs
          systems
          (system: f nixpkgs.legacyPackages.${system});
    in
    {
      lib = forAllSystems (pkgs: {
        fetchFromItch = pkgs.callPackage ./. { };
      });
      packages = forAllSystems (pkgs: {
        test = pkgs.callPackage ./test.nix { inherit (self.lib.${pkgs.system}) fetchFromItch; };
      });
    };
}

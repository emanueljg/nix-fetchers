{
  nixpkgs = builtins.fetchTree {
    type = "github";
    owner = "nixos";
    repo = "nixpkgs";
    ref = "nixos-unstable";
    narHash = "";
  };
}

{
  # track: nixos-unstable
  nixpkgs = builtins.fetchTree {
    type = "github";
    owner = "nixos";
    repo = "nixpkgs";
    rev = "08dacfca559e1d7da38f3cf05f1f45ee9bfd213c";
    narHash = "";
  };
}

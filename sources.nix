{
  # track: nixos-unstable
  nixpkgs = builtins.fetchTree {
    type = "github";
    owner = "nixos";
    repo = "nixpkgs";
    rev = "08dacfca559e1d7da38f3cf05f1f45ee9bfd213c";
    narHash = "sha256-o9KF3DJL7g7iYMZq9SWgfS1BFlNbsm6xplRjVlOCkXI=";
  };
}

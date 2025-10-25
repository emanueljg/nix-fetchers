{
  nixpkgs = builtins.fetchTree {
    type = "tarball";
    url = "https://github.com/NixOS/nixpkgs/tarball/nixos-unstable";
    narHash = "";
  };  
}

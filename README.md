# nix-fetchers

`nix-fetchers` is a bunch of Nix fetchers for unconventional derivation sources.

## Available fetchers

- `nix-fetchers.fetchFromMega` ([mega.nz](https://mega.nz/))
- `nix-fetchers.fetchFromGofile` ([gofile.io](https://gofile.io/))
- `nix-fetchers.fetchFromBuzzheavier` ([buzzheavier.com](https://buzzheavier.com))

## Installation

```nix
let
  nix-fetchers = import (builtins.fetchTree {
    type = "github";
    owner = "emanueljg";
    repo = "nix-fetchers";
    rev = "...";
    narHash = "";
  }) {
    # optional args:
    # system = ...;  # builtins.currentSystem by default
    # nixpkgs = ...;  # a nixpkgs pin of nixos-unstable by default
  };
in ...
```
No flake is provided since I consider it to be pointless for this type of project.    

## Usage

### `nix-fetchers.fetchFromMega`

Fetches a [mega.nz](https://mega.nz/) download link using [megatools](https://xff.cz/megatools/). 

Megatools expects a strange URL format which isn't the one you see in a _Share_ window or the address bar. The fetcher
takes care of the conversion to that format for you, so just paste what mega.nz gives you and it'll hopefully work.

If given a mega.nz directory containing a bunch of entries, `$out` will contain all those entries. 
If given a mega.nz file, `$out` will be that downloaded file.


```nix
nix-fetchers.fetchFromMega {
  # may or may not contain baseUrl, i.e. both of these work: 
  # - "https://mega.nz/folder/zGJT1QQQ#O-8yiH845GN26ajAvkoLkA"
  # - "folder/zGJT1QQQ#O-8yiH845GN26ajAvkoLkA"
  item = "https://mega.nz/folder/zGJT1QQQ#O-8yiH845GN26ajAvkoLkA";\
  hash = lib.fakeHash;

  # OPTIONAL, "https://mega.nz" by default
  # baseUrl = "..."; 
};
```

### `nix-fetchers.fetchFromGofile`

TBD

### `nix-fetchers.fetchFromBuzzheavier`

TBD

## Notes

###  On overriding a fetcher 
All of the following fetchers are created using `lib.extendMkDerivation` and as such
support fix-point referencing. Plenty of these are used internally to make attribute overriding
more semantically intuitive and coherent. Just remember that, since these are fetchers and by extension 
fixed-output derivations, you'll have to invalidate the hash to actually tell Nix it's a different derivation you
want built.

```nix
(fetchFromMega { ... })._url
# https://mega.nz/folder/apw1412ufj...
(fetchFromMega { ... }).overrideAttrs { baseUrl = "https://zn.mega"; })._url
# https://zm.mega/folder/apw1412ufj...
```


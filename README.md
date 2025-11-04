# nix-fetchers

Nix fetchers for unconventional derivation sources.

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
  item = "https://mega.nz/folder/zGJT1QQQ#O-8yiH845GN26ajAvkoLkA";
  hash = lib.fakeHash;

  # OPTIONAL, "https://mega.nz" by default
  # baseUrl = "..."; 
};
```

### `nix-fetchers.fetchFromGofile`

Fetches one or many files from a [gofile.io](https://gofile.io) link. 

```nix
nix-fetchers.fetchFromGofile {
  # may or may not contain baseUrl, i.e. both of these work: 
  # - "https://gofile.io/d/..."
  # - "d/..."
  item = "https://gofile.io/d/...";

  # OPTIONAL, see below
  # select = ...

  # OPTIONAL, "https://gofile.io" by default
  # baseUrl = "...";
}
```

As Gofile itself does in their frontend, this script creates a guest account ad-hoc in each build.
The token for this guest account is then used in the download request.
Using your own account for download is not supported at this time.

Downloads will be urldecoded, i.e. the remote name `How%20To%20Make%20Wargames%20Terrain_2003.pdf` will save
to the file `How To Make Wargames Terrain_2003.pdf`. 

By default, the fetcher downloads all items in the download link. Optionally, this fetcher can take the attribute
`select` which allows you to instead download only a slice of one or more items. `select` is an attrset that
may contain **exactly one** name-value pair denoting how to filter the files and what the filter is.

- `select.all = true;` is the default name-value pair. If `true`, all files are downloaded. `select.all = false` is
  considered invalid input.

- `select.one = "<filename>"` downloads a single file to `$out`. No outer directory will be created. If
  this file does not exist, the build fails.
  ```nix
  select.one = "myfile.zip";
  ```

- `select.many = [ <filename-1> <filename-2> ... ]` downloads all files in the list to the directory `$out`.

  The following types of lists are considered invalid input and will fail at eval time:
    - `[ ]`, an empty list
    - `[ "file.zip" "file.zip" ]`, lists with duplicates

  If at least one file in this list does not exist, the build fails.

  Note that this attribute can be useful even if you're just downloading _one_ file, if you want the
  file contained in a directory. This pattern is especially useful in `pkgs.symlinkJoin` constructs.
  ```nix
  select.many = [
    "myfile1.zip"
    "myfile2.zip"
  ];
  ```

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


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

As Gofile itself does, this script creates a guest account for each derivation whose token is used 
in the download request. Using your own account for download is not supported at this time.

By default, the fetcher downloads all items in the download link. Optionally, this fetcher can take the attribute
`select` which allows you to instead download only a slice of one or more items. `select` is an attrset that
may contain a name-value pair denoting how to filter the files and what the filter is.

` select.all = true;` is the default name-value pair. If `true`, all files are downloaded. `select.all = false` is
  considered invalid input.

- `select.one = "<filename>"` downloads a single file to `$out`. No outer directory will be created. If
  this file does not exist, the build fails.
  `select = { one = "myfile.zip"; }`

- `select.many = [ <filename-1> ... ]` downloads all files in the list to a directory in `$out`.

  By default, if at least one entry fails to map to a download, the build fails, but it
  will keep going if you set `manyAllowSelectFail = true` and just emit a warning (default: `false`) 

  Note that this attribute can be useful even if you're just downloading _one_ file, if you want the
  file contained in an upper directory.
  ```nix
  select = {
    many = [
      "myfile1.zip"
      "myfile2.zip"
    ];
    # optional, false by default
    # allowSelectOnfail = true;
  };
  ```
- `select.jq = "<jq-expr>"` downloads all files that pass through the given `jq` expression. `jq` will be
  passed a list of JSON objects at `.data.children[]` containing all the downloaded files. Only filter the objects!
  The fetcher will take care of the final mapping to `.link`s itself.

  No checks are being made here to see that something actually match. In other words: a `jq` filter
  which produces 0 objects is still considered valid and will end up producing an empty derivation.

  By default, the file(s) filtered will be downloaded to a directory at `$out`. If you want a single file
  downloaded to `$out`, like with `select.one`, you may set `jqFirst = true;` (default: `false`). 

  `select.jqAttrs` is an attrset, empty by default, that will be passed along to `jq` as attributes.

```nix
nix-fetchers.fetchFromGofile {
  # may or may not contain baseUrl, i.e. both of these work: 
  # - "https://gofile.io/d/..."
  # - "d/..."
  item = "https://gofile.io/d/...";

  # OPTIONAL, see explanation of 'select' above
  # select = ...

  # OPTIONAL, "https://gofile.io" by default
  # baseUrl = "...";
}
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


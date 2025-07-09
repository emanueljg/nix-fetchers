# fetch-from-itch

fetch-from-itch is a Nix FOD fetcher for **free** itch.io games.

```nix
{
  # example: https://kay-yu.itch.io/holocure
  src = inputs.fetch-from-itch.lib.${system}.fetchFromItch {
    creator = "kay-yu";
    game = "holocure";
    uploadName = "HoloCure.zip";
    # hash = ...

    # see 'Authentication'
    # apiKeyPath = ...
  };
}
```

## Installation
Add to flake inputs:
```nix
fetch-from-itch = {
  url = "github:emanueljg/fetch-from-itch";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

## Authentication
Itch.io requires an API key to access most of its API, most notably generating a download URL for a game. Here's how that works with this fetcher:

1. Make sure you have an [itch.io account](https://itch.io/developers) and a generated [API key](https://itch.io/api-keys)

2. Write the secret to the file path.

    The fetcher gets the API key from reading the file located at `apiKeyPath`, which defaults to `"/run/secrets/fetchFromItch"`.
    There's multiple ways to securely write your secret to this file.

    *Recommended: Using a [secret managing scheme](https://wiki.nixos.org/wiki/Comparison_of_secret_managing_schemes)*. to put the API key safely in the NixOS configuration declaratively.  The author uses 
      [sops-nix](https://github.com/Mic92/sops-nix)  Example:
    ```nix
    { config, inputs, ... }: {

      imports = [ inputs.sops-nix.nixosModules.sops ];

      sops.secrets."fetchFromItch" = {
        group = "nixbld";
        mode = "0440"; 
      };
    }
    ```

    *Manually open $EDITOR*:
    ```sh
    sudo mkdir -p '/run/secrets' \
      && (umask 337 && sudoedit -u root -g nixbld '/run/secrets/fetchFromItch')
    ```
    *Write from clipboard on x11*:
    ```sh
    sudo mkdir -p '/run/secrets' \
      && nix-shell -p xclip --run wclip -se -c -o \ 
      | (umask 337 && sudo -u root -g nixbld tee '/run/secrets/fetchFromItch')
    ```

    *Write from clipboard on wayland*:
    ```sh
    sudo mkdir -p '/run/secrets' \
      && nix-shell -p wl-clipboard --run wl-paste \
      | (umask 337 && sudo -u root -g nixbld tee '/run/secrets/fetchFromItch')
    ```

    If you're new to managing secrets with Nix, the obvious question arises:
    Why not just put `apiKey = "129rf2jhfu8rfi...";` as a function argument?* Why must we pass a path?

    The answer is security reasons. Not only would it make sharing code on github very annoying, but when evaluating your NixOS
     system, Nix writes your secret in plain text to the
     /nix/store which is world-readable, meaning any user on your system can read it. 

     This is also why we're specifically passing a string path and not a path literal, i.e.
     ```nix
       # path literal
       apiKeyPath = /run/...;
       # string path, note the quotes
       apiKeyPath = "/run/..."; q
     ```
     because path literals are copied to the store and as such the same problem arises as with a raw string secret.

3. Pass the sandbox path to the builder

   *NixOS*
    ```nix
    { config, ... }: {
      nix.settings.sandbox-paths = [ "/run/secrets/fetchFromItch" ];
      # elegant DRY if you use sops-nix or something similar
      # nix.settings.sandbox-paths = [ config.sops.secrets."fetchFromItch".path ];
    }
    ```
    *Ad-hoc on each build:*
    ```sh
    nix build ... --extra-sandbox-paths '/run/secrets/fetchFromItch'
    ```

## How is the itch.io api used

We roughly follow the steps outlined here: https://itch.io/t/1588368/download-a-game-with-the-api:

```
Given the creator (thorbjorn) and game (tiled), get the game’s numeric id:

https://thorbjorn.itch.io/tiled/data.json - returns JSON with id 28768

Get game’s uploads using game id:

https://itch.io/api/1/API_KEY/game/28768/uploads - returns JSON array of uploads, containing id’s, display/channel names, etc of uploads.

Download upload using upload id (e.g. of windows-64bit):

curl https://itch.io/api/1/API_KEY/upload/504289/download - returns download link in JSON

That should work for free games, with API_KEY of any user. I have not tried to work with paid ones.
```

## License

MIT 

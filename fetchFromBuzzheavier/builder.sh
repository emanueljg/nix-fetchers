#!/bin/bash

# TODO look up what this does
if [ -e .attrs.sh ]; then source .attrs.sh; fi
source "${stdenv:?}/setup"

echo "Downloading BH item $item ($url)"
echo "Fetching HTML and parsing metadata...
read -r -d "\n" buzzheavier_name buzzheavier_sha1 <$(curl 'https://buzzheavier.com/frtjt00auxv5' \
  | pup 'div[x-data="App()"] span:first-child, div[x-data="App()"] li:nth-child(4) code text{}'
)

for metavar in {buzzheavier_name,buzzheavier_sha1}; do 
    echo "${!metavar@A}"
done

echo -n "useSHA1Hash is "$useSHA1Hash: " 
if [[ "$useSHA1Hash" == "true" ]]; then
  echo "using buzzheavier's hash..."
  set -x
  hash="$buzzheavier_sha1"
  hashAlgo="sha1"
  set +x
else
  echo "using nix's hash..."
  

  curl 'https://buzzheavier.com/frtjt00auxv5' | pup 'div[x-data="App()"] span:first-child, div[x-data="App()"] li:nth-child(4) code text{}'                   
else
fi

auth_token=$(cat "$apiKeyPath")

set -o nogl
api_curl=("${curl[@]}" -H "Authorization: Bearer $auth_token")

echo 'Fetching game ID...'
game_id=$("${curl[@]}" "https://$creator.itch.io/$game/data.json" | jq -r '.id')

echo 'Fetching upload ID...'
upload_id=$(
  "${api_curl[@]}" \
    "https://itch.io/api/1/key/game/$game_id/uploads" \
  | jq -r --arg upload_name "$uploadName" \
    '.uploads[] | select(.filename == $upload_name) | .id'
)

echo 'Fetching download URL...'
download_url=$(
  "${api_curl[@]}" \
    "https://itch.io/api/1/key/upload/$upload_id/download" \
  | jq -r '.url'
)

echo 'Downloading game...'
"${curl[@]}" "$download_url" -o "$out"

set +o noglob

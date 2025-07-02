#!/bin/bash

# TODO look up what this does
if [ -e .attrs.sh ]; then source .attrs.sh; fi
source "${stdenv:?}/setup"

auth_token=$(cat "$apiKeyPath")

set -o noglob

curl=(
  curl
)

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
"${curl[@]}" "$download_url" -o "$name"

set +o noglob

mv "$name" $out


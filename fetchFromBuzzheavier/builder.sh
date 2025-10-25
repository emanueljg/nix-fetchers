#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# TODO look up what this does
if [ -e .attrs.sh ]; then source .attrs.sh; fi
source "${stdenv:?}/setup"

echo "Asking Buzzheavier for download link to $item ($url)..."

download_url="$(
  curl "$url/download" \
    --head \
    --output /dev/null \
    --header "Referer: $url" \
    --write-out '%header{hx-redirect}' \
  | jq --raw '.headers."hx-redirect"[0]'
)" 

if [[ "$download_url" = 'null' ]]; then
    echo "ERROR: No download_url recieved."
    exit 1
fi

echo "Buzzheavier successfully responded with download link $download_url. Downloading..."
curl "$download_url" --output $out

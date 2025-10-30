#!/bin/bash
set -euo pipefail

# TODO look up what this does
if [ -e .attrs.sh ]; then source .attrs.sh; fi
source "${stdenv:?}/setup"

echo "Asking Buzzheavier for download link to $item ($url)..."

IFS=$'\v' read -r location download_url <<< $(
  curl "$url/download" \
    --head \
    --output /dev/null \
    --header "Referer: $url" \
    --write-out '%header{location} %header{hx-redirect}' 
) 

echo "$location" "$download_url"

if [[ -z "$download_url" ]]; then
    echo "ERROR: No download_url recieved."
    exit 1
fi

echo "Buzzheavier successfully responded with download link $download_url. Downloading..."
curl "$download_url" --output $out

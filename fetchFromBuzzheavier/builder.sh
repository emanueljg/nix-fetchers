#!/bin/bash

# TODO look up what this does
if [ -e .attrs.sh ]; then source .attrs.sh; fi
source "${stdenv:?}/setup"

echo "Asking Buzzheavier for download link to $item ($url)..."
download_url="$(
    curl "$url" \
    --head \
    --output /dev/null \
    --header "Referer: $url" \
    --write-out '%header{hx-redirect}'
)"

echo "Buzzheavier successfully responded with download link $download_url. Downloading..."
curl "$download_url" --output $out

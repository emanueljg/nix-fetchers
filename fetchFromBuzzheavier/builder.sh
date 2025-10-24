#!/bin/bash

# TODO look up what this does
if [ -e .attrs.sh ]; then source .attrs.sh; fi
source "${stdenv:?}/setup"

echo "Asking Buzzheavier for download link to $item ($url)..."
download_url="$(
    curl "$url/download" \
    --head \
    --output /dev/null \
    --header "Referer: $url" \
    --write-out '%header{hx-redirect}'
)"

if [ -z "$download_url" ]; then
    echo "ERROR: Buzzheavier gave us no $download_url on our request."
    exit 1
fi

echo "Buzzheavier successfully responded with download link $download_url. Downloading..."
curl "$download_url" --output $out

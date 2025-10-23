#!/bin/bash

# TODO look up what this does
if [ -e .attrs.sh ]; then source .attrs.sh; fi
source "${stdenv:?}/setup"

echo "Asking Buzzheavier for download link to $item ($url)..."
download_url="$(
    curl "$url" \
    --head
    --silent \
    --output /dev/null \
    --header 'Referer: https://buzzheavier.com/frtjt00auv5' \
    --write-out '%header{hx-redirect}'
)"

echo "Buzzheavier successfully responded with download link '$download_url'. Downloading..."
curl "$u


if [[ "$requestInfo" == "true" ]]; then
    read -r -d "\n" buzzheavier_name buzzheavier_sha1 <<<$(curl -s "$url" \
      | pup '.text-2xl, code text{}'
    )
    set -x
    echo $buzzheavier_name
    echo $buzzheavier_sha1
    set +x
fi

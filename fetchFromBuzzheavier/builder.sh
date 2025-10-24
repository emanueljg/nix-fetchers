#!/bin/bash

# TODO look up what this does
if [ -e .attrs.sh ]; then source .attrs.sh; fi
source "${stdenv:?}/setup"

echo "Asking Buzzheavier for download link to $item ($url)..."

dl_request="$(
    curl "$url/download" \
    --head \
    --output /dev/null \
    --header "Referer: $url" \
    --write-out '{"resp": %{json}, "headers": %{header_json}}'
)" 

http_code="$(echo "$dl_request" | jq -r '.http_code')"
if [ "$http_code" -ge 400 ]; then
    echo "ERROR: Request failed! HTTP Error '$http_code'"
    exit 1
fi

download_url="$(echo "$dl_request" | jq -r '.headers."hx-redirect"[0]')"
if [[ "$download_url" = 'null' ]]; then
    echo "ERROR: Buzzheavier gave us no $download_url on our request."
    exit 1
fi

echo "Buzzheavier successfully responded with download link $download_url. Downloading..."
curl "$download_url" --output $out

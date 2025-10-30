#!/bin/bash
set -euo pipefail

echo "Asking Buzzheavier for download link to '$item' ($url)..."

# we are directly concatenating the headers Location: and hx-redirect:
# in the format string. They are mutually exclusive; if one is non-empty,
# the other will be empty, so the resulting output string will always either
# be a '/notfound' (BH 404) or a download URL.
answer="$(
  curl "$url/download" \
    --head \
    --output /dev/null \
    --header "Referer: $url" \
    --write-out '%header{location}%header{hx-redirect}' 
)"

if [ "$answer" = '/notfound' ]; then
  echo " Buzzheavier couldn't find the item (redirect to $baseUrl/notfound)"
  exit 1
fi

echo "Buzzheavier successfully responded with download link $answer. Downloading..."
curl "$answer" --output "$out"

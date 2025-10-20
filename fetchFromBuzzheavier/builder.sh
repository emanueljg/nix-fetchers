#!/bin/bash

# TODO look up what this does
if [ -e .attrs.sh ]; then source .attrs.sh; fi
source "${stdenv:?}/setup"

curlVersion=$(curl -V | head -1 | cut -d' ' -f2)

curl=(
    curl
    --location
    --max-redirs 20
    --retry 3
    --retry-all-errors
    --continue-at -
    --disable-epsv
    --user-agent "curl/$curlVersion Nixpkgs/$nixpkgsVersion"
)

echo "Downloading BH item $item ($url)"
echo "Fetching HTML and parsing metadata..."
"${curl[@]}" -4 -v 'https://buzzheavier.com/frtjt00auxv5'
read -r -d "\n" buzzheavier_name buzzheavier_sha1 <$("${curl[@]}" -v "$url" \
  | pup 'div[x-data="App()"] span:first-child, div[x-data="App()"] li:nth-child(4) code text{}'
)

set -x
echo $buzzheavier_name
echo $buzzheavier_sha1
set +x

echo -n "useSHA1Hash is "$useSHA1Hash: " 
if [[ "$useSHA1Hash" == "true" ]]; then
  echo "using buzzheavier's hash..."
  set -x
  hash="$buzzheavier_sha1"
  hashAlgo="sha1"
  set +x
else
  echo "using nix's hash..."

set -x
echo "$hash"
set +x

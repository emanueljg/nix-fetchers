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

echo "${!hash@A}"

set +o noglob

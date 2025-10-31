#!/bin/bash
set -euo pipefail

if [[ $(basename ${item%/$(basename "$item")}) = "folder" ]]; then
  mkdir "$out"
fi

megatools dl "$_url" --path "$out"

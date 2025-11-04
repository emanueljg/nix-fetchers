#!/bin/bash
set -euo pipefail

echo "Create a guest account for this session..."
token="$(curl "$apiUrl/accounts" \
  --request POST \
| jq --raw-output '.data.token')"

echo "List contents..."
# I have no clue what 'wt' means, but if we don't pass along this hard-coded string,
# we get the response {"status":"error-notPremium","data":{}}.
# you can find it as a top-level constant in global.js
wt="4fd6sg89d7s6"
resp="$(curl "https://api.gofile.io/contents/$_id?wt=$wt" \
  --header "Authorization: Bearer $token"
)"

echo "Download file(s)..."
echo "$resp" \
  | jq "$_jqPattern" \
      --raw-output \
      --from-file \
      --argjson drv "$(cat .attrs.json)" \
      --arg token "$token" \
      --arg out "$out" \
  | xargs -L1 sh -c 'echo "$0 $@"; eval "$0 $@"'



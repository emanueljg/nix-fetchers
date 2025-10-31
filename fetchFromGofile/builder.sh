#!/bin/bash
set -euo pipefail

echo "Create a guest account for this session..."
token="$(curl "$apiUrl/accounts" \
  --request POST \
| jq --raw-output '.data.token')"

echo "$apiUrl"

echo "List contents..."

# I have no clue what 'wt' means, but if we don't pass along this hard-coded string,
# we get the response {"status":"error-notPremium","data":{}}.
# you can find it as a top-level constant in global.js
wt="4fd6sg89d7s6"
resp="$(
  curl "https://api.gofile.io/contents/$_id?wt=$wt" \
    --header "Authorization: Bearer $token"
)"

echo "$resp"

# we got a list
if [ -n "$_selectList" ]; then
  mkdir "$out"
  echo "$resp" \
    | jq --raw-output '
        .data.children[]
          | select(
              .name as $x
                | $ARGS.positional
                | any(. == $x)
            )
          | .link
      ' --jsonargs -- "${_selectList[@]}" \
    | xargs --replace={}  \
        curl '{}' \
          --header "Authorization: Bearer $token" \
          --output-dir "$out" \
          --remote-name
# we got a single item
else
  dl_url="$(echo "$resp" \
    | jq --raw-output '
        .data.children[]
          | select(
              .name == $selected
            )
          | .link
      ' --argjson 'selected' "\"$select\"" 
  )"
  curl "$dl_url" \
    --header "Authorization: Bearer $token" \
    --output "$out"
fi

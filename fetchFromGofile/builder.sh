#!/bin/bash
set -euo pipefail

echo "Create a guest account for this session..."
token="$(curl "$apiUrl/accounts" \
  --request POST \
| jq --raw-output '.data.token')"

echo "$apiUrl"

curl=(
  curl
  --header "Authorization: Bearer $token"
)

echo "List contents..."

# I have no clue what 'wt' means, but if we don't pass along this hard-coded string,
# we get the response {"status":"error-notPremium","data":{}}.
# you can find it as a top-level constant in global.js
wt="4fd6sg89d7s6"
resp="$("${curl[@]}" "https://api.gofile.io/contents/$_id?wt=$wt")"


if [[ "${_select["strategy"]}" == "one" ]] || [[ "${_select["jqFirst"]}" == "true" ]]; then
  curl+=(
    --output "$out"
  )
else
  curl+=(
    --output-dir "$out"
    --create-dirs
    --remote-name
  )
fi

echo "$resp" \
  | jq "$_jq_pattern" \
    --raw-output \
    --from-file \
    --argjson drv "$(cat .attrs.json)" \
  | xargs \
    --replace={} \
    "${curl[@]}" '{}' 



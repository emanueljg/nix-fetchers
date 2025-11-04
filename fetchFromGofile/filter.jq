.data.children as $elems

| if $drv._select.strategy == "all" then
    $elems
  else 
    # coerce a single name into a singleton list
    if $drv._select.strategy == "one" then
        [$drv._select.one]
      else
        $drv._select.many
      end

    # each elem gets mapped to the object which contains its name
    | map(
        . as $name
        | [
            $elems[]
            | select(.name == $name)
          ]
      )

    # sieve for erroring out in case we dont get exacly one match for all of them
    | map(
        if (. == []) and ($drv._select.manyAllowSelectFail | not) then
          ("ERROR: jq failed to map a filename to a download\n" | halt_error(101))
        elif (. | length) > 1 then
          ("ERROR: jq mapped to too many objects" | halt_error(102))
        else
          .
        end
      )

    # flatten and turn into links
    | flatten
  end
| map(
    "curl '\(.link)' --header 'Authorization: Bearer \($token)' --location" as $baseStr 
    | if $drv._select.strategy == "one" then
        # I can't seem to figure out how to use single quotes without them disappearing
        # in the later eval. Funnily enough, using them in baseStr works just fine. I'll use double quotes instead.
        (@sh "\($baseStr) --output \"\($out)\"")
      else
        (@sh "\($baseStr) --output \"\(.name)\" --output-dir \"\($out)\" --create-dirs")
      end
  )[]
# | map(.link, .name)[]


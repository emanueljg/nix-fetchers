.data.children as $elems

# coerce a single name into a singleton list
| if $drv._select.strategy == "one" then
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
    if (. == []) && !$drv._select.manyAllowSelectFail then
      ("ERROR: jq failed to map a filename to a download\n" | halt_error(101))
    elif (. | length) > 1 then
      ("ERROR: jq mapped to too many objects" | halt_error(102))
    else
      .
    end
  )

# flatten and turn into links
| flatten
| map(.link)


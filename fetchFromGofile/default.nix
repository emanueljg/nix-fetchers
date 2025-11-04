{
  lib,
  curl,
  jq,
  mkFOD,
}:
lib.extendMkDerivation {
  constructDrv = mkFOD;
  extendDrvArgs =
    finalAttrs:
    prevAttrs@{
      baseUrl ? "https://gofile.io",
      apiUrl ? "https://api.gofile.io",
      item,
      select ? { },

      nativeBuildInputs ? [ ],
      ...
    }:
    {
      inherit
        baseUrl
        apiUrl
        item
        select
        ;
      name = "gofile-${finalAttrs._id}";

      _id = builtins.baseNameOf finalAttrs.item;
      _url =
        if finalAttrs._id == finalAttrs.item then
          "${finalAttrs.baseUrl}/${finalAttrs._id}"
        else
          finalAttrs.item;

      _select =
        let
          result =
            # default (all)
            if finalAttrs.select == { } then
              {
                strategy = "all";
                all = true;
              }
            # all
            else if finalAttrs.select ? "all" then
              if finalAttrs.select.all then
                {
                  strategy = "all";
                  inherit (finalAttrs.select) all;
                }
              else
                builtins.thow ''
                  select.all = false is invalid
                ''
            # one
            else if finalAttrs.select ? "one" then
              {
                strategy = "one";
                inherit (finalAttrs.select) one;
              }
            # many
            else if finalAttrs.select ? "many" then
              {
                strategy = "many";

                many =
                  if finalAttrs.select.many == [ ] then
                    builtins.throw "Got an empty list!"
                  else if !(lib.allUnique finalAttrs.select.many) then
                    builtins.throw "Got a list with duplicates in a select-many list!"
                  else
                    finalAttrs.select.many;

                manyAllowSelectFail = finalAttrs.select.manyAllowSelectFail or false;
              }
            # jq
            else
              builtins.throw ''
                Select strategy not found!
              '';
          rest = builtins.removeAttrs finalAttrs.select (builtins.attrNames result);

        in
        if rest == { } then
          result
        else
          builtins.throw ''
            With strategy '${result.strategy}' chosen,
            the following unsupported attributes were provided: [ ${lib.concatStringsSep ", " rest} ].
          '';

      _jqPattern = ./filter.jq;

      nativeBuildInputs = [
        curl
        jq
      ]
      ++ nativeBuildInputs;
      builder = ./builder.sh;
    };
}

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
      select,

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

      _selectList =
        if (builtins.isList finalAttrs.select) then map (x: ''"${x}"'') finalAttrs.select else "";

      nativeBuildInputs = [
        curl
        jq
      ]
      ++ nativeBuildInputs;
      builder = ./builder.sh;
    };
}

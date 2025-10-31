{
  lib,
  megatools,
  mkFOD,
}:
lib.extendMkDerivation {
  constructDrv = mkFOD;
  extendDrvArgs =
    finalAttrs:
    prevAttrs@{
      baseUrl ? "https://mega.nz",
      item,
      nativeBuildInputs ? [ ],
      ...
    }:
    {
      inherit baseUrl item;
      name = "mega-${finalAttrs._id}";

      # this is the format that megatool-dl understands. It's a bit weird,
      # largely got it from trial-and-error.
      _handleItem =
        builtins.replaceStrings
          [ "${finalAttrs.baseUrl}/folder/" "/file/" "/folder/" "#" ]
          [ "${finalAttrs.baseUrl}/#F!" "!" "!" "!" ]
          finalAttrs.item;

      _id = builtins.baseNameOf finalAttrs._handleItem;
      _url =
        if finalAttrs._id == finalAttrs._handleItem then
          "${finalAttrs.baseUrl}/${finalAttrs._id}"
        else
          finalAttrs._handleItem;

      nativeBuildInputs = [
        megatools
      ]
      ++ nativeBuildInputs;
      builder = ./builder.sh;
    };
}

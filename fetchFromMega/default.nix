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
      name = "mega-${finalAttrs.item}";

      _preSegments = let
        inner =
      in inner finalAttrs.item;


      _handleItem = lib.hasPrefix  
      _isFolder = lib.hasPrefix "${finalAttrs.baseUrl}/#F!" finalAttrs.url;
      url =
        builtins.replaceStrings
          [ "${finalAttrs.baseUrl}/folder/" "/file/" "/folder/" "#" ]
          [ "${finalAttrs.baseUrl}/#F!" "!" "!" "!" ]
          "${finalAttrs.baseUrl}/${finalAttrs.item}";
      nativeBuildInputs = [
        megatools
      ]
      ++ nativeBuildInputs;
      builder = ./builder.sh;
    };
}

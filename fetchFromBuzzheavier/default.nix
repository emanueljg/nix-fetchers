{
  lib,
  curl,
  mkFOD,
}:
lib.extendMkDerivation {
  constructDrv = mkFOD;
  extendDrvArgs =
    finalAttrs:
    prevAttrs@{
      baseUrl ? "https://buzzheavier.com",
      item,
      nativeBuildInputs ? [ ],
      ...
    }:
    {
      inherit baseUrl item;
      name = "buzzheavier-${finalAttrs.item}";
      url = "${finalAttrs.baseUrl}/${finalAttrs.item}";
      nativeBuildInputs = [
        curl
      ]
      ++ nativeBuildInputs;
      builder = ./builder.sh;
    };
}

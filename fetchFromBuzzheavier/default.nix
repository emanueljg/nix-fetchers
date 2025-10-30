{
  lib,
  curl,
  jq,
  mkCheckedFOD,
}:
lib.extendMkDerivation {
  constructDrv = mkCheckedFOD;
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
        jq
      ]
      ++ nativeBuildInputs;
      builder = ./builder.sh;
    };
}

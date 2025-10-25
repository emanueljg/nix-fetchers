{ lib
, curl
, jq
, mkCheckedFOD
}: lib.mkExtendDerivation {
  constructDrv = mkCheckedFOD;
  extendDrvArgs = finalAttrs: prevAttrs@{
    baseUrl ? "https://buzzheavier.com/"
    , item
  }: {
    inherit baseUrl item;
    url = finalAttrs.baseUrl + finalAttrs.item;
    builder = ./builder.sh;
  };
}

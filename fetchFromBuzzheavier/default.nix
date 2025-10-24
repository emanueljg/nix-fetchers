{ lib
, curl
, jq
, mkCheckedFOD
}: lib.mkExtendDerivation {
  constructDrv = mkCheckedFOD;
  extendDrvArgs = finalAttrs: prevAttrs@{
    baseUrl ? "https://buzzheavier.com/"
    , url ? null
    , item ? null
  }: if !(lib.xor (url == null) (item == null)) then 
    builtins.throw ''
      Exactly one of 'url' and 'item' must be set
    '' 
  else {
    url = if url != null then url else baseUrl + item;
    item = if item == null then lib.removePrefix url item;
    builder = ./builder.sh;
  };
}

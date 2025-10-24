{ lib
, stdenvNoCC
, cacert
, fetchurl
, curl
, pup
}: let
  baseUrl = "https://buzzheavier.com/";
in 
{ item ? lib.removePrefix baseUrl url
, url ? baseUrl + item
, hash ? lib.fakeHash
, name ? "buzzheavier-${item}"
, ...
}@args:
stdenvNoCC.mkDerivation (
  {
    inherit item url hash name;
    builder = ./builder.sh;
    buildInputs = [ curl ];
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  }
)

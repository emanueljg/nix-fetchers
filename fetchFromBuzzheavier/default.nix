{ lib
, stdenvNoCC
, cacert
, fetchurl
, curl
, jq
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
    inherit item url name;
    builder = ./builder.sh;
    buildInputs = [ curl jq ];
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    outputHash = hash;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  }
)

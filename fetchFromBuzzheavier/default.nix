{ lib
, stdenvNoCC
, cacert
, fetchurl
, curl
, pup
}: let
  baseUrl = "https://buzzheavier.com/";
{ item ? lib.removePrefix baseUrl url;
, url ? baseUrl + item;
, useSHA1Hash ? false
, hash ? lib.fakeHash
, name ? "buzzheavier-${item}"
, ...
}@args:
stdenvNoCC.mkDerivation (
  {
    inherit item url useSHA1Hash hash name;
    builder = ./builder.sh;
    buildInputs = [ curl pup ];
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

    outputHashMode = "recursive";
  }
)

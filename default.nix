{ lib
, stdenvNoCC
, cacert
, fetchurl
, curl
, jq
}:
{ creator
, game
, uploadName
, apiKeyPath ? "/run/secrets/fetchFromItch"
, hash ? lib.fakeHash
, name ? "${creator}-${game}-${uploadName}"
,
}:
stdenvNoCC.mkDerivation {
  inherit creator game uploadName apiKeyPath name;
  builder = ./builder.sh;
  buildInputs = [ jq curl ];
  SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  outputHash = hash;
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
}

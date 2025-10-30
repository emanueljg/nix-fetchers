{
  lib,
  stdenv,
  shellcheck-minimal,
  cacert,
}:
(lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;
  extendDrvArgs =
    finalAttrs:
    prevAttrs@{
      hash ? lib.fakeHash,
      outputHashAlgo ? "sha256",
      outputHashMode ? "recursive",

      SSL_CERT_FILE ? null,
      addSSLCerts ? true,

      enableParallelBuilding ? true,
      strictDeps ? true,

      ...
    }:
    {
      inherit
        hash
        outputHashAlgo
        outputHashMode
        addSSLCerts
        enableParallelBuilding
        strictDeps
        ;

      outputHash = finalAttrs.hash;

      __structuredAttrs = true;

      SSL_CERT_FILE =
        if SSL_CERT_FILE != null then
          SSL_CERT_FILE
        else
          lib.optionalString finalAttrs.addSSLCerts "${cacert}/etc/ssl/certs/ca-bundle.crt";
      NIX_SSL_CERT_FILE = finalAttrs.SSL_CERT_FILE;
    };
})
// {
  example = ''
    hello :)
  '';
}

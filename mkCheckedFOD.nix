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

      shellcheckOpts ? { },
      checkPhase ? null,

      SSL_CERT_FILE ? null,
      addSSLCerts ? true,

      enableParallelBuilding ? true,
      strictDeps ? true,

      example ? ''
        foo
        bar
        baz
      '',

      ...
    }:
    {
      outputHash = finalAttrs.hash;
      inherit hash outputHashAlgo outputHashMode;
      inherit shellcheckOpts addSSLCerts;
      inherit enableParallelBuilding strictDeps;

      __structuredAttrs = true;

      checkPhase =
        if checkPhase != null then
          checkPhase
        else
          ''
            runHook preCheck
            ${stdenv.shellDryRun} "$target"
            ${lib.optionalString shellcheck-minimal.compiler.bootstrapAvailable ''
              ${lib.getExe shellcheck-minimal} "$target" \
                ${lib.cli.toGNUCommandLineShell { } shellcheckOpts}
            ''}
            runHook postCheck
          '';

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

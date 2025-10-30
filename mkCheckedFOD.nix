{ lib, stdenvNoCC, shellcheck-minimal, cacert }: lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;
  excludeDrvArgNames = [
    "addSSLCerts"
    "shellcheckOpts" 
  ];
  extendDrvArgs = finalAttrs: prevAttrs@{ 
    hash ? lib.fakeHash
    , outputHashAlgo ? "sha256"
    , outputHashMode ? "recursive"

    , shellcheckOpts ? { }
    , checkPhase ? null

    , addSSLCerts ? false
  }: {
    outputHash = finalAttrs.hash;
    inherit hash outputHashAlgo outputHashMode;

    checkPhase = if checkPhase != null then checkPhase else ''
      runHook preCheck
      ${stdenvNoCC.shellDryRun} "$target"
      ${lib.optionalString shellcheck-minimal.compiler.bootstrapAvailable ''
        ${lib.getExe shellcheck-minimal} "$target" \
          ${lib.cli.toGNUCommandLineShell { } shellcheckOpts}
      ''}
      runHook postCheck
    '';
        
  } // lib.optionalAttrs addSSLCerts { 
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };
}

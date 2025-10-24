{ pkgs }: let
  inherit (pkgs) lib;
{
  # this helper is ripped out of `pkgs.writeShellApplication` 
  # and adds dry-run and shellcheck checks
  makeBashCheckPhase = {
    excludes ? [ ]
  }: let
    excludeFlags = lib.optionals (excludeShellChecks != [ ]) [
      "--exclude"
      (lib.concatStringsSep "," excludes)
    ];
    # GHC (=> shellcheck) isn't supported on some platforms (such as risc-v)
    # but we still want to use writeShellApplication on those platforms
    shellcheckCommand = lib.optionalString pkgs.shellcheck-minimal.compiler.bootstrapAvailable ''
      # use shellcheck which does not include docs
      # pandoc takes long to build and documentation isn't needed for just running the cli
      ${lib.getExe pkgs.shellcheck-minimal} ${
        lib.escapeShellArgs (excludeFlags ++ extraShellCheckFlags)
      } "$target"
    '';
  in
  if checkPhase == null then
    ''
      runHook preCheck
      ${stdenv.shellDryRun} "$target"
      ${shellcheckCommand}
      runHook postCheck
    ''
  else
    checkPhase;
}

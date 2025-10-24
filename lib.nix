{ pkgs }: let
  inherit (pkgs) lib;
{
  # this helper is ripped out of `pkgs.writeShellApplication` but simplified a bit
  # it adds dry-run and shellcheck checks
  #
  makeBashCheckPhase = {
    opts ? { }
  }: let
    # GHC (=> shellcheck) isn't supported on some platforms (such as risc-v)
    # but we still want to use writeShellApplication on those platforms
    shellcheckCommand = lib.optionalString pkgs.shellcheck-minimal.compiler.bootstrapAvailable ''
      # use shellcheck which does not include docs
      # pandoc takes long to build and documentation isn't needed for just running the cli
      ${lib.getExe pkgs.shellcheck-minimal} "$target" \
        ${cli.toGNUCommandLineShell { } opts}
    '';
  in ''
      runHook preCheck
      ${stdenv.shellDryRun} "$target"
      ${shellcheckCommand}
      runHook postCheck
    '';
}

{
  unar,
  stdenvNoCC,
  lib,
}:
lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;
  extendDrvArgs =
    finalAttrs:
    {
      src,
      enableParallelBuilding ? true,
      strictDeps ? true,
      ...
    }:
    {
      inherit src enableParallelBuilding strictDeps;
      nativeBuildInputs = [ unar ];
      buildCommand = ''
        unar "$src" -o $out 
      '';
    };
}

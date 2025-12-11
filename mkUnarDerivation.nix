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
        unar "$src" -q -o $out 
        if [ $(ls -A1 $out | wc -l) -eq 1 ]; then
          find $out -mindepth 1 -maxdepth 1 -exec mv {} tmpdir \;
          mv -T tmpdir $out
        fi
      '';
    };
}

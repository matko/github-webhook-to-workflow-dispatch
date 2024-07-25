{
  stdenv,
  stdenvNoCC,
  swiProlog
}:
stdenvNoCC.mkDerivation (attrs: {
  name = "hook-to-workflow-dispatch";
  buildInputs = [
    swiProlog
  ];
  src = ./.;

  buildPhase = ''
swipl -o ${attrs.name} -c handle_hook.pl
'';

  installPhase = ''
mkdir -p $out/bin
cp ${attrs.name} $out/bin/${attrs.name}
'';
})

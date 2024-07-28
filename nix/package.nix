{
  stdenv,
  stdenvNoCC,
  swiProlog,
  cacert
}:
stdenvNoCC.mkDerivation (attrs: {
  name = "github-webhook-to-workflow-dispatch";
  buildInputs = [
    swiProlog
  ];
  src = ../prolog;

  buildPhase = ''
swipl -o ${attrs.name} -c github-webhook-to-workflow-dispatch.pl
'';

  installPhase = ''
mkdir -p $out/bin
cp ${attrs.name} $out/bin/${attrs.name}
'';
})

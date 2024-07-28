{
  dockerTools,
  hook,
  cacert,
}:
dockerTools.buildImage {
  inherit (hook) name;
  copyToRoot = [ cacert ];
  config = {
    Cmd = [ "${hook}/bin/${hook.name}" ];
  };

}

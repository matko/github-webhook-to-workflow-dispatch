{
  dockerTools,
  hook,
}:
dockerTools.buildImage {
  inherit (hook) name;
  config = {
    Cmd = [ "${hook}/bin/${hook.name}" ];
  };

}

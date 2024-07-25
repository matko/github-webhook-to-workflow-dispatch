{
  description = "middleware to turn swipl webhook calls into workflow dispatches";

  inputs = {
    nixpkgs.url = "github:matko/nixpkgs/swipl_to_9.2.6";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {nixpkgs, flake-utils, ...}:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
          swiProlog = (pkgs.swiProlog.override {
            withDb = false;
            withJava = false;
            withOdbc = false;
            withPython = false;
            withYaml = false;
            withGui = false;
            withNativeCompiler = false;
          }).overrideAttrs {
            doCheck = false;
          };
      in
      {
        packages = rec {
          default = pkgs.callPackage ./package.nix {inherit swiProlog;};
          inherit swiProlog;
          container = pkgs.callPackage ./container.nix {
            hook = default;
          };
        };
      });
}

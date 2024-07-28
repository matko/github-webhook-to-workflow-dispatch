{
  description = "middleware to turn github webhook calls into workflow dispatches";

  inputs = {
    # PR 329891 in nixpkgs - switch back to NixOS/nixpkgs/nixpkgs-unstable when merged
    nixpkgs.url = "github:matko/nixpkgs/swipl_to_9.2.6";
    swipl-nix = {
      # tcmalloc branch for hacky gperftools dependency fix
      url = "github:matko/swipl-nix/tcmalloc";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {nixpkgs, swipl-nix, flake-utils, ...}:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
          swiProlog = (swipl-nix.packages.${system}."9_2_6".override {
            withDb = false;
            withJava = false;
            withOdbc = false;
            withPython = false;
            withYaml = false;
            withGui = false;
            withNativeCompiler = false;
          }).overrideAttrs (_: prev:
            {
              # TODO - this has to be fixed in the nixpkgs packaging
              cmakeFlags = prev.cmakeFlags ++ [
                "-DSYSTEM_CACERT_FILENAME=/etc/ssl/certs/ca-bundle.crt"
              ];
            }
          );
      in
      {
        packages = rec {
          default = pkgs.callPackage ./nix/package.nix {inherit swiProlog;};
          inherit swiProlog;
          container = pkgs.callPackage ./nix/container.nix {
            hook = default;
          };
        };
      });
}

{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    concurrentQueue = {
      url = "github:cameron314/concurrentqueue";
      flake = false;
    };
    sortmernaSrc = {
      url = "github:sortmerna/sortmerna";
      flake = false;
    };
  };
  outputs =
    { ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = (import inputs.nixpkgs) {
          inherit system;
        };
      in
      {
        devShells = rec {
        };
        formatter =
          let
            treefmtconfig = inputs.treefmt-nix.lib.evalModule pkgs {
              projectRootFile = "flake.nix";
              programs = {
                nixfmt.enable = true;
                toml-sort.enable = true;
                yamlfmt.enable = true;
                mdformat.enable = true;
                shellcheck.enable = true;
                shfmt.enable = true;
              };
              settings.formatter.shellcheck.excludes = [ ".envrc" ];
            };
          in
          treefmtconfig.config.build.wrapper;
        apps = rec {
        };
        packages = rec {
          sortmerna = pkgs.callPackage ./package.nix { inherit (inputs) concurrentQueue sortmernaSrc; };
          default = sortmerna;
        };
      }
    );
}

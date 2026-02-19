{
  description = "Counter QML Plugin for Logos - A simple counter implemented entirely in QML";

  inputs = {
    logos-cpp-sdk.url = "github:logos-co/logos-cpp-sdk";
    nixpkgs.follows = "logos-cpp-sdk/nixpkgs";
    logos-liblogos.url = "github:logos-co/logos-liblogos";
  };

  outputs = { self, nixpkgs, logos-cpp-sdk, logos-liblogos }:
    let
      systems = [ "aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f {
        pkgs = import nixpkgs { inherit system; };
        logosLiblogos = logos-liblogos.packages.${system}.default;
      });
    in
    {
      packages = forAllSystems ({ pkgs, logosLiblogos }:
        let
          src = ./.;

          lib = import ./nix/lib.nix {
            inherit pkgs src;
          };

          app = import ./nix/app.nix {
            inherit pkgs logosLiblogos;
            counterQmlPlugin = lib;
          };
        in
        {
          lib = lib;
          app = app;
          default = lib;
        }
      );
    };
}

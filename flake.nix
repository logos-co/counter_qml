{
  description = "Counter QML Plugin for Logos - A simple counter implemented entirely in QML";

  inputs = {
    logos-cpp-sdk.url = "github:logos-co/logos-cpp-sdk";
    nixpkgs.follows = "logos-cpp-sdk/nixpkgs";
  };

  outputs = { self, nixpkgs, logos-cpp-sdk }:
    let
      systems = [ "aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      packages = forAllSystems ({ pkgs }: {
        default = pkgs.stdenv.mkDerivation {
          pname = "logos-counter-qml-plugin";
          version = "1.0.0";
          src = ./.;

          dontUnpack = false;
          phases = [ "unpackPhase" "installPhase" ];

          installPhase = ''
            runHook preInstall

            dest="$out/qml_plugins/counter_qml"
            mkdir -p "$dest/icons"

            cp $src/Main.qml "$dest/Main.qml"
            cp $src/metadata.json "$dest/metadata.json"
            cp $src/icons/counter.png "$dest/icons/counter.png"

            runHook postInstall
          '';

          meta = with pkgs.lib; {
            description = "Counter QML Plugin for Logos";
            license = licenses.mit;
            platforms = platforms.unix;
          };
        };
      });
    };
}

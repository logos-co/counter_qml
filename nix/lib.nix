# Builds the logos-counter-qml-plugin shared library
{ pkgs, src }:

pkgs.stdenv.mkDerivation {
  pname = "logos-counter-qml-plugin";
  version = "1.0.0";

  inherit src;

  nativeBuildInputs = [
    pkgs.cmake
    pkgs.ninja
    pkgs.qt6.wrapQtAppsHook
  ];

  buildInputs = [
    pkgs.qt6.qtbase
    pkgs.qt6.qtdeclarative
  ];

  dontWrapQtApps = true;

  configurePhase = ''
    runHook preConfigure

    cmake -S . -B build \
      -GNinja \
      -DCMAKE_BUILD_TYPE=Release

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    cmake --build build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib

    if [ -f build/modules/counter_qml.dylib ]; then
      cp build/modules/counter_qml.dylib $out/lib/
    elif [ -f build/modules/counter_qml.so ]; then
      cp build/modules/counter_qml.so $out/lib/
    else
      echo "Error: No library file found in build/modules/"
      find build -name "*.so" -o -name "*.dylib" | head -20
      exit 1
    fi

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Counter QML Plugin for Logos";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

# Builds a standalone runtime bundle: Logos host binaries + counter QML plugin
{ pkgs, logosLiblogos, counterQmlPlugin }:

pkgs.stdenv.mkDerivation {
  pname = "logos-counter-qml-app";
  version = "1.0.0";

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib

    # Install Logos host binaries
    if [ -f "${logosLiblogos}/bin/logoscore" ]; then
      cp -L "${logosLiblogos}/bin/logoscore" "$out/bin/"
    fi
    if [ -f "${logosLiblogos}/bin/logos_host" ]; then
      cp -L "${logosLiblogos}/bin/logos_host" "$out/bin/"
    fi

    # Copy required shared libraries from liblogos
    if ls "${logosLiblogos}/lib/"liblogos_core.* >/dev/null 2>&1; then
      cp -L "${logosLiblogos}/lib/"liblogos_core.* "$out/lib/" || true
    fi

    # Copy the QML plugin (loaded directly by the Logos host, same as accounts_ui)
    OS_EXT="so"
    case "$(uname -s)" in
      Darwin) OS_EXT="dylib" ;;
      Linux)  OS_EXT="so"    ;;
    esac

    if [ -f "${counterQmlPlugin}/lib/counter_qml.$OS_EXT" ]; then
      cp -L "${counterQmlPlugin}/lib/counter_qml.$OS_EXT" "$out/"
    fi

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Counter QML standalone app for Logos";
    platforms = platforms.unix;
  };
}

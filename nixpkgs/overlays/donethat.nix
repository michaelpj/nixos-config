self: super:

let
  pname = "donethat";
  version = "2.2.12";
in
{
  donethat = super.buildNpmPackage {
    inherit pname version;

    src = super.fetchFromGitHub {
      owner = "donethatai";
      repo = "donethat-electron";
      rev = "v${version}";
      hash = "sha256-P8CmiIn7O50AxmhPg62AhkVowBAw9zeCnP9Zlz5iqL8=";
    };

    npmDepsHash = "sha256-7o+5/SrhGHf2N/HI0tAMMyrGGjOd0+Do++6QZEAIwEo=";

    # Skip postinstall: it builds macOS-only Swift helpers and runs electron-builder install-app-deps
    npmFlags = [ "--ignore-scripts" ];

    env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

    nativeBuildInputs = with super; [ makeWrapper ];

    # Override build to only run asset compilation, not electron-builder
    buildPhase = ''
      runHook preBuild
      mkdir -p build
      npx postcss src/styles.css -o ./build/output.css --verbose
      npx webpack --config webpack.config.js
      runHook postBuild
    '';

    # Assemble app directory and wrap with system electron
    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/donethat

      # Copy app files (matching electron-builder's files config)
      cp main.js firebase-config.js package.json $out/lib/donethat/
      cp -r src src-main build resources $out/lib/donethat/

      # Prune dev dependencies, then copy node_modules
      npm prune --omit=dev
      cp -r node_modules $out/lib/donethat/

      # Create electron wrapper
      mkdir -p $out/bin
      makeWrapper ${super.electron}/bin/electron $out/bin/donethat \
        --add-flags "$out/lib/donethat"

      # Desktop entry
      mkdir -p $out/share/applications
      cat > $out/share/applications/donethat.desktop << EOF
      [Desktop Entry]
      Name=DoneThat
      Comment=AI-powered daily standup and progress tracking
      Exec=donethat %U
      Terminal=false
      Type=Application
      Icon=donethat
      StartupWMClass=donethat
      Categories=Utility;
      MimeType=x-scheme-handler/donethat;
      EOF

      # Icon
      mkdir -p $out/share/icons/hicolor/512x512/apps
      cp resources/icon-launcher.png $out/share/icons/hicolor/512x512/apps/donethat.png

      runHook postInstall
    '';

    meta = with super.lib; {
      description = "DoneThat - AI-powered daily standup and progress tracking";
      homepage = "https://donethat.ai";
      license = licenses.gpl3Plus;
      platforms = [ "x86_64-linux" ];
      mainProgram = "donethat";
    };
  };
}

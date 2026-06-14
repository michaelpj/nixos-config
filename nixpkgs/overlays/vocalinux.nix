# Vocalinux: free, offline voice dictation for Linux (speech-to-text).
#
# Upstream is a Python/GTK3 tray app that ships only as a `curl | bash`
# installer building a venv in ~/.local/share. None of it is in nixpkgs, and
# two of its dependencies — `vosk` and `pywhispercpp` — are missing too. Both
# of those distribute prebuilt native libraries inside their PyPI wheels
# (libvosk, libwhisper/libggml), so rather than rebuild Kaldi/whisper.cpp from
# source we consume the upstream manylinux wheels and fix up their RPATHs with
# autoPatchelfHook. This is also what the app itself expects: it preloads
# `libggml*.so` from the auditwheel-repaired `pywhispercpp.libs` directory.
#
# Speech models are NOT packaged here. Vocalinux downloads them at runtime from
# Hugging Face into ~/.local/share/vocalinux/models (mutable user data), which
# is the right place for them — baking a ~74MB model into the store buys us
# nothing and the first-run UX handles the download.
self: super:

let
  py = super.python3Packages;

  # vosk's wheel is Python-version independent (cffi-based, py3-none), so the
  # manylinux2010 x86_64 wheel works against our CPython directly.
  vosk = py.buildPythonPackage rec {
    pname = "vosk";
    version = "0.3.45";
    format = "wheel";

    src = super.fetchurl {
      url = "https://files.pythonhosted.org/packages/fc/ca/83398cfcd557360a3d7b2d732aee1c5f6999f68618d1645f38d53e14c9ff/vosk-0.3.45-py3-none-manylinux_2_12_x86_64.manylinux2010_x86_64.whl";
      hash = "sha256-JeAlCTxDmdcnj1Q1aO2MxUYKw6S/SMI2c6zh4l0mYZ8=";
    };

    nativeBuildInputs = [ super.autoPatchelfHook ];
    # The bundled libvosk.so links against libstdc++/libgomp.
    buildInputs = [ super.stdenv.cc.cc.lib ];
    propagatedBuildInputs = with py; [ cffi requests tqdm srt websockets ];

    pythonImportsCheck = [ "vosk" ];

    meta = with super.lib; {
      description = "Offline speech recognition toolkit (Python bindings)";
      homepage = "https://alphacephei.com/vosk/";
      license = licenses.asl20;
      platforms = [ "x86_64-linux" ];
    };
  };

  # pywhispercpp is a compiled extension, so the wheel is CPython-version
  # specific: this is the cp313 wheel and nixpkgs' python3 is currently 3.13.
  # When a nixpkgs bump moves python3 to 3.14+, the build will fail (no cp313
  # interpreter to install the wheel into). To fix: pick the matching
  # `cpXYY-...-manylinux_..._x86_64.whl` from
  # https://pypi.org/pypi/pywhispercpp/json and update url + hash below.
  # (vosk above is py3-none, so it is unaffected by python version bumps.)
  pywhispercpp = py.buildPythonPackage rec {
    pname = "pywhispercpp";
    version = "1.5.0";
    format = "wheel";

    src = super.fetchurl {
      url = "https://files.pythonhosted.org/packages/dd/58/8e651f7210eeb64721562406a69c769e72fdd4560fa8d5ca4895cab5b4e2/pywhispercpp-1.5.0-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
      hash = "sha256-Lqj6f1zmAtPphvsRxMKXO0cfGxTg/nXgGmbxpgrsv78=";
    };

    nativeBuildInputs = [ super.autoPatchelfHook ];
    # Bundled libwhisper/libggml link against libstdc++/libgomp.
    buildInputs = [ super.stdenv.cc.cc.lib ];
    propagatedBuildInputs = with py; [ numpy requests tqdm platformdirs ];

    pythonImportsCheck = [ "pywhispercpp" ];

    meta = with super.lib; {
      description = "Python bindings for whisper.cpp";
      homepage = "https://github.com/abdeladim-s/pywhispercpp";
      license = licenses.mit;
      platforms = [ "x86_64-linux" ];
    };
  };
in
{
  # Exposed at the top level so they can be built/inspected on their own.
  inherit vosk pywhispercpp;

  vocalinux = py.buildPythonApplication rec {
    pname = "vocalinux";
    version = "0.12.0-beta";
    pyproject = true;

    src = super.fetchFromGitHub {
      owner = "jatinkrmalik";
      repo = "vocalinux";
      rev = "v${version}";
      hash = "sha256-8t2pMR337kkqZIqz9TvZQY6EX7kxktl4LkBAlmorJHQ=";
    };

    build-system = with py; [ setuptools wheel ];

    # Upstream pins lxml>=6.1.0; nixpkgs currently ships 6.0.2. The pin is not
    # meaningful here (vocalinux uses only basic lxml APIs), so relax it.
    pythonRelaxDeps = [ "lxml" ];

    nativeBuildInputs = [
      super.wrapGAppsHook3
      super.gobject-introspection
    ];

    # GTK3 + the GObject-Introspection typelibs the UI imports: Gtk/Gdk/Pango
    # (gtk3), Notify (libnotify), IBus (ibus), and the tray icon, which tries
    # AyatanaAppIndicator3 first and falls back to legacy AppIndicator3 — both
    # typelibs come from libayatana-appindicator.
    buildInputs = with super; [
      gtk3
      glib
      gdk-pixbuf
      pango
      libnotify
      ibus
      libayatana-appindicator
    ];

    dependencies = (with py; [
      pygobject3
      pydub
      pynput
      evdev
      requests
      tqdm
      numpy
      pyaudio
      xlib
      psutil
      lxml
      onnxruntime # neural VAD (silero); the .onnx is bundled as package data
    ]) ++ [
      vosk
      pywhispercpp
    ];

    # buildPythonApplication wraps the entry point itself, which races with
    # wrapGAppsHook. The documented idiom is to disable the hook's own wrapping
    # and fold its env (GI_TYPELIB_PATH, GSETTINGS_SCHEMAS_PATH, ...) into our
    # wrapper args instead.
    dontWrapGApps = true;
    makeWrapperArgs = [
      "\${gappsWrapperArgs[@]}"
      # Runtime helpers Vocalinux shells out to. On this KDE Plasma Wayland
      # session text injection uses ydotool (needs the ydotoold daemon — see
      # modules/dictation.nix); the X11 tools are kept for completeness, and
      # pulseaudio/libnotify cover the start/stop sounds and notifications.
      "--prefix PATH : ${super.lib.makeBinPath (with super; [
        ydotool
        xdotool
        wtype
        wl-clipboard
        xclip
        xsel
        libnotify
        pulseaudio
      ])}"
    ];

    # The test suite needs a live display server, audio hardware and network
    # access (it downloads models), none of which exist in the Nix sandbox.
    doCheck = false;
    pythonImportsCheck = [ "vocalinux" ];

    # setuptools only installs the Python package; the launcher entry and icon
    # live at the repo root, so place them by hand for the application menu.
    postInstall = ''
      install -Dm644 vocalinux.desktop \
        $out/share/applications/vocalinux.desktop
      install -Dm644 src/vocalinux/resources/icons/scalable/vocalinux.svg \
        $out/share/icons/hicolor/scalable/apps/vocalinux.svg
    '';

    meta = with super.lib; {
      description = "Free, offline voice dictation for Linux (speech-to-text)";
      homepage = "https://github.com/jatinkrmalik/vocalinux";
      license = licenses.gpl3Only;
      platforms = [ "x86_64-linux" ];
      mainProgram = "vocalinux";
    };
  };
}

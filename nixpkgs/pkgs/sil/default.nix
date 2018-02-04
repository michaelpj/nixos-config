{ stdenv, fetchzip, ncurses, libX11, libXaw, libXt, libXext, libXmu, makeWrapper, writeScript, ... }:
let 
  setup = writeScript "setup" ''
    mkdir -p "$ANGBAND_PATH"
    # copy all the data files in
    cp -ar $1/* "$ANGBAND_PATH"
    # copied files are not writable, make them so
    chmod +w -R "$ANGBAND_PATH"
  '';
in
stdenv.mkDerivation rec {
  name = "Sil-${version}";
  version = "1.3.0";

  src = fetchzip {
    url = "http://www.amirrorclear.net/flowers/game/sil/Sil-130-src.zip";
    sha256 = "1amp2mr3fxascra0k76sdsvikjh8g76nqh46kka9379zd35lfq8w";
  };

  buildInputs = [ makeWrapper ncurses libX11 libXaw libXt libXext libXmu ];

  sourceRoot = "source/Sil/src";

  makefile = "Makefile.std";

  prePatch = ''
    # allow usage of ANGBAND_PATH
    substituteInPlace config.h --replace "#define FIXED_PATHS" "" 
  '';

  preConfigure = ''
    buildFlagsArray+=("LIBS=-lXaw -lXext -lSM -lICE -lXmu -lXt -lX11 -lncurses")
  '';

  installPhase = ''
    # the makefile doesn't have a sensible install target, so we hav to do it ourselves
    mkdir -p $out/bin
    cp sil $out/bin/sil
    # wrap the program to set a user-local ANGBAND_PATH, and run the setup script to copy files into place
    wrapProgram $out/bin/sil \
      --run "export ANGBAND_PATH=\$HOME/.sil" \
      --run "${setup} ${src}/Sil/lib"
  '';
}

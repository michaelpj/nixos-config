{ stdenv, fetchzip, ncurses, libX11, libXaw, libXt, libXext, libXmu, writeScriptBin, ... }:
let sil = stdenv.mkDerivation rec {
  name = "Sil-${version}";
  version = "1.3.0";

  zipname = "Sil-130-src.zip";
  src = fetchzip {
    url = "http://www.amirrorclear.net/flowers/game/sil/${zipname}";
    sha256 = "1amp2mr3fxascra0k76sdsvikjh8g76nqh46kka9379zd35lfq8w";
    stripRoot = false;
  };

  buildInputs = [ ncurses libX11 libXaw libXt libXext libXmu ];

  sourceRoot = "${zipname}/Sil/src";

  makefile = "Makefile.std";

  prePatch = ''
    substituteInPlace config.h --replace "#define FIXED_PATHS" "" 
  '';

  preConfigure = ''
    buildFlagsArray+=("CFLAGS=-g -fno-strength-reduce -D\"USE_X11\" -D\"USE_GCU\" -D\"PRIVATE_USER_PATH\" -D\"USE_PRIVATE_SAVE_PATH\"")
    #buildFlagsArray+=("CFLAGS=-O2 -fno-strength-reduce -fomit-frame-pointer -D\"USE_X11\" -D\"USE_TPOSIX\" -D\"USE_GETCH" -D\"USE_CURS_SET\" -D\"USE_GCU\" -D\"PRIVATE_USER_PATH\" -D\"USE_PRIVATE_SAVE_PATH\"")
    buildFlagsArray+=("LIBS=-lXaw -lXext -lSM -lICE -lXmu -lXt -lX11 -lncurses")
  '';

  installPhase = ''
    mkdir $out
    cp sil $out && cp -r ../lib $out
  '';
};
in
writeScriptBin "sil" ''
  mkdir -p ~/.sil/{scores,save,data}
  ${sil}/sil -dd=~/.sil/data $@
''

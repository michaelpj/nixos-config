self: super:

let
  teetty = super.rustPlatform.buildRustPackage rec {
    pname = "teetty";
    version = "0.4.0";

    src = super.fetchFromGitHub {
      owner = "mitsuhiko";
      repo = "teetty";
      rev = version;
      hash = "sha256-L5GlmbscAt6aqt79qq5UAeMeDscvpYUwjJZcSESMVj4=";
    };

    cargoHash = "sha256-fJ4TgQddr+OrvhSZFWcKyOvwkfBVQODHmq8E7nBOEZk=";

    # Tests require a real PTY which doesn't work in the Nix sandbox
    doCheck = false;

    meta = {
      description = "A bit like tee, a bit like script, but all with a fake tty. Lets you remote control and watch a process";
      homepage = "https://github.com/mitsuhiko/teetty";
      license = super.lib.licenses.asl20;
      mainProgram = "teetty";
    };
  };
in
{
  via = super.rustPlatform.buildRustPackage rec {
    pname = "via";
    version = "0.3.0";

    src = super.fetchFromGitHub {
      owner = "rehno-lindeque";
      repo = "via";
      rev = version;
      hash = "sha256-+mWNaFgSExiFxTTFt5IqTTQTIgn39dHsXGG0OczEqTc=";
    };

    cargoHash = "sha256-ay2xM2QMbcgO1Hq+OrNrEQmjCpPSz0KgHoLVDwb9tbY=";

    nativeBuildInputs = [ super.makeWrapper ];

    postInstall = ''
      wrapProgram $out/bin/via \
        --prefix PATH : ${super.lib.makeBinPath [
          teetty
          super.coreutils
        ]}
    '';

    meta = {
      description = "Issue commands across multiple interactive CLI sessions";
      homepage = "https://github.com/rehno-lindeque/via";
      license = super.lib.licenses.asl20;
      mainProgram = "via";
    };
  };
}

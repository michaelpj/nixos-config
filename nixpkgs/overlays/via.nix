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
    version = "0.2.0";

    src = super.fetchFromGitHub {
      owner = "rehno-lindeque";
      repo = "via";
      rev = "4dd97b42b83be3c881a4f96c94dbf913f639891b";
      hash = "sha256-aBO/nspVZ/cFAFbZ6hbescrVvI6pg6ANxvOUle/0GsQ=";
    };

    cargoHash = "sha256-30rcH/2xSjtsqYe6vFj2gEdmTskFj3TwDdo8tq1UAU8=";

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

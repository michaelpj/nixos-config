final: prev: {
  # from https://community.frame.work/t/tracking-ppd-v-tlp-for-amd-ryzen-7040/39423/137?u=michael_peyton_jones
  power-profiles-daemon = prev.power-profiles-daemon.overrideAttrs (
    old: {
      version = "0.13-1";

      src = prev.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "hadess";
        repo = "power-profiles-daemon";
        rev = "53fb59a2b90f837375bec633ee59c00140f4d18d";
        sha256 = "sha256-Kjljrf/xhwbLtNkKDQWKMVlflQDurk7727ZwgU2p/Vc=";
      };
    });
}

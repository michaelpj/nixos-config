final: prev: {
  # from https://community.frame.work/t/tracking-ppd-v-tlp-for-amd-ryzen-7040/39423/137?u=michael_peyton_jones
  power-profiles-daemon = prev.power-profiles-daemon.overrideAttrs (
    old: {
      version = "0.13-1";

      patches = (old.patches or []) ++ [
          (prev.fetchpatch {
            url = "https://gitlab.freedesktop.org/upower/power-profiles-daemon/-/merge_requests/127.patch"; 
            sha256= "sha256-jnq5yJvWQHOlZ78SE/4/HqiQfF25YHQH/T4wwDVRHR0=";
          })
          (prev.fetchpatch {
            url = "https://gitlab.freedesktop.org/upower/power-profiles-daemon/-/merge_requests/128.patch"; 
            sha256 = "sha256-YD9wn9IQlCp02r4lmwRnx9Eur2VVP1JfC/Bm8hlzF3Q=";
          })
          (prev.fetchpatch {
            url = "https://gitlab.freedesktop.org/upower/power-profiles-daemon/-/merge_requests/129.patch"; 
            sha256 = "sha256-9T+I3BAUW3u4LldF85ctE0/PLu9u+KBN4maoL653WJU=";
          })
      ];

      # explicitly fetching the source to make sure we're patching over 0.13 (this isn't strictly needed):
      src = prev.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "hadess";
        repo = "power-profiles-daemon";
        rev = "0.13";
        sha256 = "sha256-ErHy+shxZQ/aCryGhovmJ6KmAMt9OZeQGDbHIkC0vUE=";
      };
    });
}

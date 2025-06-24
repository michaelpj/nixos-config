final: prev: {
  mergiraf = prev.mergiraf.overrideAttrs (finalAttrs: prevAttrs: rec {
    version = "0.10.0";
		src = prev.fetchFromGitea {
			domain = "codeberg.org";
			owner = "mergiraf";
			repo = "mergiraf";
			rev = "174ee87c9bd9de77ef824b7797d9df7b418c65fb";
			hash = "sha256-OvV48s9Us/GaV4H+x0Qx+ZX85L+4fjfx1+gPqg3BR7A=";
		};
    cargoHash = "sha256-KCGX0QYnedoj3BTq+3pGXxjefPwhbbCd5q5auIvVWZ4=";
		cargoDeps = prev.rustPlatform.fetchCargoVendor {
			inherit (finalAttrs) pname src version;
			hash = finalAttrs.cargoHash;
		};
  });
}

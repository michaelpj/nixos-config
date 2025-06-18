final: prev: {
  mergiraf = prev.mergiraf.overrideAttrs (drv: {
		src = fetchFromGitea {
			domain = "codeberg.org";
			owner = "mergiraf";
			repo = "mergiraf";
			rev = "174ee87c9bd9de77ef824b7797d9df7b418c65fb";
			hash = "sha256-vnXOl7KzSvvxQP4CebOJ+fEIn7fQDKTmO2PkGMRA4t4=";
		};
  });
}

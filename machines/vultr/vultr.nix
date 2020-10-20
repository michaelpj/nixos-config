{
  server = 
    { config, pkgs, ... }:
    {
      imports = [ ./configuration.nix ];
      deployment.targetHost = "45.63.99.65";
    };
}

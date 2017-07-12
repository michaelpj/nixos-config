{
  server = 
    { config, pkgs, ... }:
    {
      imports = [ ./configuration.nix ];
      deployment.targetHost = "104.238.170.56";
    };
}

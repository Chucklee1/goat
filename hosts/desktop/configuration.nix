{
  lib,
  config,
  ...
}:
# desktop conf
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/default.nix
    home-manager.nixosModules.home-manager
  ];

  nvidia.enable = true;
  radeon.enable = false;
}

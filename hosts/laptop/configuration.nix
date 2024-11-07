{
  lib,
  config,
  ...
}:
# laptop conf
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/default.nix
    home-manager.nixosModules.home-manager
  ];

  nvidia.enable = false;
  radeon.enable = true;
}

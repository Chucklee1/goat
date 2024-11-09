{
  lib,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/default.nix
  ];

  # modules 
  nvidia.enable = true;
  
  # user
  networking.hostName = "goat";
  users.users.goat = {
    isNormalUser = true;
    description = "goat";
    extraGroups = ["networkmanager" "wheel"];
  }; 
 } 

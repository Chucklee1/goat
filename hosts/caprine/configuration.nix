# caprine configuration file
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
  nvidia.enable = false;
  
  # user
  networking.hostName = "caprine";
  users.users.goat = {
    isNormalUser = true;
    description = "caprine";
    extraGroups = ["networkmanager" "wheel"];
  }; 
 } 

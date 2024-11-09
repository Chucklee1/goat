# goat home file
{
  pkgs,
  config,
  ...
}: {
  imports = [ ../../modules/default-home.nix ];
  home = {
    username = "goat";
    homeDirectory = "/home/goat";
    stateVersion = "24.05"; # D O  N O T  C H A N G E
  };
}

# caprine home file
{
  pkgs,
  config,
  ...
}: {
  imports = [ ../../modules/default-home.nix ];
  home = {
    username = "caprine";
    homeDirectory = "/home/caprine";
    stateVersion = "24.05"; # D O  N O T  C H A N G E
  };
}

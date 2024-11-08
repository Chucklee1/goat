{
  ...
}: {
  # system user configuration
  users.users.goat = {
    isNormalUser = true;
    description = "goat";
    extraGroups = ["networkmanager" "wheel"];
  };
}

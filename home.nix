{
  pkgs,
  config,
  nixvim,
  ...
}: {
  imports = [./configs/waybar.nix];
  home = {
    # general statements
    username = "goat";
    homeDirectory = "/home/goat";
    stateVersion = "24.05"; # D O  N O T  C H A N G E
  };

  # user-level variables
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"; # disable window decoration for qt apps
    SDL_VIDEODRIVER = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_SESSION_TYPE = "wayland";
    CLUTTER_BACKEND = "wayland";
    GTK_CSD = "true";
  };

  home.file.".config/niri/config.kdl".source = ./configs/niri.kdl;

  # user theming
  gtk.iconTheme.name = "Papirus-Dark";

  # packages
  home.packages = with pkgs; [
    firefox
    vscode-fhs
    papirus-icon-theme
    wineWowPackages.waylandFull
  ];

  # smaller dotfiles
  programs = {
    fuzzel.enable = true;
    wlogout.enable = true;
    git = {
      enable = true;
      userEmail = "cooperkang4@gamil.com";
      userName = "Chucklee1";
    };
    kitty = {
      enable = true;
      settings = {
        scrollback_lines = 2000;
        wheel_scroll_min_lines = 1;
        window_padding_width = 4;
        confirm_os_window_close = 0;
      };
      extraConfig = ''
        tab_bar_style fade
        tab_fade 1
        active_tab_font_style   bold
        inactive_tab_font_style bold
      '';
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      # Core Neovim settings via `extraConfig`
      extraConfig = ''
        set clipboard=unnamedplus
        set number
        set tabstop=2
        set shiftwidth=2
        set expandtab  " Use spaces instead of tabs
      '';
    };
    bash = {
      enable = true;
      shellAliases = {
        sv = "sudo nvim";
        v = "nvim";
        exec-waybar = "pkill waybar && waybar &";
        exec-swww = "pkill swww && swww init && swww img ~/goat/configs/wallpapers/mono-forest.PNG";
        cg = "sudo nix-collect-garbage";
        update-desktop = "sudo nixos-rebuild switch --flake ~/goat#desktop --impure --show-trace";
        update-laptop = "sudo nixos-rebuild switch --flake ~/goat#laptop --impure --show-trace";
      };
    };
  };
}

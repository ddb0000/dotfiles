{ config, pkgs, ... }:

{
  home.username = "dan";
  home.homeDirectory = "/home/dan";

  # DO NOT CHANGE
  home.stateVersion = "24.11"; # DO NOT CHANGE

  nixpkgs.config.allowUnfree = true;
  # The home.packages option to install Nix packages
  home.packages = with pkgs; [
    firefox
    hyprland
    waybar
    kitty
    vscode
    git-crypt
    gnupg
    mpd
    mpc-cli
    yt-dlp
    wofi # or dmenu if on X11

    # Music and Wallpaper
    swww

    # File Manager
    ranger
  ];

  # Hyprland Confs
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, W, killactive" # Close window
        "$mod, Return, exec, kitty" # Launch terminal
        "$mod, F, exec, firefox" # Launch browser
        "$mod, M, exec, ~/.local/bin/mpd-launcher" # Music launcher
        "$mod, B, exec, pkill -USR1 waybar || waybar" # Toggle waybar

        # File Manager keybind
        "$mod, E, exec, kitty -e ranger" # Super+F: Launch Ranger in Kitty
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
          let ws = i + 1;
          in [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        )
        9)
      );
    };
    extraConfig = ''
      exec-once = swww init # Initialize swww wallpaper manager
    '';
  };

  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [
      {
        layer = "top";  # Ensure it's always visible
        position = "top";
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "battery" ];
      }
    ];
  };

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 12;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  # Add git config
  programs.git = {
    enable = true;
    userName = "nocivic";
    userEmail = "nocivic@proton.me";
  };

  # Add GH CLI
  programs.gh = {
    enable = true;
    package = pkgs.gh;
  };

  # Install firefox.
  programs.firefox.enable = true;

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

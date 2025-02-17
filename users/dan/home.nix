{ config, pkgs, ... }:

{
  home.username = "dan";
  home.homeDirectory = "/home/dan";

  # DO NOT CHANGE
  home.stateVersion = "24.11"; # DO NOT CHANGE

  # The home.packages option to install Nix packages
  home.packages = with pkgs; [
    kitty
    vscode
    git-crypt
    gnupg
    mpd
    mpc-cli
    yt-dlp
    wofi # or dmenu if on X11

    # Screenshots
    grim
    slurp
    wl-clipboard

    # Music and Wallpaper
    swww
    hyprpaper

    # File Manager
    ranger

    # Power menu
    wlogout
    pavucontrol
  ];

  # Hyprland Confs
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      input = {
        kb_layout = "br";
        kb_variant = "abnt2";
      };
      bind = [
        "$mod, W, killactive" # Close window
        "$mod, Return, exec, kitty" # Launch terminal
        "$mod, F, exec, firefox" # Launch browser
        "$mod, B, exec, pkill waybar || waybar" # Toggle waybar

        "$mod, S, exec, grim - | wl-copy" # Fullscreen screenshot to clipboard
        # File Manager keybind
        "Shift + $mod, S, exec, grim -g \"$(slurp)\" - | wl-copy" # Selectable screenshot to clipboard

        "$mod, D, exec, pkill -USR1 wofi || wofi --show drun" # Toggle application launcher
        "$mod, R, exec, pkill -USR1 wofi || wofi --show run" # Toggle command launcher
        "$mod, E, exec, pidof kitty && pkill kitty || kitty ranger" # Toggle file manager
        "$mod, L, exec, wlogout" # Power menu
        "$mod, U, exec, pidof pavucontrol && pkill pavucontrol || pavucontrol" # Toggle audio control panel
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
      exec-once = waybar # Auto-start waybar
    '';
  };

  # Add waybar
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [
      {
        layer = "top";
        position = "top";
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "tray" ];
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          on-click = "pidof pavucontrol && pkill pavucontrol || pavucontrol";  # Toggle Pavucontrol
          format-icons = {
            default = [ "" "" "" ];
          };
        };
      }
    ];
  };

  # Hyprpaper config
  services.hyprpaper = {
    enable = true;
    package = pkgs.hyprpaper;
    settings = {
      preload = [ "/home/dan/Pictures/wallpapers/bebop.png" ]; # Preload wallpaper
      wallpaper = [ "DP-2,/home/dan/Pictures/wallpapers/bebop.png" ]; # Corrected wallpaper setting
      interval = 600;
    };
  };

  # Set the cursor theme.
  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 12;
  };

  # Set the GTK theme, icon theme and font.
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

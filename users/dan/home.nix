{ config, pkgs, ... }:

{
  home.username = "dan";
  home.homeDirectory = "/home/dan";

  # DO NOT CHANGE
  home.stateVersion = "24.11"; # DO NOT CHANGE

  # The home.packages option to install Nix packages (Move to Home Manager options)
  home.packages = with pkgs; [
    git-crypt
    gnupg

    # Music
    mpd
    mpc-cli
    yt-dlp
    mpv
    vlc
  
    # Utilities
    wofi
    microfetch
    mako

    # Screenshots
    grim
    slurp
    wl-clipboard

    # Wallpaper
    waypaper
    swww
    mpvpaper

    # Timer
    termdown

    # File Manager
    yazi
    ueberzugpp
    joshuto
    # Power menu
    # wlogout -  added in options
    pavucontrol

    # Shell enhancements
    zsh-powerlevel10k
    lsd
    bat

    # Add font
    meslo-lgs-nf  # p10k recommended font
    libnotify   # For notify-send
  ];

  programs.kitty = {
    enable = true;
    themeFile = "Wombat";
  };

  programs.chromium.enable = true;
  # Hyprland Confs
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    settings = {
      general = {
        snap.enabled = true;
        resize_on_border = true;
        gaps_in = 2;
        gaps_out = 10;
      };
      decoration = {
        active_opacity = 0.9;
        inactive_opacity = 0.7;
      };
      "$mod" = "SUPER";
      input = {
        kb_layout = "br";
        kb_variant = "abnt2";
        numlock_by_default = true;
        follow_mouse =  2;
      };
      cursor.no_warps = true;
      cursor.inactive_timeout = 2;
      cursor.hide_on_key_press = true;

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
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
        "$mod, E, exec, pidof kitty && pkill kitty || kitty yazi" # Toggle file manager
        "$mod, L, exec, hyprlock " # Lock screen
        "$mod, P, exec, wlogout" # Launch power menu
        "$mod, U, exec, pidof pavucontrol && pkill pavucontrol || pavucontrol" # Toggle audio control panel
        "$mod, M, exec, ${config.home.homeDirectory}/.local/bin/nixmenu" # Launch nixmenu

        # Window layout toggles
        "$mod ALT, F, togglefloating"
        "$mod SHIFT, F, fullscreen"
        # Window movement
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"
        "$mod CTRL, left, resizeactive, -80 0"
        "$mod CTRL, right, resizeactive, 80 0"
        "$mod CTRL, up, resizeactive, 0 -80"
        "$mod CTRL, down, resizeactive, 0 80"

        # Toggle opacity ($mod + O = enable, $mod + SHIFT + O = disable)
        "$mod SHIFT, O, exec, hyprctl keyword decoration:active_opacity 1.0"
        "$mod SHIFT, O, exec, hyprctl keyword decoration:inactive_opacity 1.0"
        "$mod, O, exec, hyprctl keyword decoration:active_opacity 0.9"
        "$mod, O, exec, hyprctl keyword decoration:inactive_opacity 0.7"

        # Wallpaper
        "$mod SHIFT, W, exec, pgrep -x waypaper > /dev/null && pkill waypaper || waypaper"
        "$mod ALT, W, exec, waypaper --random"

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
      windowrulev2 = [
        # General Rules
        "float, title:^(Picture-in-Picture)$"
        "size 480 270, title:^(Picture-in-Picture)$"
        "move 100%-854 100%-480, title:^(Picture-in-Picture)$"
        "float,class:^(file_progress)$"
        "float,class:^(confirm)$"
        "float,class:^(dialog)$"
        "float,class:^(download)$"
        "float,class:^(notification)$"
        "float,class:^(error)$"
        "float,class:^(confirmreset)$"
        "float,title:^(Open File)$"
        "float,title:^(branchdialog)$"
        "float,title:^(Confirm to replace files)$"
        "float,title:^(File Operation Progress)$"
      ];
      windowrule = [
        # Existing waypaper rules
        "float, ^(waypaper)$"
        "center, ^(waypaper)$"
        "size 800 600, ^(waypaper)$"
        
        # Updated pavucontrol rules with correct class
        "float, ^(org.pulseaudio.pavucontrol)$"
        "size 400 600, ^(org.pulseaudio.pavucontrol)$"
        "move 100%-420 60, ^(org.pulseaudio.pavucontrol)$"
        "pin, ^(org.pulseaudio.pavucontrol)$"
      ];
    };
    extraConfig = ''
      exec-once = mako # Auto-start mako (notifications)
      exec-once = waybar # Auto-start waybar
      exec-once = waypaper --restore # Auto-start waypaper
      exec-once = hyprctl setcursor Bibata-Original-Classic 20 # Set cursor theme
      exec-once = code .
      exec-once = code .dotfiles
    '';
  };
  
  # Add waybar
  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "backlight/slider" "pulseaudio" ];
        pulseaudio = {
          format = "{volume}%";
          # Toggle Pavucontrol
          on-click = "pidof pavucontrol && pkill pavucontrol || pavucontrol";
        };
      }
    ];
    style = ''
    window#waybar {
      background-color: rgba(0, 0, 0, 0);
    }
    '';
  };

  /* for swww
  # Hyprpaper config
  services.hyprpaper = {
    enable = false;
    settings = {
      preload = [ "/home/dan/Pictures/wallpapers/bebop.png" ]; # Preload wallpaper
      wallpaper = [ "DP-2,/home/dan/Pictures/wallpapers/bebop.png" ]; # Corrected wallpaper setting
      interval = 600;
    };
  };
  */

  # Hyprlock config
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 0;
        hide_cursor = true;
        no_fade_in = true;
        no_fade_out = true;
      };
      background = [
        {
          monitor = "";
          # TODO: change this to dynamic path or in dotfiles with flake
          path = "/home/dan/Pictures/wallpapers/bebop.png";
          blur_passes = 2;
          blur_size = 5;
          noise = 0.1;
        }
      ];
      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_size = 0.1;
          dots_rounding = 0;
          fade_on_empty = false;
          outline_thickness = 1;
          rounding = 0;
          shadow_passes = 1;
          placeholder_text = "?";
          fail_text = "nope";
          inner_color = "rgba(0, 0, 0, 0)";
          outer_color = "rgba(255, 255, 255, 0.5)";
          font_color = "rgba(255, 255, 255, 0.8)";
        }
      ];
    };
  };

  # Wlogout config
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        text = "Logout";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Power Off";
      }
    ];
  };

  # Set the cursor theme.
  home.pointerCursor = {
    hyprcursor.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Original-Classic";
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
  };

  # Add VSCode
  programs.vscode = {
    enable = true;
    # userSettings = {
    #   "editor.fontFamily" = "MesloLGS NF";
    #   "terminal.integrated.fontFamily" = "MesloLGS NF";
    # };
  };

  # Install firefox.
  programs.firefox.enable = true;

  # ZSH Configuration
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initExtraFirst = ''
      # Enable Powerlevel10k instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';

    initExtra = ''
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };

  home.sessionVariables = {
    EDITOR = "code";    # Changed from 'nvim'
    VISUAL = "code";    # Added for completeness
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Add fonts configuration
  fonts.fontconfig.enable = true;
}

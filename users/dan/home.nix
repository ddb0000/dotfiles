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
    zed-editor
    git-crypt
    gnupg
    mpd
    mpc-cli
    yt-dlp
    wofi # or dmenu if on X11
    # etc...
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
        "$mod, M, exec, mpd-launcher" # Launch music
        "$mod, B, exec, waybar" # Launch bar
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
    size = 16;
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

  # Home Manager managing dotfiles.
  home.file.".config/mpd-sources/sources.txt".text = ''
    YouTube https://www.youtube.com/watch?v=dQw4w9WgXcQ
    Lofi https://www.youtube.com/watch?v=jfKfPfyJRdk
    Jazz https://www.youtube.com/watch?v=Dx5qFachd3A
    Synthwave https://www.youtube.com/watch?v=vc3s6wJklb0
  '';

  home.file.".local/bin/mpd-launcher".text = ''
  #!/bin/sh
  MENU="wofi --dmenu"
  [ -n "$XDG_SESSION_TYPE" ] && [ "$XDG_SESSION_TYPE" = "x11" ] && MENU="dmenu"

  choice=$(cut -d ' ' -f1 ~/.config/mpd-sources/sources.txt | $MENU)
  [ -z "$choice" ] && exit 1

  url=$(grep "^$choice " ~/.config/mpd-sources/sources.txt | cut -d ' ' -f2-)
  [ -z "$url" ] && exit 1

  audio_url=$(yt-dlp -f 'bestaudio' -g "$url")
  mpc clear
  mpc add "$audio_url"
  mpc play
  '';

  home.file.".local/bin/mpd-launcher".executable = true;


  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

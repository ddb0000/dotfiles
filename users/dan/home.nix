{ config, pkgs, ... }:

let
  screenshot_full_script = pkgs.writeShellScriptBin {
    name = "screenshot_full";
    text = ''
      grim - | wl-copy
    '';
  };

  screenshot_region_script = pkgs.writeShellScriptBin {
    name = "screenshot_region";
    text = ''
      grim -g "$(slurp)" - | wl-copy
    '';
  };

in
{
  home.username = "dan";
  home.homeDirectory = "/home/dan";
  home.stateVersion = "24.11";
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # ... other packages ...
    grim
    slurp
    wl-clipboard
    ranger
  ];

  # Hyprland Confs
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, W, killactive"
        "$mod, Return, exec, kitty"
        "$mod, F, exec, firefox"
        "$mod, M, exec, ~/.local/bin/mpd-launcher"
        # Removed: "$mod, B, exec, waybar"

        # Screenshot keybinds - EXECUTE NIX-GENERATED SHELL SCRIPTS
        "Print, exec, ${screenshot_full_script}/bin/screenshot_full"
        "Shift + Print, exec, ${screenshot_region_script}/bin/screenshot_region"

        "$mod, E, exec, kitty -e ranger"
      ]
      ++ (
        builtins.concatLists (builtins.genList (i:
          let ws = i + 1;
          in [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        ) 9)
      );
    };
    extraConfig = ''
      exec-once = swww init
    '';
  };

  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [
      {
        layer = "top";
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

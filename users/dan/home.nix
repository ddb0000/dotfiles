{ config, pkgs, ... }:

{
  home.username = "dan";
  home.homeDirectory = "/home/dan";

  # DO NOT CHANGE
  home.stateVersion = "24.11"; # DO NOT CHANGE

  nixpkgs.config.allowUnfree = true;
  # The home.packages option to install Nix packages
  home.packages = with pkgs; [
    # kitty
    alacritty
    vscode
    zed-editor
    git-crypt
    gnupg
    gimp
    # etc...
  ];

  # Add git config
  programs.git = {
    enable = true;
    userName = "nocivic";
    userEmail = "nocivic@proton.me";
  };


  # And GH CLI
  programs.gh = {
    enable = true;
    package = pkgs.gh;
  };

  # Home Manager managing dotfiles.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/dan/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

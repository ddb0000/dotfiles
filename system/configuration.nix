{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Weekly Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };
  nix.settings.auto-optimise-store = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable MPD
  services.mpd = {
    enable = true;
    musicDirectory = "/home/dan/Downloads/music"; # Optional system-wide music directory
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "pipewire"
      }
    '';
    # network.listenAddress = "any"; # if you want network access (optional)
    # network.startWhenNeeded = true; # systemd activation (optional)
  };
  users.users.mpd.extraGroups = [ "audio" ]; # Add mpd user to audio group declaratively
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Hyprland config
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  security.pam.services.hyprlock = {};
  
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # NVIDIA
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false; # Set to true for open-source drivers
  };
  hardware.graphics.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # User config
  users.users.dan = {
    isNormalUser = true;
    description = "dan";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  # Enable zsh
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];


  # Environment Variables for Wayland Apps
  environment.sessionVariables = {
    # If your cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint Electron apps to use Wayland
    NIXOS_OZONE_WL = "1";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Basic
    git
    wget
    vim
    # Language Servers
    nixd
    nil
    # etc...
    greetd.tuigreet

    # XDG
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  # Add greetd configuration
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # Add environment variable for greetd
  environment.etc."greetd/environments".text = ''
    Hyprland
  '';
}

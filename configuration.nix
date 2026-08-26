# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  hostname,
  ...
}:

{
  nixpkgs.overlays = [
    (final: prev: {
      equicord = prev.equicord.overrideAttrs (finalAttrs: prevAttrs: {
        version = "2026-05-01";
        src = final.fetchFromGitHub {
          owner = "Equicord";
          repo = "Equicord";
          tag = finalAttrs.version;
          hash = "sha256-58UE2G2Pvay4wfQuH4CD7QFGizPKWYuLJgJLLJp+6lA=";
        };
        pnpmDeps = final.fetchPnpmDeps {
          inherit (finalAttrs) pname version src;
          pnpm = final.pnpm_10;
          fetcherVersion = 3;
          hash = "sha256-RwppRWrEzIKZDb3QLVAMd1bHXyFwiatYNiNccVgrcWA=";
        };
      });
    })
  ];

  imports = [
    ./customization.nix
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.dconf.enable = true;

  # Enable networking
  networking.hostName = hostname; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];

  # Set your time zone.
  time.timeZone = "America/New_York";
  # services.automatic-timezoned.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  
  hardware.opentabletdriver.enable = true;
  
  # printing stuff
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      cnijfilter2
    ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  powerManagement.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.hack
    noto-fonts
    noto-fonts-color-emoji
    liberation_ttf
    inputs.fonts.packages.${pkgs.stdenv.hostPlatform.system}.bahnschrift
  ];

  # Define a user account. Don\"t forget to set a password with ‘passwd’.
  users.users.rickyrnt = {
    isNormalUser = true;
    description = "rickyrnt";
    extraGroups = [
      "networkmanager"
      "wheel"
      "pipewire"
      "audio"
      "libvirtd"
    ];
    shell = pkgs.zsh;
  };

  # File manager
  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
  programs.thunar.plugins = with pkgs; [
    thunar-archive-plugin
    thunar-volman
  ];

  programs.firefox.enable = true;
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  security.protectKernelImage = false;

  networking.nameservers = [
    "1.1.1.1#one.one.one.one"
    "1.0.0.1#one.one.one.one"
  ];
  programs.openvpn3.enable = true;

  services.openvpn.servers.bboysenc = {
    autoStart = false;
    updateResolvConf = true;
    config = "config /home/rickyrnt/client.ovpn";
  };

  services.tailscale.enable = true;

  environment.variables = {
    SUDO_EDITOR = "nvim";
    EDITOR = "nvim";
  };
  
  environment.sessionVariables.LD_LIBRARY_PATH = [
    "${pkgs.espeak}/lib"
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  security.polkit.enable = true;

  services.udisks2.enable = true; # For calibre to see ereaders

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    tmux
    lxappearance-gtk2
    killall
    powertop
    btop
    qpwgraph
    vlc
    lm_sensors
    wl-clipboard
    pulseaudio
    pavucontrol
    gparted
    hyprpolkitagent

    bluetui
    jq

    fuse
    ntfs3g
    comma
    p7zip
    dig

    pay-respects
    fastfetch
    lolcat
    
    kdePackages.ark
  ];

  programs.zsh.enable = true;
  programs.steam.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}

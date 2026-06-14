# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
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
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
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

  networking.hostName = "M04RYS8"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];

  # Set your time zone.
  # time.timeZone = "America/New_York";
  services.automatic-timezoned.enable = true;

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

  programs.zsh.enable = true;

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
  
  programs.wireshark.enable = true;

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

  fonts.packages = with pkgs; [
    nerd-fonts.hack
    noto-fonts
    noto-fonts-color-emoji
    liberation_ttf
    inputs.fonts.packages.${pkgs.stdenv.hostPlatform.system}.bahnschrift
  ];

  # File manager
  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
  programs.thunar.plugins = with pkgs; [
    thunar-archive-plugin
    thunar-volman
  ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  
  services.printing.enable = true;

  programs.firefox.enable = true;
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  powerManagement.enable = true;

  security.protectKernelImage = false;

  networking.nameservers = [
    "1.1.1.1#one.one.one.one"
    "1.0.0.1#one.one.one.one"
  ];
  programs.openvpn3.enable = true;

  fileSystems."/mnt/jellyfin" = {
    device = "casey.bboysenc:/home/jellyfin";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" ];
  };
  boot.supportedFilesystems = [ "nfs" ];
  
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

  # virtualization
  programs.virt-manager.enable = true;
  users.groups.livirtd.members = ["rickyrnt"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  
  security.polkit.enable = true;

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
    virtio-win
    libvirt-glib
    virtiofsd
    hyprpolkitagent

    bluetui

    fuse
    ntfs3g
    comma
    p7zip
    dig
    # ventoy

    pay-respects
    fastfetch
    lolcat
    
    kdePackages.ark
    #  wget
    # pkgs-unstable.wireshark
  ];

  services.flatpak.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
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
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}

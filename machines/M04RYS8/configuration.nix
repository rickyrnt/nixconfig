{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./laptop.nix
  ];

  # virtualization
  programs.virt-manager.enable = true;
  users.groups.livirtd.members = ["rickyrnt"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  
  boot.binfmt.emulatedSystems = [ "aarch64-linux" "x86_64-windows" ];

  hardware.opentabletdriver.enable = true;
  
  services.openssh.authorizedKeysFiles = [ "/home/rickyrnt/nixos/secrets/aola-morris.pub" ];
  
  services.onedrive.enable = true;
  
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings.main = {
          home = "play";
          pageup = "nextsong";
          pagedown = "previoussong";
        };
      };
    };
  };
  
  services.sunshine = {
    enable = true;
    package = pkgs.sunshine.override { cudaSupport = true; };
    # openFirewall = true;
  };
  systemd.user.services.sunshine.environment.CUDA_VISIBLE_DEVICES = "1";

  environment.systemPackages = with pkgs; [
    virtio-win
    libvirt-glib
    virtiofsd
    
    archipelago
  ];

  programs.wireshark.enable = true;

  services.flatpak.enable = true;

  system.stateVersion = "24.11"; # Did you read the comment?
}
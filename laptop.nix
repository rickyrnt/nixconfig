{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./isw-module.nix
  ];

  boot.resumeDevice = "/dev/nvme1n1p1";

  # isw fan management for msi laptops
  nixpkgs.overlays = [
    (self: super: {
      isw = super.callPackage ./isw.nix { };
    })
  ];

  services.isw.enable = true;
  systemd.targets.multi-user.wants = [ "isw@16S3EMS1.service" ];

  # power management
  services.tlp.enable = true;
  services.tlp.settings = {
    PLATFORM_PROFILE_ON_AC = "performance";
    PLATFORM_PROFILE_ON_BAT = "low-power";
    CPU_MAX_PERF_ON_BAT = 70;
    CPU_MAX_PERF_ON_AC = 100;
    RESTORE_DEVICE_STATE_ON_STARTUP = 1;
  };

  # Mount windows drive
  fileSystems."/win" = {
    device = "/dev/nvme0n1p3";
    options = [
      "users"
      "nofail"
    ];
  };

  # nvidia gpu settings
  services.supergfxd.enable = true;
  # Fine-grained power management. Turns off GPU when not in use.
  # Experimental and only works on modern Nvidia GPUs (Turing or newer).
  hardware.nvidia.powerManagement.finegrained = true;
  hardware.nvidia.prime = {
    intelBusId = "PCI:1:0:0";
    nvidiaBusId = "PCI:0:2:0";
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
  ];

  # power management
  services.tlp.enable = true;
  services.tlp.settings = {
    PLATFORM_PROFILE_ON_AC = "performance";
    PLATFORM_PROFILE_ON_BAT = "low-power";
    CPU_MAX_PERF_ON_BAT = 70;
    CPU_MAX_PERF_ON_AC = 100;
    RESTORE_DEVICE_STATE_ON_STARTUP = 1;
  };
}

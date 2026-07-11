{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:
{
  # The home.stateVersion option does not have a default and must be set
  home.stateVersion = "26.05";
  
  home.packages = with pkgs; [
    wvkbd
  ];
  
  wayland.windowManager.hyprland = {
    plugins = [
      inputs.hyprgrass.packages.${pkgs.system}.default
    ];
    settings = with inputs.hmHyprLib.lib; {
      on = autostart [
        "iio-hyprland"
        "wvkbd-deskintl --hidden"
      ];
      config = {
        "plugin.hyprgrass" = {
          sensitivity = 1.0;
          long_press_delay = 400;
        };
        gestures = {
          workspace_swipe_touch = true;
          workspace_swipe_cancel_ratio = 0.15;
        };
      };
    };
    extraConfig = ''
      hl.plugin.hyprgrass.gesture({
        pattern = {kind = "swipe", fingers = 3, direction = "down"},
        action = "close",
      })
      hl.plugin.hyprgrass.gesture({
        pattern = {kind = "edge", origin = "up", direction = "down"},
        action = "special",
        workspace_name = "discord",
      })
      hl.plugin.hyprgrass.bind({
        pattern = {kind = "longpress", fingers = 3},
        action = hl.dsp.window.drag(),
        mouse = true,
      })
    '';
  };
}
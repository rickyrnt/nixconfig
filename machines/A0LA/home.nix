{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  lib,
  ...
}:
{
  # The home.stateVersion option does not have a default and must be set
  home.stateVersion = "26.05";
  
  home.packages = with pkgs; [
    wvkbd
    moonlight-qt
    inputs.hyprgrass.packages.${pkgs.system}.default
  ];
  
  wayland.windowManager.hyprland = with inputs.hmHyprLib.lib; let
    lu = lib.generators.mkLuaInline;
  in {
    plugins = [
      inputs.hyprgrass.packages.${pkgs.system}.default
    ];
    settings = with inputs.hmHyprLib.lib; {
      on = autostart [
        "waybar"
        "hyprpaper"
        "systemctl --user start hyprpolkitagent"
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
      bind = [
        (dspBind "CTRL + ALT + w" (lu ''function()
          hl.dispatch(hl.dsp.focus({workspace='name:moonlight'}))
          hl.dispatch(hl.dsp.submap('moonlight'))
          end''))
        (dspBind "ALT + SHIFT + w" (windowArgs "move" "{workspace='name:moonlight'}"))
      ];
    };
    submaps = {
      moonlight.settings = {
        bind = [
          (dspBind "SUPER + CTRL + ALT + e" (lu ''function()
            hl.dispatch(hl.dsp.submap('reset'))
            hl.dispatch(hl.dsp.focus({workspace='previous_per_monitor'}))
            end''))
          (dspBind "SUPER + CTRL + ALT + r" (dspCallArgs "submap" "'reset'"))
        ];
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
        pattern = {kind = "edge", origin = "down", direction = "up"},
        action = hl.dsp.exec_cmd("kill -s 34 $(ps -C wvkbd-deskintl)")
      })
      hl.plugin.hyprgrass.bind({
        pattern = {kind = "longpress", fingers = 3},
        action = hl.dsp.window.drag(),
        mouse = true,
      })
    '';
  };
}
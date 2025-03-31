{ config, pkgs, ... }:
let
	wallpaper-photo = pkgs.fetchurl {
		url = "https://images.steamusercontent.com/ugc/1170321140105641126/47F1E70BD90DB25A97F3B761B07764F7F947287E/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false";
		name = "wallpaper-photo";
		hash = "sha256-i94PzTtGdLVQlujgwrTB4NuJ/Zb58SCfo0g26NQXbH0=";
	};
in
{
	qt = {
		enable = true;
		platformTheme = "gnome";
		style = "adwaita-dark";
	};

	services.displayManager.sddm = {
		package = pkgs.kdePackages.sddm;
		enable = true;
		wayland.enable = true;
		theme = let
			my-astronaut-theme = pkgs.sddm-astronaut.override {
				themeConfig = {
					Background="\"${wallpaper-photo}\"";
					## Path relative to the theme root directory. Most standard image file formats are allowed including support for transparency. (e.g. background.jpeg/illustration.GIF/Foto.png/undraw.svgz)

					DimBackgroundImage="\"0.0\"";
					## Double between 0 and 1 used for the alpha channel of a darkening overlay. Use to darken your background image on the fly.

					ScaleImageCropped="\"true\"";
					## Whether the image should be cropped when scaled proportionally. Setting this to false will fit the whole image instead, possibly leaving white space. This can be exploited beautifully with illustrations (try it with "undraw.svg" included in the theme).

					ScreenWidth="\"1920\"";
					ScreenHeight="\"1080\"";
					## Adjust to your resolution to help SDDM speed up on calculations


					## [Blur Settings]

					FullBlur="\"false\"";
					PartialBlur="\"true\"";
					## Enable or disable the blur effect; if HaveFormBackground is set to true then PartialBlur will trigger the BackgroundColor of the form element to be partially transparent and blend with the blur.

					BlurRadius="\"30\"";
					## Set the strength of the blur effect. Anything above 100 is pretty strong and might slow down the rendering time. 0 is like setting false for any blur.


					## [Design Customizations]

					HaveFormBackground="\"false\"";
					## Have a full opacity background color behind the form that takes slightly more than 1/3 of screen estate;  if PartialBlur is set to true then HaveFormBackground will trigger the BackgroundColor of the form element to be partially transparent and blend with the blur.

					FormPosition="\"center\"";
					## Position of the form which takes roughly 1/3 of screen estate. Can be left, center or right.

					BackgroundImageHAlignment="\"center\"";
					## Horizontal position of the background picture relative to its visible area. Applies when ScaleImageCropped is set to false or when HaveFormBackground is set to true and FormPosition is either left or right. Can be left, center or right; defaults to center if none is passed.

					BackgroundImageVAlignment="\"center\"";
					## As before but for the vertical position of the background picture relative to its visible area.

					MainColor="#\"F8F8F2\"";
					## Used for all elements when not focused/hovered etc. Usually the best effect is achieved by having this be either white or a very dark grey like #444 (not black for smoother antialias)
					## Colors can be HEX or Qt names (e.g. red/salmon/blanchedalmond). See https://doc.qt.io/qt-5/qml-color.html

					AccentColor="#\"343746\"";
					## Used for elements in focus/hover/pressed. Should be contrasting to the background and the MainColor to achieve the best effect.

					OverrideTextFieldColor="\"\"";
					## The text color of the username & password when focused/pressed may become difficult to read depending on your color choices. Use this option to set it independently for legibility.

					BackgroundColor="\"#21222C\"";
					## Used for the user and session selection background as well as for ScreenPadding and FormBackground when either is true. If PartialBlur and FormBackground are both enabled this color will blend with the blur effect.

					placeholderColor="\"#bbbbbb\"";
					## Placholder text color. Example: username, password.

					IconColor="\"#ffffff\"";
					## System icon colors

					OverrideLoginButtonTextColor="\"\"";
					## The text of the login button may become difficult to read depending on your color choices. Use this option to set it independently for legibility.

					InterfaceShadowSize="\"6\"";
					## Integer used as multiplier. Size of the shadow behind the user and session selection background. Decrease or increase if it looks bad on your background. Initial render can be slow no values above 5-7.

					InterfaceShadowOpacity="\"0.6\"";
					## Double between 0 and 1. Alpha channel of the shadow behind the user and session selection background. Decrease or increase if it looks bad on your background.

					RoundCorners="\"20\"";
					## Integer in pixels. Radius of the input fields and the login button. Empty for square. Can cause bad antialiasing of the fields.

					ScreenPadding="\"0\"";
					## Integer in pixels. Increase or delete this to have a padding of color BackgroundColor all around your screen. This makes your login greeter appear as if it was a canvas. Cool!

					Font="\"Open Sans\"";
					## If you want to choose a custom font it will have to be available to the X root user. See https://wiki.archlinux.org/index.php/fonts#Manual_installation

					FontSize="\"\"";
					## Only set a fixed value if fonts are way too small for your resolution. Preferrably kept empty.

					HideLoginButton="\"true\"";
					## Hides login button if set to true.


					## [Interface Behavior]

					ForceRightToLeft="\"false\"";
					## Revert the layout either because you would like the login to be on the right hand side or SDDM won\"t respect your language locale for some reason. This will reverse the current position of FormPosition if it is either left or right and in addition position some smaller elements on the right hand side of the form itself (also when FormPosition is set to center).

					ForceLastUser="\"true\"";
					## Have the last successfully logged in user appear automatically in the username field.

					ForcePasswordFocus="\"true\"";
					## Give automatic focus to the password field. Together with ForceLastUser this makes for the fastest login experience.

					ForceHideCompletePassword="\"true\"";
					## If you don\"t like to see any character at all not even while being entered set this to true.

					ForceHideVirtualKeyboardButton="\"false\"";
					## Do not show the button for the virtual keyboard at all. This will completely disable functionality for the virtual keyboard even if it is installed and activated in sddm.conf

					ForceHideSystemButtons="\"false\"";
					## Completely disable and hide any power buttons on the greeter.

					AllowEmptyPassword="\"false\"";
					## Enable login for users without a password. This is discouraged. Makes the login button always enabled.

					AllowBadUsernames="\"false\"";
					## Do not change this! Uppercase letters are generally not allowed in usernames. This option is only for systems that differ from this standard!


					## [Locale Settings]

					Locale="\"\"";
					## The time and date locale should usually be set in your system settings. Only hard set this if something is not working by default or you want a seperate locale setting in your login screen.

					HourFormat="\"HH:mm\"";
					## Defaults to Locale.ShortFormat - Accepts "long" or a custom string like "hh:mm A". See http://doc.qt.io/qt-5/qml-qtqml-date.html

					DateFormat="\"dddd d MMMM\"";
					## Defaults to Locale.LongFormat - Accepts "short" or a custom string like "dddd, d \"of\" MMMM". See http://doc.qt.io/qt-5/qml-qtqml-date.html



					## [Translations]

					HeaderText="\"\"";
					## Header can be empty to not display any greeting at all. Keep it short.

					## SDDM may lack proper translation for every element. Suger defaults to SDDM translations. Please help translate SDDM as much as possible for your language: https://github.com/sddm/sddm/wiki/Localization. These are in order as they appear on screen.

					TranslatePlaceholderUsername="\"\"";
					TranslatePlaceholderPassword="\"\"";
					TranslateLogin="\"\"";
					TranslateLoginFailedWarning="\"\"";
					TranslateCapslockWarning="\"\"";
					TranslateSuspend="\"\"";
					TranslateHibernate="\"\"";
					TranslateReboot="\"\"";
					TranslateShutdown="\"\"";
					TranslateVirtualKeyboardButton="\"\"";
					## These don\"t necessarily need to translate anything. You can enter whatever you want here.
				};
			};
		in "${my-astronaut-theme}/share/sddm/themes/sddm-astronaut-theme";
		# theme = "sddm-astronaut-theme";
		extraPackages = with pkgs; [sddm-astronaut];
	};

	home-manager.users.rickyrnt = {
		gtk = {
			enable = true;
			theme = {
				name = "Adwaita-dark";
				package = pkgs.gnome-themes-extra;
			};
		};

		services.hyprpaper.enable = true;
		services.hyprpaper.settings = {
			preload = [
				"${wallpaper-photo}"
			];
			wallpaper = [
				", ${wallpaper-photo}"
			];
		};

		programs.hyprlock.enable = true;
		programs.hyprlock.settings = {
			background = {
				path = "${wallpaper-photo}";
				color = "rgba(25,20,20,1.0)";
			};
			label = {
				text = "";
				font_size = 25;
				font_family = "Noto Sans";
			};
			input-field = {
				size = "200, 50";
				outline_thickness = 3;
				dots_size = 0.2;
				dots_spacing = 0.15;
				dots_center = false;
				dots_rounding = -1;
				outer_color = "rgb(151515)";
				inner_color = "rgb(200,200,200)";
				font_color = "rgb(10,10,10)";
				fade_on_empty = true;
				fade_timeout = 2000;
				placeholder_text = "bQ^YB";
				hide_input = false;
				rounding = -1;
				check_color = "rgb(204,135,34)";
				fail_color = "rgb(204,34,34)";
				fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
				fail_transition = 300;
				capslock_color = -1;
				numlock_color = -1;
				bothlock_color = -1;
				invert_numlock = false;
				position = "0,0";
				halign = "center";
				valign = "center";
			};
		};

		wayland.windowManager.hyprland.enable = true;
		wayland.windowManager.hyprland.settings = {
			# Monitors
			monitor = [
				"eDP-1,highres@highrr,0x0,1"
				"HDMI-A-1,highres@highrr,auto-left,1"
			];

			# Programs
			"$terminal" = "kitty";
			"$fileManager" = "thunar";
			"$menu" = "wofi --show drun";
			"$supermenu" = "wofi --show run";
			"$rebar" = "killall -v .waybar-wrapped; waybar &";
			"$vencordize" = "hyprctl dispatch exec vesktop";

			# Autostart
			exec-once = [
				"waybar & hyprpaper"
			];

			general = {
				gaps_in = 5;
				gaps_out = 10;

				border_size = 2;

				# https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
				"col.active_border" = "rgba(cc009977) rgba(ee00ee33) 45deg";
				"col.inactive_border" = "rgba(00aaaa49)";

				# Set to true enable resizing windows by clicking and dragging on borders and gaps
				resize_on_border = false;

				# Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
				allow_tearing = false;

				layout = "dwindle";
			};

			decoration = {
				rounding = 3;

				# Change transparency of focused and unfocused windows
				active_opacity = 1.0;
				inactive_opacity = 1.0;

				shadow = {
					enabled = true;
					range = 4;
					render_power = 3;
					color = "rgba(1a1a1aee)";
				};

				# https://wiki.hyprland.org/Configuring/Variables/#blur
				blur = {
					enabled = false;
					size = 3;
					passes = 1;

					vibrancy = 0.1696;
				};
			};

			misc = {
				force_default_wallpaper = 0;
				disable_hyprland_logo = true;
			};

			input = {
				follow_mouse = 2;
				touchpad.natural_scroll = true;
			};

			gestures.workspace_swipe = true;

			# Keybinds
			"$mod" = "SUPER";
			bind = [
				"ALT, f1, exec, $terminal"
				"ALT, f2, exec, $menu"
				"$mod, f2, exec, $supermenu"
				"ALT, f3, exec, firefox"
				"ALT, f4, killactive,"
				"ALT, f5, exec, $fileManager"
				"ALT, f6, exec, code"
				"ALT, f11, exec, $vencordize"

				"$mod, ESCAPE, exec, $rebar"
				"$mod, S, togglefloating,"
				"$mod, M, fullscreen, 1"
				"$mod, F, fullscreen, 0"
				"$mod, P, pseudo,"
				"$mod, J, togglesplit,"
				"$mod, L, exec, hyprlock"

				"ALT, left, movefocus, l"
				"ALT, right, movefocus, r"
				"ALT, up, movefocus, u"
				"ALT, down, movefocus, d"
				"ALT, h, movefocus, l"
				"ALT, l, movefocus, r"
				"ALT, k, movefocus, u"
				"ALT, j, movefocus, d"

				"$mod, B, togglespecialworkspace, magic"
				"$mod SHIFT, B, movetoworkspace, special:magic"
				"$mod, D, togglespecialworkspace, discord"
				"$mod SHIFT, D, movetoworkspace, special:discord"

				"CTRL ALT, mouse_up, workspace, e+1"
				"CTRL ALT, mouse_down, workspace, e-1"
				"CTRL ALT, l, workspace, r+1"
				"CTRL ALT, h, workspace, r-1"

				",PGUP, exec, playerctl next"
				",HOME, exec, playerctl play-pause"
				",PGDN, exec, playerctl previous"
			] ++ (
				builtins.concatLists(builtins.genList(i:
					let ws = i + 1;
					in [
						"CTRL ALT, code:1${toString i}, workspace, ${toString ws}"
						"ALT SHIFT, code:1${toString i}, movetoworkspacesilent, ${toString ws}"
					]
				)9)
			);

			bindm = [
				"$mod, mouse:272, movewindow"
				"$mod, mouse:273, resizewindow"
			];

			bindel = [
				",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"	
				",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"	
				",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
				",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
				",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
				",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
			];

			bindl = [
				",XF86AudioNext, exec, playerctl next"
				",XF86AudioPause, exec, playerctl play-pause"
				",XF86AudioPlay, exec, playerctl play-pause"
				",XF86AudioPrev, exec, playerctl previous"
			];


			workspace = [
				"n[e:discord] w[tv1], gapsout:0, gapsin:0"
				"n[e:discord] f[1], gapsout:0, gapsin:0"
			];

			windowrulev2 = [
				"noborder, class:vesktop, floating:0, onworkspace:w[tv1] s[true]"
				"rounding 0, class:vesktop, floating:0, onworkspace:w[tv1] s[true]"
				"noborder, class:vesktop, floating:0, onworkspace:s[true], onworkspace:f[1]"
				"rounding 0, class:vesktop, floating:0, onworkspace:s[true], onworkspace:f[1]"
				"workspace special:discord, class:vesktop"
			];

			animations = {
				enabled = "yes, please :)";

				# Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

				bezier = [
					"easeOutQuint,0.23,1,0.32,1"
					"easeInOutCubic,0.65,0.05,0.36,1"
					"linear,0,0,1,1"
					"almostLinear,0.5,0.5,0.75,1.0"
					"quick,0.15,0,0.1,1"
				];

				animation = [
					"global, 1, 10, default"
					"border, 1, 5.39, easeOutQuint"
					"windows, 1, 4.79, easeOutQuint"
					"windowsIn, 1, 4.1, easeOutQuint, popin 87%"
					"windowsOut, 1, 1.49, linear, popin 87%"
					"fadeIn, 1, 1.73, almostLinear"
					"fadeOut, 1, 1.46, almostLinear"
					"fade, 1, 3.03, quick"
					"layers, 1, 3.81, easeOutQuint"
					"layersIn, 1, 4, easeOutQuint, fade"
					"layersOut, 1, 1.5, linear, fade"
					"fadeLayersIn, 1, 1.79, almostLinear"
					"fadeLayersOut, 1, 1.39, almostLinear"
					"workspaces, 1, 1.94, almostLinear, fade"
					"workspacesIn, 1, 1.21, almostLinear, fade"
					"workspacesOut, 1, 1.94, almostLinear, fade"
				];
			};
		};
	};
}

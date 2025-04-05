{ config, pkgs, ... }:
let
	wallpaper-photo = pkgs.fetchurl {
		url = "https:#images.steamusercontent.com/ugc/1170321140105641126/47F1E70BD90DB25A97F3B761B07764F7F947287E/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false";
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

	services.displayManager.sddm = let
		my-astronaut-theme = pkgs.sddm-astronaut.override {
			themeConfig = {
				Background="\"${wallpaper-photo}\"";
				DimBackgroundImage="\"0.0\"";
				ScaleImageCropped="\"true\"";
				ScreenWidth="\"1920\"";
				ScreenHeight="\"1080\"";

				## [Blur Settings]
				FullBlur="\"false\"";
				PartialBlur="\"false\"";
				BlurRadius="\"0\"";

				## [Design Customizations]
				HaveFormBackground="\"false\"";
				FormPosition="\"center\"";
				BackgroundImageHAlignment="\"center\"";
				BackgroundImageVAlignment="\"center\"";
				MainColor="\"#F8F8F2\"";
				AccentColor="\"#343746\"";
				OverrideTextFieldColor="\"\"";
				BackgroundColor="\"#21222C\"";
				placeholderColor="\"#bbbbbb\"";
				IconColor="\"#ffffff\"";
				OverrideLoginButtonTextColor="\"\"";
				InterfaceShadowSize="\"6\"";
				InterfaceShadowOpacity="\"0.6\"";
				RoundCorners="\"20\"";
				ScreenPadding="\"0\"";
				Font="\"Open Sans\"";
				FontSize="\"\"";
				HideLoginButton="\"true\"";

				## [Interface Behavior]
				ForceRightToLeft="\"false\"";
				ForceLastUser="\"true\"";
				ForcePasswordFocus="\"true\"";
				ForceHideCompletePassword="\"true\"";
				ForceHideVirtualKeyboardButton="\"false\"";
				ForceHideSystemButtons="\"false\"";
				AllowEmptyPassword="\"false\"";
				AllowBadUsernames="\"false\"";

				## [Locale Settings]
				Locale="\"\"";
				HourFormat="\"HH:mm\"";
				DateFormat="\"dddd d MMMM\"";

				## [Translations]
				HeaderText="\"\"";
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
			};
		};
	in {
		package = pkgs.kdePackages.sddm;
		enable = true;
		wayland.enable = true;
		theme = "${my-astronaut-theme}/share/sddm/themes/sddm-astronaut-theme";
		# theme = "sddm-astronaut-theme";
		extraPackages = with pkgs; [my-astronaut-theme];
	};

	home-manager.users.rickyrnt = {
		imports = [
			./mechabar.nix
		];
		
		home.packages = with pkgs; [
			grimblast
		];

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

				# https:#wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
				"col.active_border" = "rgba(cc009977) rgba(ee00ee33) 45deg";
				"col.inactive_border" = "rgba(00aaaa49)";

				# Set to true enable resizing windows by clicking and dragging on borders and gaps
				resize_on_border = false;

				# Please see https:#wiki.hyprland.org/Configuring/Tearing/ before you turn this on
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

				# https:#wiki.hyprland.org/Configuring/Variables/#blur
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
			bind = let 
				grmblstfy = "grimblast --notify --freeze";
			in [
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
				
				"$mod, f10, exec, ${grmblstfy} copy screen"
				"$mod, f11, exec, ${grmblstfy} copy output"
				"$mod, f12, exec, ${grmblstfy} copy area"
				"$mod SHIFT, f10, exec, ${grmblstfy} copysave screen"
				"$mod SHIFT, f11, exec, ${grmblstfy} copysave output"
				"$mod SHIFT, f12, exec, ${grmblstfy} copysave area"
				"$mod ALT, f10, exec, ${grmblstfy} edit screen"
				"$mod ALT, f11, exec, ${grmblstfy} edit output"
				"$mod ALT, f12, exec, ${grmblstfy} edit area"

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
				)10)
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
				first_launch_animation = false;

				# Default animations, see https:#wiki.hyprland.org/Configuring/Animations/ for more

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
		programs.waybar.settings = {
			mainBar = {
				layer = "top";
				position = "top";
				mode = "dock";
				reload_style_on_change = true;
				gtk-layer-shell = true;

				# <<--< Positions >-->>

				modules-left = [
					# "custom/left5"
					"custom/distro"        # distro icon
					"custom/right2"

					"custom/paddw"
					"hyprland/window"       # window title
				];
				
				fixed-center = true;

				modules-center = [
					# "custom/paddc"
					"custom/left2"
					"custom/cpuinfo"       # temperature

					"custom/left3"
					"memory"               # memory

					"custom/left4"
					"cpu"                  # cpu
					"custom/leftin1"

					"custom/left1"
					"hyprland/workspaces"  # workspaces
					"custom/right1"

					"custom/rightin1"
					"idle_inhibitor"       # idle inhibitor
					"clock#time"           # time
					"custom/right3"

					"clock#date"           # date
					"custom/right4"

					"custom/wifi"          # wi-fi
					"bluetooth"            # bluetooth
					# "custom/update"        # system update
					"custom/right5"
				];

				modules-right = [
					"mpris"                # media info

					"custom/left6"
					"pulseaudio"           # output device

					"custom/left7"
					"backlight"            # brightness

					"custom/left8"
					"battery"              # battery

					"custom/leftin2"
					"custom/power"          # power button
				];

				# <<--< Modules >-->>

				"custom/ws" = {
					exec = "~/.config/waybar/scripts/current-theme.sh";
					return-type = "json";
					format = " 󰍜 ";
					on-click = "~/.config/waybar/scripts/theme-switcher.sh";
					min-length = 3;
					max-length = 3;
				};

				"hyprland/workspaces" = {
					on-scroll-up = "hyprctl dispatch workspace -1";
					on-scroll-down = "hyprctl dispatch workspace +1";
					persistent-workspaces = {
					};
				};

				"hyprland/window" = {
					format = "{}";
					min-length = 5;

					rewrite = {
						# Desktop
						""= 
							"<span foreground='#8aadf4'> </span> Hyprland";

						# Terminal
						"~" = "  Terminal";
						zsh = "  Terminal";
						kitty = "  Terminal";

						# Browser

						"(.*)Mozilla Firefox" = 
							"<span foreground='#ed8796'>󰈹 </span> Firefox";
						"(.*) — Mozilla Firefox" = 
							"<span foreground='#ed8796'>󰈹 </span> $1";

						"(.*)Zen Browser" = 
							"<span foreground='#f5a97f'>󰺕 </span> Zen Browser";
						"(.*) — Zen Browser" = 
							"<span foreground='#f5a97f'>󰺕 </span> $1";

						# Development

						"(.*) - Visual Studio Code" = 
							"<span foreground='#8aadf4'>󰨞 </span> $1";
						"(.*)Visual Studio Code" = 
							"<span foreground='#8aadf4'>󰨞 </span> Visual Studio Code";

						nvim = 
							"<span foreground='#a6da95'> </span> Neovim";
						"nvim (.*)" = 
							"<span foreground='#a6da95'> </span> $1";

						vim = 
							"<span foreground='#a6da95'> </span> Vim";
						"vim (.*)" = 
							"<span foreground='#a6da95'> </span> $1";

						# Media

						"(.*)Spotify" = 
							"<span foreground='#a6da95'> </span> Spotify";
						"(.*)Spotify Premium" = 
							"<span foreground='#a6da95'> </span> Spotify Premium";

						"OBS(.*)" = 
							"<span foreground='#a5adcb'> </span> OBS Studio";

						"VLC media player" = 
							"<span foreground='#f5a97f'>󰕼 </span> VLC Media Player";
						"(.*) - VLC media player" = 
							"<span foreground='#f5a97f'>󰕼 </span> $1";

						"(.*) - mpv" = 
							"<span foreground='#c6a0f6'> </span> $1";

						qView = "  qView";

						"(.*).jpg" = "  $1.jpg";
						"(.*).png" = "  $1.png";
						"(.*).svg" = "  $1.svg";

						# Social

						vesktop = 
							"<span foreground='#8aadf4'> </span> Discord";

						"• Discord(.*)" = "Discord$1";
						"(.*)Discord(.*)" = 
							"<span foreground='#8aadf4'> </span> $1Discord$2";

						# Documents

						"ONLYOFFICE Desktop Editors" = 
							"<span foreground='#ed8796'> </span> OnlyOffice Desktop";

						"(.*).docx" = 
							"<span foreground='#8aadf4'> </span> $1.docx";
						"(.*).xlsx" = 
							"<span foreground='#a6da95'> </span> $1.xlsx";
						"(.*).pptx" = 
							"<span foreground='#f5a97f'> </span> $1.pptx";
						"(.*).pdf" = 
							"<span foreground='#ed8796'> </span> $1.pdf";

						# System
						Authenticate = "  Authenticate";
					};
				};

				"custom/cpuinfo" = {
					exec = "~/.config/waybar/scripts/cpu-temp.sh";
					return-type = "json";
					format = "{}";
					interval = 5;
					min-length = 8;
					max-length = 8;
				};

				memory = {
					states = {
						warning = 75;
						critical = 90;
					};

					format = "󰘚 {percentage}%";
					format-critical = "󰀦 {percentage}%";
					tooltip-format = "Memory Used: {used:0.1f} GB / {total:0.1f} GB";
					interval = 5;
					min-length = 7;
					max-length = 7;
				};

				cpu = {
					format = "󰻠 {usage}%";
					tooltip = false;
					interval = 5;
					min-length = 6;
					max-length = 6;
				};

				"custom/distro" = {
					format = "󱄅 ";
					tooltip = false;
				};

				idle_inhibitor = {
					format = "{icon}";

					format-icons = {
						activated = "󱑎 ";
						deactivated = "󱑂 ";
					};

					tooltip-format-activated = "Presentation Mode";
					tooltip-format-deactivated = "Idle Mode";
					start-activated = false;
				};

				"clock#time" = {
					format = "{:%H:%M}";
					tooltip-format = "Standard Time: {:%I:%M %p}";
					min-length = 6;
					max-length = 6;
				};

				"clock#date" = {
					format = "󰨳 {:%m-%d}";
					tooltip-format = "<tt>{calendar}</tt>";

					calendar = {
						mode = "month";
						mode-mon-col = 6;
						on-click-right = "mode";

						format = {
							months = 
								"<span color='#b7bdf8'><b>{}</b></span>";
							weekdays = 
								"<span color='#a5adcb' font='7'>{}</span>";
							today = 
								"<span color='#ed8796'><b>{}</b></span>";
						};
					};

					actions = {
						on-click = "mode";
						on-click-right = "mode";
					};

					min-length = 8;
					max-length = 8;
				};

				"custom/wifi" = {
					exec = "~/.config/waybar/scripts/wifi-status.sh";
					return-type = "json";
					format = "{}";
					on-click = "~/.config/waybar/scripts/wifi-menu.sh";
					on-click-right = "kitty --title '󰤨  Network Manager TUI' bash -c nmtui";
					interval = 1;
					min-length = 1;
					max-length = 1;
				};

				bluetooth = {
					format = "󰂰";
					format-disabled = "󰂲";
					format-connected = "󰂱";
					format-connected-battery = "󰂱";

					tooltip-format = 
						"{num_connections} connected";
					tooltip-format-disabled = 
						"Bluetooth Disabled";
					tooltip-format-connected = 
						"{num_connections} connected\n{device_enumerate}";
					tooltip-format-enumerate-connected = 
						"{device_alias}";
					tooltip-format-enumerate-connected-battery = 
						"{device_alias}: 󰥉 {device_battery_percentage}%";

					on-click = "~/.config/waybar/scripts/bluetooth-menu.sh";
					on-click-right = "kitty --title '󰂯  Bluetooth TUI' bash -c bluetui";
					interval = 1;
					min-length = 1;
					max-length = 1;
				};

				"custom/update" = {
					exec = "~/.config/waybar/scripts/system-update.sh";
					return-type = "json";
					format = "{}";
					on-click = "hyprctl dispatch exec '~/.config/waybar/scripts/system-update.sh up'";
					interval = 30;
					min-length = 1;
					max-length = 1;
				};

				mpris = {
					format = "{player_icon} {title} - {artist}";
					format-paused = "{status_icon} {title} - {artist}";

					player-icons = {
						default = "󰝚 ";
						spotify = "<span foreground='#a6da95'>󰓇 </span>";
						firefox = "<span foreground='#ed8796'>󰗃 </span>";
					};
					status-icons = {
						paused = "<span color='#b7bdf8'>\u200A\u200A󰏤\u2009\u2009</span>";
					};

					tooltip-format = "Playing: {title} - {artist}";
					tooltip-format-paused = "Paused: {title} - {artist}";
					min-length = 5;
					max-length = 35;
				};

				pulseaudio = {
					format = "{icon} {volume}%";
					format-muted = "󰝟 {volume}%";

					format-icons = {
						default = ["󰕿" "󰖀" "󰕾"];
						headphone = "󰋋";
						headset = "󰋋";
					};

					tooltip-format = "Device: {desc}";
					on-click = "~/.config/waybar/scripts/volume-control.sh -o m";
					on-scroll-up = "~/.config/waybar/scripts/volume-control.sh -o i";
					on-scroll-down = "~/.config/waybar/scripts/volume-control.sh -o d";
					min-length = 6;
					max-length = 6;
				};

				backlight = {
					format = "{icon} {percent}%";
					format-icons = ["" "" "" "" "" "" "" "" ""];
					tooltip = false;
					on-scroll-up = "~/.config/waybar/scripts/brightness-control.sh -o i";
					on-scroll-down = "~/.config/waybar/scripts/brightness-control.sh -o d";
					min-length = 6;
					max-length = 6;
				};

				battery = {
					states = {
						warning = 20;
						critical = 10;
					};
					format-time = "{H}:{M:02d}";

					format = "{icon} {capacity}%: {time} ({power:02.1f}W)";
					format-icons = ["󰂎" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
					format-charging = " {capacity}%: {time}";

					tooltip-format = "Discharging: {time}";
					tooltip-format-charging = "Charging: {time}";
					interval = 1;
					min-length = 6;
					max-length = 50;
				};

				"custom/power" = {
					format = " ";
					tooltip-format = "Power Menu";
					on-click = "~/.config/waybar/scripts/power-menu.sh";
				};

				# <<--< Padding >-->>

				"custom/paddw" = {
					format = " ";
					tooltip = false;
				};

				"custom/paddc" = {
					format = " ";
					tooltip = false;
				};

				# Left Arrows

				"custom/left1" = {
					format = "";
					tooltip = false;
				};
				"custom/left2" = {
					format = "";
					tooltip = false;
				};
				"custom/left3" = {
					format = "";
					tooltip = false;
				};
				"custom/left4" = {
					format = "";
					tooltip = false;
				};
				"custom/left5" = {
					format = "";
					tooltip = false;
				};
				"custom/left6" = {
					format = "";
					tooltip = false;
				};
				"custom/left7" = {
					format = "";
					tooltip = false;
				};
				"custom/left8" = {
					format = "";
					tooltip = false;
				};

				# Right Arrows

				"custom/right1" = {
					format = "";
					tooltip = false;
				};
				"custom/right2" = {
					format = "";
					tooltip = false;
				};
				"custom/right3" = {
					format = "";
					tooltip = false;
				};
				"custom/right4" = {
					format = "";
					tooltip = false;
				};
				"custom/right5" = {
					format = "";
					tooltip = false;
				};

				# Left Inverse

				"custom/leftin1" = {
					format = "";
					tooltip = false;
				};
				"custom/leftin2" = {
					format = "";
					tooltip = false;
				};

				# Right Inverse

				"custom/rightin1" = {
					format = "";
					tooltip = false;
				};
			};
		};
	};
}
{ config, pkgs, inputs, ... }:
{
	imports = [
		inputs.home-manager.nixosModules.default
		./home-hyprland.nix
	];

	home-manager.backupFileExtension = "backup";

	home-manager.users.rickyrnt = rec {
		/* The home.stateVersion option does not have a default and must be set */
		home.stateVersion = "24.11";
		/* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
		home.username = "rickyrnt";
		home.homeDirectory = "/home/rickyrnt";
		dconf.settings = {
			"org/gnome/desktop/interface" = {
				color-scheme = "prefer-dark";
			};
		};
		
		home.packages = with pkgs; [
			python3
			python311Packages.pip
			pipx
			vscode
			obsidian
			git
			texliveBasic
			libgcc
			libreoffice-qt6-fresh

			mtpaint
			vesktop
			steam
			bottles
			# wine
			wine64
			jack2
			wineasio
			cider
			kdenlive
			zoom-us
			calibre
			graphviz

			cmatrix
		];

		xdg.enable = true;

		xdg.userDirs = {
			enable = true;
			createDirectories = true;
			pictures = "${config.users.users.rickyrnt.home}/Pictures";
		};

		home.sessionVariables = {
			XDG_SCREENSHOTS_DIR = "${xdg.userDirs.pictures}/Screenshots";
		};
		
		xdg.configFile = {
			"vesktop/themes/theme.css".source = ./dotfiles/discordtransparent.css;
		};

		# Wayland, X, etc. support for session vars
		systemd.user.sessionVariables = config.home-manager.users.rickyrnt.home.sessionVariables;
		
		services.dunst.enable = true;
		services.dunst.settings = {
			global = {
				follow = "keyboard";
				frame_width = 1;
				font = "Monospace 9";
				corner_radius = 4;
				corners = "top_left, bottom_right";
				mouse_right_click = "do_action, close_current";
				mouse_middle_click = "close_all";
				
				background = "#20001088";
				foreground = "#FFF";
				frame_color = "#CC0099AA";
				highlight = "#A40A60";
			};
			urgency_critical.frame_color = "#00AAAAAA";
			urgency_low.frame_color = "#20001088";
		};

		programs.git = {
			enable = true;
			userEmail = "rick.yarnot.255@gmail.com";
			userName = "rickyrnt";
		};
		
		programs.rofi = {
			enable = true;
			location = "top";
			package = pkgs.rofi-wayland;
			terminal = "${pkgs.kitty}/bin/kitty";
			theme = "purple";
		};

		programs.kitty.enable = true;
		programs.kitty.settings = {
			confirm_os_window_close = 0;
			background_opacity = 0.2;
			background_blur = 0;
			background = "#100008";
		};
		
		programs.zsh = {
			enable = true;
			enableCompletion = true;
			autosuggestion.enable = true;
			syntaxHighlighting.enable = true;

			shellAliases = {
				nixedit = "nvim /home/rickyrnt/nixos/configuration.nix";
				nixmake = "sudo nixos-rebuild switch --flake /home/rickyrnt/nixos#M04RYS8";
				nvidiacheck = "cat /sys/class/drm/card2/device/power_state";
			};
			
			initExtra = ''
				neofetch | lolcat
				eval "$(thefuck --alias)"
				eval "$(ssh-agent -s)"
			'';
			
			history.size = 10000;

			oh-my-zsh = {
				enable = true;
				plugins = [ ];
				theme = "agnoster";
			};
		};
		
		programs.neovim = {
			enable = true;
			viAlias = true;
			vimAlias = true;
			defaultEditor = true;
			
			plugins = with pkgs.vimPlugins; [
				transparent-nvim
				vimtex
				vim-numbertoggle
			];
			
			extraConfig = ''
				set number
				autocmd Filetype nix setlocal ts=2 sw=2 expandtab
			'';
			
			extraLuaConfig = ''
				vim.opt.tabstop = 4
				vim.opt.shiftwidth = 4
			'';
		};
		
		systemd.user.services.rclone-mount = let
			homedir = config.users.users.rickyrnt.home;
		in {
			Unit = {
				# Mounts onedrive folders to the filesystem. Requires rclone to be set up manually.
				Description = "mount onedrive";
				After = [ "network-online.target" ];
			};
			Service = {
				Type = "notify";
				ExecStartPre = "/run/current-system/sw/bin/mkdir -p ${homedir}/OneDrive";
				ExecStart = "${pkgs.rclone}/bin/rclone --config=${homedir}/.config/rclone/rclone.conf --vfs-cache-mode writes --ignore-checksum mount \"onedrive:\" \"OneDrive\"";
				ExecStop="${pkgs.fuse}/bin/fusermount -u ${homedir}/OneDrive/%i";
				Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
			};
			Install.WantedBy = [ "default.target" ];
		};
	};
}

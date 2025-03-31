{ config, pkgs, ... }:
let
	home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
in
{
	imports = [
		(import "${home-manager}/nixos")
		./home-hyprland.nix
	];

	home-manager.backupFileExtension = "backup";

	home-manager.users.rickyrnt = {
		/* The home.stateVersion option does not have a default and must be set */
		home.stateVersion = "18.09";
		/* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
		home.username = "rickyrnt";
		home.homeDirectory = "/home/rickyrnt";
		dconf.settings = {
			"org/gnome/desktop/interface" = {
				color-scheme = "prefer-dark";
			};
		};

		xdg.enable = true;

		# Wayland, X, etc. support for session vars
		systemd.user.sessionVariables = config.home-manager.users.rickyrnt.home.sessionVariables;

		programs.git = {
			enable = true;
			userEmail = "rick.yarnot.255@gmail.com";
			userName = "rickyrnt";
		};

		programs.kitty.enable = true;
		programs.kitty.settings = {
			confirm_os_window_close = 0;
			background_opacity = 0.2;
			background_blur = 0;
		};
		
		programs.zsh = {
			enable = true;
			enableCompletion = true;
			autosuggestion.enable = true;
			syntaxHighlighting.enable = true;

			shellAliases = {
				sudo = "sudo ";
				vim = "nvim ";
				nixedit = "nvim /home/rickyrnt/nixos/configuration.nix";
				nixmake = "sudo nixos-rebuild switch -I nixos-config=/home/rickyrnt/nixos/configuration.nix";
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
	};
}

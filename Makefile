
rebuild-desktop-pc:
	sudo NIXPKGS_ALLOW_INSECURE=1  nixos-rebuild switch --flake '.#desktop-pc' --impure

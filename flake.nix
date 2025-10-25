{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=release-25.05";
    # home-manager.url = "github:nix-community/home-manager";
    home-manager = { url = "github:nix-community/home-manager/release-25.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations.desktop-pc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
      	./configuration/desktop-pc.nix
	 home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.honey = import ./home/desktop-pc.nix;
            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
          ];
    };


    nixosConfigurations.t14g5 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
      	./configuration/t14g5.nix
	 home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.honey = import ./home/t14g5.nix;
            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
          ];
    };




    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
      	./configuration.nix
	 home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.honey = import ./home.nix;
            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
          ];
    };



    nixosConfigurations.t480skde = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       modules = [ 
          ( import ./configuration/kde.nix { deviceName = "t480s";  })
          home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              # TODO replace ryan with your own username
              home-manager.users.honey = import ./home/kde.nix;
              # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
            }
            ];
    };

  };
}


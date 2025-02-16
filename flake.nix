{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:{
      nixosConfigurations = {
        dan = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./system/configuration.nix

            # Include the home-manager module.
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.dan = import ./users/dan/home.nix;
            }
          ];
        };
      };
    };
}

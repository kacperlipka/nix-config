{
  description = "macOS Nix package management with nix-darwin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }@inputs:
  let
    # User configuration
    username = "kacperlipka";
    email = "kacper.lipka.02@gmail.com";
    kmd_username = "Z6KKI";
    kmd_email = "kki@kmd.dk";
  in
  {
    darwinConfigurations = {
      "kmd_macos" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; username = kmd_username; email = kmd_email; };
        modules = [
          ./hosts/macos
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${kmd_username} = import ./users/mkUser.nix {
                username = kmd_username;
                email = kmd_email;
              };
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };
      "macos" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs username email; };
        modules = [
          ./hosts/macos
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${username} = import ./users/mkUser.nix {
                inherit username email;
              };
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };
    };
  };
}

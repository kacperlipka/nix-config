{
  description = "Portable Nix configuration for macOS and Linux";

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
    # Helper function to create dynamic user configurations
    mkUserConfig = system: home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      extraSpecialArgs = { inherit inputs; };
      modules = [ ./users/kacperlipka.nix ];
    };

    mkDarwinConfig = system: nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/macos
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.kacperlipka = import ./users/kacperlipka.nix;
            extraSpecialArgs = { inherit inputs; };
          };
        }
      ];
    };
  in
  {
    # Portable configurations that work for any user
    darwinConfigurations = {
      "macos" = mkDarwinConfig "aarch64-darwin";
    };

    homeConfigurations = {
      "linux" = mkUserConfig "x86_64-linux";
    };
  };
}

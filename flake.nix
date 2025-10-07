{
  description = "Nix configuration for macOS";

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
            # This will use the dynamic username from the user config
            users = let
              currentUser = builtins.getEnv "USER";
              username = if currentUser != "" then currentUser else "user";
            in {
              ${username} = import ./users/kacperlipka.nix;
            };
            extraSpecialArgs = { inherit inputs; };
          };
        }
      ];
    };
  in
  {
    # Generic configurations that work for any user
    darwinConfigurations = {
      # Generic macOS configuration
      "macos" = mkDarwinConfig "aarch64-darwin";
      # Keep the old name for backward compatibility
      "macbook-kacperlipka" = mkDarwinConfig "aarch64-darwin";
    };

    homeConfigurations = {
      # Generic Linux configuration
      "linux" = mkUserConfig "x86_64-linux";
      # Keep the old name for backward compatibility
      "kacperlipka@ubuntu" = mkUserConfig "x86_64-linux";
    };
  };
}

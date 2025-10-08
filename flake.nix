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
  {
    darwinConfigurations = {
      "macos" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
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
    };

    # Export packages for simple installation with nix-env
    packages = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        # Package sets for direct installation with nix-env
        devcontainer = pkgs.buildEnv {
          name = "devcontainer-packages";
          paths = import ./home/packages/devcontainer.nix { inherit pkgs; };
        };

        base = pkgs.buildEnv {
          name = "base-packages";
          paths = import ./home/packages/base.nix { inherit pkgs; };
        };
      }
    );
  };
}

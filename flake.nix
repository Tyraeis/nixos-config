{
    description = "NixOS Configs";

    inputs = {
        # Nixpkgs
        nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

        # Home manager
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        # nix-ld
        nix-ld.url = "github:Mic92/nix-ld";
        nix-ld.inputs.nixpkgs.follows = "nixpkgs";

        # hack to get the path for NIX_LD
        #ld-so.url = "path:./ld-so.nix";
        #ld-so.flake = false;
    };

    outputs = { nixpkgs, home-manager, nix-ld, ... }@inputs: {
        # NixOS configuration entrypoint
        # Available through 'nixos-rebuild --flake .#your-hostname'
        nixosConfigurations = {
            noahc-nas = nixpkgs.lib.nixosSystem {
                specialArgs = { inherit inputs; }; # Pass flake inputs to our config
                # > Our main nixos configuration file <
                modules = [
                    ./nixos/configuration.nix
                    nix-ld.nixosModules.nix-ld
                ];
            };
        };

        # Standalone home-manager configuration entrypoint
        # Available through 'home-manager --flake .#your-username@your-hostname'
        homeConfigurations = {
            "noahc@noahc-nas" = home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
                extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
                # > Our main home-manager configuration file <
                modules = [ ./home-manager/home.nix ];
            };
        };
    };
}

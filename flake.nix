{

  description = "Minecraft Server Flake";

  inputs = {

    # Package channels
    nixpkgs-stable.url   = "github:nixos/nixpkgs/nixos-25.11"; # [🔄]
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Default package channel
    nixpkgs.follows = "nixpkgs-unstable";

    # Minecraft
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-minecraft,
    ...
  }:
  let
    system = "x86_64-linux"; # [🪧]
  in
  {

    # default
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/default/configuration.nix
        ./hosts/default/minecraft.nix
        inputs.nix-minecraft.nixosModules.minecraft-servers
      ];
    };

    # new
    # nixosConfigurations.new = nixpkgs.lib.nixosSystem {
    #   inherit system;
    #   specialArgs = { inherit inputs; };
    #   modules = [
    #     ./hosts/new/configuration.nix
    #     ./hosts/new/minecraft.nix
    #     inputs.nix-minecraft.nixosModules.minecraft-servers
    #   ];
    # };

  };

}

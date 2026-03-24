{

  description = "Minecraft Server Flake";

  inputs = {

    # Package channels
    nixpkgs-stable.url   = "github:nixos/nixpkgs/nixos-25.11";
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
  }:
  let
    system = "x86_64-linux";
  in
  {

    nixosConfigurations.mini = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs nix-minecraft; };
      modules = [
        ./hosts/mini/configuration.nix
        ./hosts/mini/minecraft.nix
      ];
    };

  };

}

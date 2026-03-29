{ pkgs, inputs, ... }: {

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers = {
      savage = import ../../servers/savage/server.nix { inherit pkgs inputs; };
      # test = import ../../servers/test/server.nix { inherit pkgs inputs; };
    };

  };

}

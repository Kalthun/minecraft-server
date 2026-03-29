# minecraft-server

## Setup

### 1. Add host to flake.nix
You can either use the default host or add a new host
```nix
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
```

### 2. Edit default config
```sh
sudo nano /etc/nixos/configuration.nix
```
```nix
environment.systemPackages = with pkgs; [
  git
];
```
```nix
services.tailscale.enable = true;
```

### 3. Rebuild
```sh
sudo nixos-rebuild switch
```

### 4 Setup Tailscale (while not headless)
```sh
sudo tailscale up
```

### 5. Generate and configure ssh key
```sh
ssh-keygen
```
```sh
cat ~/.ssh/id_ed25519.pub
```

### 6. Clone repo
```sh
cd
git clone git@github.com:Kalthun/minecraft-server.git
```

### 7. Setup host
```sh
cd minecraft-server/hosts
mkdir [hostname]
```
```sh
sudo rm /etc/nixos/configuration.nix
sudo mv /etc/nixos/hardware-configuration.nix ~/minecraft-server/hosts/[hostname]
```
(You can copy an existing configuration)
```sh
cp ~/minecraft-server/hosts/default/configuration.nix ~/minecraft-server/hosts/[hostname]
cp ~/minecraft-server/hosts/default/minecraft.nix ~/minecraft-server/hosts/[hostname]
```
```sh
sudo chown -R $(id -un):users ~/minecraft-server
sudo ln -s ~/minecraft-server/* /etc/nixos/
```

### 8. Git
```sh
git add -A
```

### 9. Rebuild (again) & Reboot
```sh
sudo nixos-rebuild switch --flake ~/minecraft-server/#[hostname]
```
```sh
sudo reboot
```

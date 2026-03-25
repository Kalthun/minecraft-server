# minecraft-server

## Setup

### 0. Add host to flake.nix
```nix
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

    # copy here

};
```

### 1. Edit default config
```sh
sudo nano /etc/nixos/configuration.nix
```
```nix
environment.systemPackages = with pkgs; [
  git
];
```

### 2. Rebuild
```sh
sudo nixos-rebuild switch
```

### 3. Generate and configure ssh key
```sh
ssh-keygen
```
```sh
cat ~/.ssh/id_ed25519.pub
```

### 4. Clone repo
```sh
cd
git clone git@github.com:Kalthun/minecraft-server.git
```

### 5. Setup system
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
cp ~/minecraft-server/hosts/mini/configuration.nix ~/minecraft-server/hosts/[hostname]
```
```sh
sudo chown -R $(id -un):users ~/minecraft-server
sudo ln -s ~/minecraft-server/* /etc/nixos/
```

### 6. Git
```sh
git add -A
```

### 7. Rebuild (again) & Reboot
```sh
sudo nixos-rebuild switch --flake ~/minecraft-server/#[hostname]
```
```sh
sudo reboot
```

### 8. Tailscale
```sh
sudo tailscale up
```
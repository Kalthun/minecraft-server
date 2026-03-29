{ pkgs, ... }: {

  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "default"; # [🪧]
  networking.networkmanager.enable = true;

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  # [🚨] "user" should be set to same value used when initially installing nixos
  users.users.user = { # [🪧]
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN/9oYfDscH4zi7wjA7MXLJv/yLemtpli5V2HbnXcOrD kalthun@dirt" # Office Desktop
    ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  programs.git = {
    enable = true;
    config = {
      user.name = "kalthun"; # [🪧]
      user.email = "jameskwmail@gmail.com"; # [🪧]
      init.defaultBranch = "main";
    };
  };

  environment.systemPackages = with pkgs; [

    # General
    bat
    yazi
    evil-helix
    lazygit
    zellij

    # Minecraft
    just
    mcrcon

  ];

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Tailscale
  services.tailscale.enable = true;

  # Firewall
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = [ 25565 ];
    allowedUDPPorts = [ 25565 ];
    # checkReversePath = "loose"; # [⚠️] test later
  };

  # [ℹ️] CAPSLOCK -> ESC
  services.kanata = {
    enable = true;
    keyboards = {
      "key".config = ''
        (defsrc
          grv  1 2 3 4 5 6 7 8 9 0 -  =   bspc
          tab  q w e r t y u i o p [  ]   \
          caps a s d f g h j k l ; '  ret
          lsft z x c v b n m , . /   rsft
          lctl lmet lalt      spc     ralt rmet rctl
        )

        (deflayer alter
          grv  1 2 3 4 5 6 7 8 9 0 -  =   bspc
          tab  q w e r t y u i o p [  ]   \
          esc  a s d f g h j k l ; '  ret
          lsft z x c v b n m , . /   rsft
          lctl lmet lalt      spc     ralt rmet rctl
        )
      '';
    };
  };

  system.stateVersion = "25.11";
}

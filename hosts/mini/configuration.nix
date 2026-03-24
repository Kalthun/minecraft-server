{ pkgs, ... }: {

  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mini";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  users.users.kalthun = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      # change later
    ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    bat
    yazi
    evil-helix
    lazygit
  ];

  programs.git = {
    enable = true;
    config = {
      user.name = "kalthun";
      user.email = "jameskwmail@gmail.com";
      init.defaultBranch = "main";
    };
  };

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

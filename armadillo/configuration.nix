{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [
      "amdgpu"
      #"v4l2loopback"
    ];
    #extraModulePackages = with config.boot.kernelPackages; [
      #v4l2loopback.out
    #];
    #extraModprobeConfig = ''
    #  options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
    #'';
  };

  networking = {
    hostName = "armadillo";
    networkmanager.enable = true;
  };

  time = {
    timeZone = "America/Chicago";
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  services = {
    displayManager.defaultSession = "plasma";
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
    desktopManager.plasma6.enable = true;

    xserver = {
      enable = true;


      xkb = {
        layout = "us";
        variant = "";
      };

      videoDrivers = [
        "amdgpu"
      ];

      excludePackages = with pkgs; [
        xterm
      ];
    };

    fwupd.enable = true;
    printing.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    #flatpak.enable = true;
  };

  hardware = {
    pulseaudio = {
      enable = false;
    };

    graphics = {
        enable = true;
        enable32Bit = true;

        extraPackages = with pkgs; [
          amdvlk
          libva
        ];

        extraPackages32 = with pkgs; [
          driversi686Linux.amdvlk
        ];
    };

    amdgpu.amdvlk = {
        enable = true;
        support32Bit.enable = true;
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Expiremental = true;
    };
  };

  security.rtkit.enable = true;

  users.users.ngupton = {
    isNormalUser = true;
    description = "Nick";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    dconf.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      vim
      wget
      vscode
      flatpak-builder
      tailscale
      pcloud
      discord-canary
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}

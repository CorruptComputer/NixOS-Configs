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

    initrd = {
      luks.devices."luks-afbdebe4-1342-4dca-b0b3-28e9ee8da74d".device = "/dev/disk/by-uuid/afbdebe4-1342-4dca-b0b3-28e9ee8da74d";
    };

    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [
      "amdgpu"
      "v4l2loopback"
    ];
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback.out
    ];
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
    '';
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
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      layout = "us";
      xkbVariant = "";

      videoDrivers = [
        "amdgpu"
      ];

      excludePackages = with pkgs; [
        xterm
      ];
    };

    gnome = {
      games.enable = true;
      core-developer-tools.enable = true;
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

    udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
    ];

    flatpak.enable = true;
  };

  sound.enable = true;

  hardware = {
    pulseaudio = {
      enable = false;
    };

    opengl = {
      driSupport = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [
        amdvlk
        libva
        rocm-opencl-icd
      ];

      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    };
    
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Expiremental = true;
    };
  };

  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ngupton = {
    isNormalUser = true;
    description = "Nickolas Gupton";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      # Should be installed via flatpak, things like:
      # firefox
      # steam
      # discord
      # gitkraken
      # etc.
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      linuxKernel.packages.linux_latest_libre.v4l2loopback
      vim
      wget
      vscode
      gnomeExtensions.appindicator
      gnome.gnome-software
      gnome3.gnome-tweaks
      flatpak-builder
      tailscale
      pcloud
    ];
  };

  system = {
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "23.11"; # Did you read the comment?

    autoUpgrade = {
      enable = true;
      allowReboot = false;
    };
  };
}

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

    initrd.kernelModules = [
      "amdgpu"
    ];

    kernelPackages = pkgs.linuxPackages_latest;
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
    pulseaudio.enable = false;
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
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
    stateVersion = "23.05"; # Did you read the comment?

    autoUpgrade = {
      enable = true;
      allowReboot = false;
    };
  };
}

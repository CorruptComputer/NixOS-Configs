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
    displayManager = {
      defaultSession = "plasma";
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };

    desktopManager.plasma6.enable = true;

    fwupd.enable = true;
    printing.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
    };

    flatpak.enable = true;
  };

  hardware = {
    graphics = {
        enable = true;
        enable32Bit = true;
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
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
  # $ nix search [name]
  environment = {
    sessionVariables = {
      DOTNET_ROOT = "${pkgs.dotnet-sdk_9}/share/dotnet/";
    };

    systemPackages = with pkgs; [
      audacity
      azuredatastudio
      bitwarden-desktop
      bottles
      brave
      discord-canary
      dotnet-aspnetcore_9
      dotnet-runtime_9
      dotnet-sdk_9
      dotnetPackages.Nuget
      element-desktop
      firefox
      flatpak-builder
      gimp
      git
      heroic
      kdePackages.kdenlive
      lutris
      obs-studio
      obs-studio-plugins.droidcam-obs
      obs-studio-plugins.obs-pipewire-audio-capture
      obs-studio-plugins.obs-vaapi
      obs-studio-plugins.obs-vkcapture
      obsidian
      onlyoffice-desktopeditors
      organicmaps
      osu-lazer-bin
      pcloud
      protontricks
      protonup-qt
      qgis
      qjackctl
      rpi-imager
      slack
      spotify
      sublime-merge
      tailscale
      texmaker
      vim
      vlc
      # This is dumb
      (vscode-with-extensions.override {
        vscodeExtensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          # To get sha256: nix-prefetch-url https://marketplace.visualstudio.com/_apis/public/gallery/publishers/[publisher]/vsextensions/[name]/[version]/vspackage
          {
            name = "csharp";
            publisher = "ms-dotnettools";
            version = "2.72.27";
            sha256 = "0f8mh640p628nya3iw419xvvwc64l32mnxjrga1kdx9dql2ffm3f";
          }
          {
            name = "vscode-dotnet-runtime";
            publisher = "ms-dotnettools";
            version = "2.3.2";
            sha256 = "0wyh977ml2ib0bpinnm47x1z7jncjw34nmsnws2zzxkds20fygqd";
          }
          {
            name = "csdevkit";
            publisher = "ms-dotnettools";
            version = "1.18.23";
            sha256 = "0iqvhv5m44kmwc1rvirdsdyriabb0069768hbfdvrmmwp0ihqd40";
          }
          {
            name = "vscodeintellicode-csharp";
            publisher = "ms-dotnettools";
            version = "2.2.3";
            sha256 = "1bpkivjnv3xf7r5vcvypdkpnkgn6d8j3a34n5cda8508j0miwwpi";
          }
          {
            name = "vscode-entity-framework";
            publisher = "richardwillis";
            version = "0.0.20";
            sha256 = "0karaxnaalhr08n7dyc89wr5i3y9jxa5nfiyqcxdg4ws0p3zcsbk";
          }
          {
            name = "vscode-avalonia";
            publisher = "avaloniateam";
            version = "0.0.32";
            sha256 = "1vrsnq7v0p508c077g62yy2h9l8dqgad5929nnyqiys3bcx5ksnq";
          }
        ];
      })
      wget
    ];
  };

  nixpkgs.config.allowUnfree = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}

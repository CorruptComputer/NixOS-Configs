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
    appimage.enable = true;
    dconf.enable = true;
    firefox.enable = true;
    git.enable = true;
    kdeconnect.enable = true;
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = with pkgs.obs-studio-plugins; [
        droidcam-obs
        obs-pipewire-audio-capture
        obs-vaapi
        obs-vkcapture
      ];
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    tmux.enable = true;
    vim.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search [name]
  environment =
    let
      dotnet-sdk = with pkgs.dotnetCorePackages; combinePackages [ sdk_8_0 sdk_9_0 sdk_10_0 ];
      dotnetRoot = "${dotnet-sdk}/share/dotnet";
    in {
      etc = {
        "dotnet/install_location".text = dotnetRoot;
      };

      systemPackages = with pkgs; [
        audacity
        azuredatastudio
        bitwarden-desktop
        bottles
        brave
        discord-canary
        dotnet-ef
        dotnet-sdk
        element-desktop
        flatpak-builder
        gimp
        heroic
        kdePackages.kdenlive
        lutris
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
        vlc
        (vscode-with-extensions.override {

          vscodeExtensions = with vscode-extensions; [
            ms-dotnettools.csharp
            ms-dotnettools.vscode-dotnet-runtime
            ms-dotnettools.csdevkit
            ms-dotnettools.vscodeintellicode-csharp
          ] ++ vscode-utils.extensionsFromVscodeMarketplace [
            # To get sha256: nix-prefetch-url https://marketplace.visualstudio.com/_apis/public/gallery/publishers/[publisher]/vsextensions/[name]/[version]/vspackage
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
  nix = {
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };



  system = {
    autoUpgrade = {
      enable = true;
      allowReboot = false;
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "24.11"; # Did you read the comment?
  };
}

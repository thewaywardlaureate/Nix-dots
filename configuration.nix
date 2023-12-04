# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{inputs,  config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nbfc.nix
    ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [ "intel_iommu=on" "iommu=pt" "acpi_backlight=native" ];
  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-9f68e4e5-e4e6-4804-bf88-17d74591f667".device = "/dev/disk/by-uuid/9f68e4e5-e4e6-4804-bf88-17d74591f667";
  boot.initrd.luks.devices."luks-9f68e4e5-e4e6-4804-bf88-17d74591f667".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.viswas = {
    isNormalUser = true;
    description = "viswas";
    extraGroups = [ "video" "networkmanager" "wheel" "libvirtd" "kvm" "input" "adbusers" ];
   packages = with pkgs; [];
  };

# Linux Kernel

boot.kernelPackages = pkgs.linuxPackages_latest;

# PIPEWIRE

security.rtkit.enable = true;
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  # If you want to use JACK applications, uncomment this
  jack.enable = true;
};

# POLKIT

security.polkit.enable = true;

# DCONF

programs.dconf.enable = true;

# LIBVIRTD

virtualisation.libvirtd.enable = true;

# BLUETOOTH

 hardware.bluetooth.enable = true;
 services.blueman.enable = true;

  # Make sure opengl is enabled
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
 extraPackages = with pkgs; [
      intel-media-driver 
      mesa
      vulkan-loader
      vaapiIntel         
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # NVIDIA drivers are unfree.
  nixpkgs.config.allowUnfreePredicate = pkg: ["nvidia-x11"];
  services.xserver.videoDrivers = ["nvidia"];


# NVIDIA-OFFLOAD

    hardware.nvidia.prime = {
  #  sync.enable = true;
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

#NVIDIA

  hardware.nvidia = {

    modesetting.enable = true;
    #open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
 };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
  };

# ANDROID
  programs.adb.enable = true;
  services.gvfs.enable = true;

# Hyrpland
  programs.hyprland = {
    enable = true;
     xwayland = {
    enable = true;
  };
};

nixpkgs.config.permittedInsecurePackages = [
                "electron-24.8.6"
              ];
programs.wshowkeys.enable = true;

programs.hyprland.enableNvidiaPatches = true;


  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   vim 
   ventoy
   SDL2
   cage
   dunst
   ripgrep-all
   gruvbox-dark-gtk
   gruvbox-dark-icons-gtk
   pixelorama
   blender-hip
   nwg-look
   wget
   R
   rstudio
   tmux
   waybar
   kitty
   wezterm
   inteltool
   microcodeIntel 
   firefox
   w3m
   jetbrains-mono
   font-awesome_5
   android-tools
   adbfs-rootless
   xorg.xhost 
   ntfs3g
   usbutils
   seatd
   pciutils
   nerdfonts
   zip
   unzip
   mangal
   exfat
   wshowkeys
   exif
   exifprobe
   exiftool
   mediainfo
   ttyper
   kbd
   timer
   brightnessctl 
   yt-dlp
   liberation_ttf
   neovim
   egl-wayland
   gifsicle
   ppsspp-sdl-wayland
   pywal
   mutt
   sxiv
   swww
   vulkan-headers
   vulkan-utility-libraries
   glew
   #vulkan-extension-layer
   vkd3d-proton
   wayland-utils
   cliphist
   wlroots
   wlr-protocols
   bluez
   bluez-tools
   tlp
   alacritty
   glfw-wayland
   git
   hyprland-protocols
   xdg-desktop-portal-gtk
   curl
   hugo
   nvidia-vaapi-driver
   scrcpy
   distrobox
   zsh
   virt-manager
   virt-viewer
   spice-gtk
   spice
   spice-protocol
   win-virtio
   win-spice
   qemu_full
   libvirt
   podman
   runc
   containerd
   tailscale
  # spotdl
   buildah
   gparted
   gnumake
   glib
   glibc
   gccgo13
   coreutils-full
   netavark
   rofi
   htop
   wbg
   lf
   nodejs 
   nodePackages_latest.npm
   pandoc
   zathura
   vimPlugins.nvim-treesitter-textobjects
   vimPlugins.nvim-dap
   ripgrep
   jdk
   wine
   rawtherapee
   libreoffice
   pipx
   python313
   librewolf
   pulsemixer
   pulseaudio
   lua
   cpufrequtils
   dmg2img
   libguestfs
   texlive.combined.scheme-full
   texlive.combined.scheme-tetex
   xorg.xf86videoqxl
   lm_sensors
   fan2go
   riseup-vpn
   mpv
   vulkan-tools
   gimp
   ardour
   logseq
   tetex
   lutris
	(lutris.override { extraPkgs = pkgs: [
wineWowPackages.unstable
winetricks
];
})
   mangohud
   slurp
   lxappearance
   grim
   imv
   xdg-utils
   polkit_gnome
   xdg-desktop-portal-wlr
   wlr-randr
   eww-wayland
   wlrctl
   wlsunset 
   xdg-user-dirs
   ffmpeg
   xdg-dbus-proxy
   qbittorrent
   aria2
   musikcube
  ];

fonts.fontDir.enable = true;

fonts.packages = with pkgs; [
   jetbrains-mono
   font-awesome_5
   nerdfonts
   liberation_ttf
   roboto
];

# GAMING

programs.steam= {
	enable = true;
};

#FLATPAK (smh!) 

 services.flatpak.enable = true;

  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];



  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

# systemd services

systemd = {
  user.services.gnome_polkit = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "multi-user.target" ];
    wants = [ "multi-user.target" ];
    after = [ "mulit-user.target" ];
    serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
  };
};


 

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "performance";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "performance";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        STOP_CHARGE_THRESH_BAT0= 80;
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 100;
      };
};

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}



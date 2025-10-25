# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:

let 
    secured = import "${builtins.getEnv "PWD"}/secured.nix";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  services.resolved = {
    enable = true;
    # dnssec = "true";
    # domains = [ "~." ];
    # fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    # dnsovertls = "true";
  };


#  networking.networkmanager.dns = "none";
#  networking.nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" ];
#    networking.firewall = {
#      allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
#    };
#  
#    networking.wg-quick.interfaces = {
#      wg0 = secured.wg_quick;
#  
#    };
  # bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [ "network.target" "sound.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };

  # Set your time zone.
  time.timeZone = "Asia/Vladivostok";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  # Enable the X11 windowing system.
# services.displayManager = {
#    enable = true;
#    execCmd = "${pkgs.lemurs}/bin/lemurs --no-log";
#   defaultSession = "none+xmonad";
# };


services.xserver = {
  enable = true;
  # videoDrivers = [ "intel" ];
  desktopManager.xterm.enable = false;
   displayManager.lightdm = {
    enable = true;
    greeter.enable = true;
    greeters.mini.user = "honey";
    background = "/home/honey/Pictures/wallhaven-x1ppyv.jpg";
    autoLogin = { 
        enable = true; 
        user = "honey"; 
      };

  };
  dpi = 96;
  windowManager.xmonad = {
     enable = true;
     enableContribAndExtras = true;
     extraPackages = hpkgs: [
       hpkgs.xmonad-contrib
       hpkgs.dbus
       hpkgs.monad-logger
      # hpkgs.xmonad-screenshot
     ];
     config = builtins.readFile /home/honey/nix-config/xmonad/xmonad.hs;
  };
};


location.provider = "geoclue2";

services.redshift = {
    enable = true;
    brightness = {
      # Note the string values below.
      day = "1";
      night = "1";
    };
    temperature = {
      day = 5500;
      night = 3700;
    };
};



  # Enable the KDE Plasma Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us,ru";
    xkbVariant = "";
    xkbOptions = "grp:alt_shift_toggle";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  #sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.honey = {
    isNormalUser = true;
    description = "honey";
    extraGroups = [ "docker" "networkmanager" "wheel" ];
    packages = with pkgs; [
        lemurs
        deadd-notification-center
#        usnstable.amnezia-vpn
    ];
  };

  users.extraGroups.docker.members = [ "honey" ];
  users.extraGroups.vboxusers.members = [ "honey" ];


#programs.evolution = {
#  enable = true;
#  plugins = [ pkgs.evolution-ews ];
#};

  virtualisation.containers.enable = true;
    virtualisation = {
     virtualbox = {
         host.enable = true;
         host.enableExtensionPack = true;
         guest.enable = true;
         guest.dragAndDrop = true;
     };
};

  # virtualisation.oci-containers.backend = "podman";
  # virtualisation.oci-containers.containers = {
  #   container-name = {
  #     image = "container-image";
  #     autoStart = true;
  #     ports = [ "127.0.0.1:1234:1234" ];
  #   };
  # };

  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    "registry-mirrors" = [ "https://mirror.gcr.io" ];
  };  # Install firefox. programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # xfce.xfce4-xkb-plugin

  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true; programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  system.stateVersion = "23.11"; # Did you read the comment?
  # users.defaultUserShell = pkgs.zsh;
  # users.users.honey.shell = pkgs.zsh;
  # programs.zsh.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  fonts.fonts = with pkgs; [
    comic-relief
    font-awesome_4
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    nerdfonts
];

programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
};


users.defaultUserShell = pkgs.zsh;
programs.zsh.enable = true;

programs.evolution = {
    enable = true;
    plugins = [ pkgs.evolution-ews ];
};

services.devmon.enable = true;
services.gvfs.enable = true; 
services.udisks2.enable = true;

services.flatpak.enable = true;
xdg.portal.enable = true;


# systemd.services.myservice = {
#   enable = true;
#   after = [ "network.target" ];
#   wantedBy = [ "multi-user.target" ];
#   path = [ pkgs.deadd-notification-center pkgs.twmn pkgs.xorg.xhost];
#   environment = {
#     DISPLAY = ":0";
#     XAUTHORITY="/home/honey/.Xauthority";
#     # XAUTHORITY = "/home/honey/.Xauthority";
#     # XDG_SESSION_PATH= "/org/freedesktop/DisplayManager/Session0";
#     DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus";
# XDG_CURRENT_DESKTOP="none+xmonad";
# XDG_DATA_DIRS="/nix/store/74j75jgxp3blmxd4rcscliy85jp9q3x7-desktops/share:/home/honey/.nix-profile/share:/nix/profile/share:/home/honey/.local/state/nix/profile/share:/etc/profiles/per-user/honey/share:/nix/var/nix/profiles/default/share:/run/current-system/sw/share";
# XDG_GREETER_DATA_DIR="/var/lib/lightdm-data/honey";
# XDG_RUNTIME_DIR="/run/user/1000";
# XDG_SEAT="seat0";
# XDG_SEAT_PATH="/org/freedesktop/DisplayManager/Seat0";
# XDG_SESSION_CLASS="user";
# XDG_SESSION_DESKTOP="none+xmonad";
# XDG_SESSION_ID="2";
# XDG_SESSION_PATH="/org/freedesktop/DisplayManager/Session0";
# XDG_SESSION_TYPE="x11";
# XDG_VTNR="7";
# XMONAD_XMESSAGE="/nix/store/scflw2sgh1wr1fic0d5mdd9j3zgffixp-xmessage-1.0.7/bin/xmessage";
#    # k XDG_SESSION_ID="2";
#   #   XDG_SESSION_TYPE="x11";
#   #  XDG_RUNTIME_DIR="/run/user/100";
#   };
#   serviceConfig = {
#      ExecStart = "${pkgs.twmn}/bin/twmnd";
#      # ExecStart = "${pkgs.deadd-notification-center}/bin/deadd-notification-center";
# 
#    };
# };
}

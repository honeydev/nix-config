# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ deviceName, ... }: { config, pkgs, ... }:

let 
    secured = import "${builtins.getEnv "PWD"}/secured.nix";

in
{
  imports =
    [ # Include the results of the hardware scan.
      ../hardware-configuration.nix
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

services.displayManager.sddm.enable = true;
services.desktopManager.plasma6.enable = true;


services.xserver = {
  enable = true;
  # videoDrivers = [ "intel" ];
  
  # desktopManager.xterm.enable = false;
  #  displayManager.lightdm = {
  #   enable = true;
  #   greeter.enable = true;
  #   greeters.mini.user = "honey";
  #   background = "/home/honey/Pictures/wallhaven-x1ppyv.jpg";
  #   autoLogin = { 
  #       enable = true; 
  #       user = "honey"; 
  #     };

  # };
  # dpi = 96;
  # windowManager.xmonad = {
  #    enable = true;
  #    enableContribAndExtras = true;
  #    extraPackages = hpkgs: [
  #      #hpkgs.xmobar
  #      hpkgs.dbus
  #      hpkgs.monad-logger
  #     # hpkgs.xmonad-screenshot
  #    ];
  #    config = builtins.readFile /home/honey/nix-config/xmonad/xmonad.hs;
  # };
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
  sound.enable = true;
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
   #  virtualbox = {
   #      host.enable = true;
   #      host.enableExtensionPack = true;
   #  };
   #  podman = {
   #   enable = true;

   #    # Create a `docker` alias for podman, to use it as a drop-in replacement
   #    dockerCompat = true;

   #    # Required for containers under podman-compose to be able to talk to each other.
   #    defaultNetwork.settings.dns_enabled = true;
   #  };
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
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
];

programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
};


users.defaultUserShell = pkgs.zsh;
programs.zsh.enable = true;

# systemd.services.myservice = {
#   enable = true;
#   after = [ "network.target" ];
#   wantedBy = [ "multi-user.target" ];
#   path = [ pkgs.deadd-notification-center ];
#   serviceConfig = {
#      ExecStart = "deadd-notification-center";
#    };
# };
}

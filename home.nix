{ config, pkgs, lib, ... }:
let 
#    secured = import "${builtins.getEnv "PWD"}/secured.nix";
    unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };

in {
  # TODO please change the username & home directory to your own
  home.username = "honey";
  home.homeDirectory = "/home/honey";
  home.enableNixpkgsReleaseCheck = false;

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 96;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them
    brave
    kazam

    neofetch
    nnn # terminal file manager

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    ipcalc  # it is a calculator for the IPv4/v6 addresses

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    hugo # static site generator
    glow # markdown previewer in terminal

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    ansible
    gnumake
    ranger
    htop
    # neovim
    xmobar
    rofi
    j4-dmenu-desktop
    xclip
    telegram-desktop
    # tmux
    jetbrains.idea-community
    jetbrains.pycharm-community
    jetbrains.idea-ultimate
    jetbrains.rust-rover
    mattermost-desktop
    #citrix_workspace
    firefox
    simplescreenrecorder
    openconnect
    keepassxc
    bluetuith
    httpie
    obsidian
    xarchiver
    yandex-disk
    arandr
    feh
    spotify
    thefuck
    #discord
    lazygit
    evince
    dive # look into docker image layers
    # podman-tui # status of containers in the terminal
    podman-compose # start group of containers for dev
    hakuneko
    ##  protonvpn-gui
    racket
    postman
#    evolution
#     evolution-ews
#    wireguard
    wireguard-tools
    xfce.xfce4-screenshooter
    xfce.thunar
    thunderbird
    twmn
    nerdfonts
    aws-workspaces
    qbittorrent
    inkscape
    vlc
    unstable.amnezia-vpn
    jdk8
    tuxguitar
];



  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    # userName = "easlebedev";
    # userEmail = "xiaoyin_c@qq.com";
  };


  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator

  programs.alacritty = {
    enable = true;
      # custom settings
      settings = {
      terminal.shell = "zsh";
      env.TERM = "xterm-256color";
      font = {
        size = 12;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
      window.opacity = 0.6;
    };
  };
    

   programs.zsh = {
     enable = true;
     enableCompletion = true;
     syntaxHighlighting.enable = true;
   
     shellAliases = lib.mkMerge [
        {
          ll = "ls -l";
          update = "sudo nixos-rebuild switch";
          r = "ranger";
          # kvantera = secured.shellAliases.kvantera;
          avi = "NVIM_APPNAME=astronvim nvim";
        }
        # secured.shellAliases
     ];
     # histSize = 10000;
     # histFile = "${config.xdg.dataHome}/zsh/history";
     oh-my-zsh = {
        enable = true;
        plugins = [ "git" "thefuck" ];
        theme = "mortalscumbag";
        };
    };
   programs.bash = {
     enable = true;
     enableCompletion = true;
     # TODO add your custom bashrc here
     bashrcExtra = ''
       export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
     '';

     # set some aliases, feel free to add more or remove some
     shellAliases = {
       k = "kubectl";
       r = "ranger";
       urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
       urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
       
    };
   };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  # xsession = {
  #   enable = true;

# #  initExtra = extra + polybarOpts;

  #  windowManager.xmonad = {
  #    enable = true;
  #    enableContribAndExtras = true;
  #    extraPackages = hp: [
  #      hp.xmobar
  #      hp.dbus
  #      hp.monad-logger
  #    ];
  #    config = ./xmonad/xmonad.hs;
  #  };
  # };
 
 programs.tmux = {
  enable = true;
  clock24 = true;
  extraConfig = '' 
set -g status-right '#[fg=black,bg=color15] #{cpu_percentage}  %H:%M '
    run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
    '';
  };
  programs.vscode = {

    enable = true;
    package = pkgs.vscode.fhs;
};

 programs.neovim = {
   enable = true;
   extraConfig = lib.fileContents /home/honey/.config/nvim/init.vim;
 };
}


{ pkgs, lib, inputs, ... }:
let #    secured = import "${builtins.getEnv "PWD"}/secured.nix";
     unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };

in {

#nixpkgs.overlays = [
#      nur.repos.moaxcp.overlays.use-moaxcp-nur-packages
#];


  # TODO please change the username & home directory to your own
  home.username = "honey";
  home.homeDirectory = "/home/honey";
  home.enableNixpkgsReleaseCheck = false;


  programs.waybar = {
        enable = true;
        systemd.enable = true;
        settings = [
          {
            layer = "top";
            position = "top";
            output = [
              "eDP-1"
              "HDMI-A-1"
            ];
            modules-left = ["hyprland/workspaces"];
            modules-center = ["hyprland/window"]; 
            modules-right = ["custom/notifications" "network" "backlight" "battery" "clock" "tray" "custom/lock" "custom/power"];

            "hyprland/workspaces" = {
              disable-scroll = true;
              sort-by-name = false;
              all-outputs = true;
              persistent-workspaces = {
                "Home" = [];
                "1" = [];
                "2" = [];
                "3" = [];
                "4" = [];
                "5" = [];
                "6" = [];
                "7" = [];
                "8" = [];
                "9" = [];
              };
            };

            "tray" = {
              icon-size = 21;
              spacing = 10;
            };

            "clock" = {
              timezone = "Asia/Vladivostok";
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              format-alt = "  {:%d/%m/%Y}";
              format = "  {:%H:%M}";
            };

            "network" = {
              format-wifi = "{icon} ({signalStrength}%)  ";
              format-ethernet = "{ifname}: {ipaddr}/{cidr} 󰈀 ";
              format-linked = "{ifname} (No IP) 󰌘 ";
              format-disc = "Disconnected 󰟦 ";
              format-alt = "{ifname}: {ipaddr}/{cidr}";
            };

            "backlight" = {
              device = "intel_backlight";
              format = "{icon}";
              format-icons = ["" "" "" "" "" "" "" "" ""];
            };

            "battery" = {
              states = {
                warning = 30;
                critical = 15;
              };
              format = "{icon}";
              format-charging = "󰂄";
              format-plugged = "󱟢";
              format-alt = "{icon}";
              format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
            };

            ## https://github.com/Frost-Phoenix/nixos-config/blob/4d75ca005a820672a43db9db66949bd33f8fbe9c/modules/home/waybar/settings.nix#L116
            "custom/notifications" = {
              tooltip = false;
              format = "{icon} Notifications";
              format-icons = {
                notification = "󱥁 <span foreground='red'><sup></sup></span>";
                none = "󰍥 ";
                dnd-notification = "󱙍 <span foreground='red'><sup></sup></span>";
                dnd-none = "󱙎 ";
                inhibited-notification = "󱥁 <span foreground='red'><sup></sup></span>";
                inhibited-none = "󰍥 ";
                dnd-inhibited-notification = "󱙍 <span foreground='red'><sup></sup></span>";
                dnd-inhibited-none = "󱙎 ";
              };
              return-type = "json";
              exec-if = "which swaync-client";
              exec = "swaync-client -swb";
              on-click = "swaync-client -t -sw";
              on-click-right = "swaync-client -d -sw";
              escape = true;
            };
            ##

            "custom/lock" = {
              tooltip = false;
              on-click = "${pkgs.hyprlock}/bin/hyprlock";
              format = " ";
            };

            "custom/power" = {
              tooltip = false;
              on-click = "${pkgs.wlogout}/bin/wlogout &";
              format = " ";
            };
          }
        ];

        style = ''
          * {
            font-family: '0xProto Nerd Font';
            font-size: 18px;
            min-height: 0;
          }

          #waybar {
            background: transparent;
            color: @text;
            margin: 5px 5px;
          }

          #workspaces {
            border-radius: 1rem;
            margin: 5px;
            background-color: @surface0;
            margin-left: 1rem;
          }

          #workspaces button {
            color: @lavender;
            border-radius: 1rem;
            padding: 0.4rem;
          }

          #workspaces button.active {
            color: @peach;
            border-radius: 1rem;
          }

          #workspaces button:hover {
            color: @peach;
            border-radius: 1rem;
          }

          #custom-music,
          #tray,
          #backlight,
          #network,
          #clock,
          #battery,
          #custom-lock,
          #custom-notifications,
          #custom-power {
            background-color: @surface0;
            padding: 0.5rem 1rem;
            margin: 5px 0;
          }

          #clock {
            color: @blue;
            border-radius: 0px 1rem 1rem 0px;
            margin-right: 1rem;
          }

          #battery {
            color: @green;
          }

          #battery.charging {
            color: @green;
          }

          #battery.warning:not(.charging) {
            color: @red;
          }

          #backlight {
            color: @yellow;
          }

          #custom-notifications {
            border-radius: 1rem;
            margin-right: 1rem;
            color: @peach;
          }

          #network {
            border-radius: 1rem 0px 0px 1rem;
            color: @sky;
          }

          #custom-music {
            color: @mauve;
            border-radius: 1rem;
          }

          #custom-lock {
              border-radius: 1rem 0px 0px 1rem;
              color: @lavender;
          }

          #custom-power {
              margin-right: 1rem;
              border-radius: 0px 1rem 1rem 0px;
              color: @red;
          }

          #tray {
            margin-right: 1rem;
            border-radius: 1rem;
          }

          @define-color rosewater #f4dbd6;
          @define-color flamingo #f0c6c6;
          @define-color pink #f5bde6;
          @define-color mauve #c6a0f6;
          @define-color red #ed8796;
          @define-color maroon #ee99a0;
          @define-color peach #f5a97f;
          @define-color yellow #eed49f;
          @define-color green #a6da95;
          @define-color teal #8bd5ca;
          @define-color sky #91d7e3;
          @define-color sapphire #7dc4e4;
          @define-color blue #8aadf4;
          @define-color lavender #b7bdf8;
          @define-color text #cad3f5;
          @define-color subtext1 #b8c0e0;
          @define-color subtext0 #a5adcb;
          @define-color overlay2 #939ab7;
          @define-color overlay1 #8087a2;
          @define-color overlay0 #6e738d;
          @define-color surface2 #5b6078;
          @define-color surface1 #494d64;
          @define-color surface0 #363a4f;
          @define-color base #24273a;
          @define-color mantle #1e2030;
          @define-color crust #181926;
        '';
      };


  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    # The hyprland package to use
    package = pkgs.hyprland;
    # Whether to enable XWayland
    xwayland.enable = true;

    # Optional
    # Whether to enable hyprland-session.target on hyprland startup
    systemd.enable = true;
  };

  wayland.windowManager.hyprland.settings = {
          "$terminal" = "alacritty";
          "$mod" = "SUPER";

          monitor = [
#            ",prefered,auto,1"

             "HDMI-A-1, 2560x1080@60@60@60, 0x0, auto"
             "eDP-1, 1920x1200@60, 0x1080, 1"
          ];

          workspace = [
            "1,monitor:eDP-1,default:true"
            "2,monitor:HDMI-A-1,default:true"
            "3,monitor:HDMI-A-1"
            "4,monitor:eDP-1"
            "5,monitor:eDP-1"
     
           "6,monitor:HDMI-A-1"
           "7,monitor:HDMI-A-1"
           "8,monitor:HDMI-A-1"
           "9,monitor:HDMI-A-1"
           "10,monitor:HDMI-A-1" 
         ];

          xwayland = {
            force_zero_scaling = true;
          };

          general = {
            gaps_in = 6;
            gaps_out = 6;
            border_size = 2;
            layout = "dwindle";
            allow_tearing = true;
          };

          input = {
            kb_layout = "us,ru";
            kb_options = "grp:alt_shift_toggle";
            follow_mouse = true;
            touchpad = {
              natural_scroll = true;
            };
            accel_profile = "flat";
            sensitivity = 0;
          };

          decoration = {
            rounding = 0;
            active_opacity = 0.9;
            inactive_opacity = 0.8;
            fullscreen_opacity = 0.9;

            blur = {
              enabled = true;
              xray = true;
              special = false;
              new_optimizations = true;
              size = 14;
              passes = 4;
              brightness = 1;
              noise = 0.01;
              contrast = 1;
              popups = true;
              popups_ignorealpha = 0.6;
              ignore_opacity = false;
            };

#            drop_shadow = true;
#            shadow_ignore_window = true;
#            shadow_range = 20;
#            shadow_offset = "0 2";
#            shadow_render_power = 4;
          };

          animations = {
            enabled = true;
            bezier = [
              "linear, 0, 0, 1, 1"
              "md3_standard, 0.2, 0, 0, 1"
              "md3_decel, 0.05, 0.7, 0.1, 1"
              "md3_accel, 0.3, 0, 0.8, 0.15"
              "overshot, 0.05, 0.9, 0.1, 1.1"
              "crazyshot, 0.1, 1.5, 0.76, 0.92"
              "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
              "menu_decel, 0.1, 1, 0, 1"
              "menu_accel, 0.38, 0.04, 1, 0.07"
              "easeInOutCirc, 0.85, 0, 0.15, 1"
              "easeOutCirc, 0, 0.55, 0.45, 1"
              "easeOutExpo, 0.16, 1, 0.3, 1"
              "softAcDecel, 0.26, 0.26, 0.15, 1"
              "md2, 0.4, 0, 0.2, 1"
            ];
            animation = [
              "windows, 1, 3, md3_decel, popin 60%"
              "windowsIn, 1, 3, md3_decel, popin 60%"
              "windowsOut, 1, 3, md3_accel, popin 60%"
              "border, 1, 10, default"
              "fade, 1, 3, md3_decel"
              "layersIn, 1, 3, menu_decel, slide"
              "layersOut, 1, 1.6, menu_accel"
              "fadeLayersIn, 1, 2, menu_decel"
              "fadeLayersOut, 1, 4.5, menu_accel"
              "workspaces, 1, 7, menu_decel, slide"
              "specialWorkspace, 1, 3, md3_decel, slidevert"
            ];
          };

          cursor = {
            enable_hyprcursor = false;
          };

          dwindle = {
            pseudotile = true;
            preserve_split = true;
#            no_gaps_when_only = 0;
            smart_split = false;
            smart_resizing = false;
          };

          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
          };

          bind = [
            # General
            "$mod, return, exec, $terminal"
            "$mod SHIFT, c, killactive"
            "$mod SHIFT, q, exit"
            "$mod SHIFT, 0, exec, ${pkgs.hyprlock}/bin/hyprlock"
            "$mod SHIFT, t, exec, hyprctl dispatch togglegroup"
            "$mod, j, changegroupactive, b"
            "$mod, k, changegroupactive, f"

            # Screen focus
            "$mod, v, togglefloating"
            "$mod, u, focusurgentorlast"
            "$mod, tab, focuscurrentorlast"
            "$mod, f, fullscreen"

            # Screen resize
            "$mod CTRL, h, resizeactive, -20 0"
            "$mod CTRL, l, resizeactive, 20 0"
            "$mod CTRL, k, resizeactive, 0 -20"
            "$mod CTRL, j, resizeactive, 0 20"

            # Workspaces
            "$mod, 1, workspace, 1"
            "$mod, 2, workspace, 2"
            "$mod, 3, workspace, 3"
            "$mod, 4, workspace, 4"
            "$mod, 5, workspace, 5"
            "$mod, 6, workspace, 6"
            "$mod, 7, workspace, 7"
            "$mod, 8, workspace, 8"
            "$mod, 9, workspace, 9"
            "$mod, 0, workspace, 10"

            # Move to workspaces
            "$mod SHIFT, 1, movetoworkspace,1"
            "$mod SHIFT, 2, movetoworkspace,2"
            "$mod SHIFT, 3, movetoworkspace,3"
            "$mod SHIFT, 4, movetoworkspace,4"
            "$mod SHIFT, 5, movetoworkspace,5"
            "$mod SHIFT, 6, movetoworkspace,6"
            "$mod SHIFT, 7, movetoworkspace,7"
            "$mod SHIFT, 8, movetoworkspace,8"
            "$mod SHIFT, 9, movetoworkspace,9"
            "$mod SHIFT, 0, movetoworkspace,10"

            # Navigation
            "$mod, h, movefocus, l"
            "$mod, l, movefocus, r"
            "$mod, k, movefocus, u"
            "$mod, j, movefocus, d"

            # Applications
#            "$mod ALT, f, exec, ${pkgs.firefox}/bin/firefox"
            "$mod ALT, e, exec, $terminal --hold -e ${pkgs.yazi}/bin/yazi"
            "$mod ALT, o, exec, ${pkgs.obsidian}/bin/obsidian"
            "$mod, m, exec, pkill fuzzel || ${pkgs.fuzzel}/bin/fuzzel"
            "$mod ALT, r, exec, pkill anyrun || ${pkgs.anyrun}/bin/anyrun"
            "$mod ALT, n, exec, swaync-client -t -sw"
            "$mod, p, exec, rofi -show"

            # Clipboard
            "$mod ALT, v, exec, pkill fuzzel || cliphist list | fuzzel --no-fuzzy --dmenu | cliphist decode | wl-copy"

            # Screencapture
            "$mod SHIFT, p, exec, xfce4-screenshooter"
            # Screen active window
            ''
              $mod ALT, , exec, hyprctl -j activewindow \
                | jq -r "\"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])\"" \
                | grim -g - \
                | wl-copy
            ''
          ];

          bindm = [
           "$mod, mouse:272, movewindow"

          ];

          env = [
            "NIXOS_OZONE_WL,1"
            "_JAVA_AWT_WM_NONREPARENTING,1"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
            "QT_QPA_PLATFORM,wayland"
            "SDL_VIDEODRIVER,wayland"
            "GDK_BACKEND,wayland"
            "LIBVA_DRIVER_NAME,nvidia"
            "XDG_SESSION_TYPE,wayland"
            "XDG_SESSION_DESKTOP,Hyprland"
            "XDG_CURRENT_DESKTOP,Hyprland"
            "GBM_BACKEND,nvidia-drm"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          ];
          exec-once = [
            "${pkgs.hyprpaper}/bin/hyprpaper"
            "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store"
            "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store"
            "eval $(gnome-keyring-daemon --start --components=secrets,ssh,gpg,pkcs11)"
            "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &"
            "hash dbus-update-activation-environment 2>/dev/null"
            "export SSH_AUTH_SOCK"
            "${pkgs.plasma5Packages.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
          ];


  };

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
#  xresources.properties = {
#    "Xcursor.size" = 16;
#    "Xft.dpi" = 96;
#  };

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
#    xmobar
#    rofi
    rofi-wayland
    j4-dmenu-desktop
    neovim
    xclip
    telegram-desktop
    # tmux
    jetbrains.idea-community
    jetbrains.pycharm-community
    jetbrains.idea-ultimate
    jetbrains.rust-rover
    mattermost-desktop
    citrix_workspace
    firefox-bin
    simplescreenrecorder
    openconnect
    keepassxc
    obsidian
    yandex-disk
    arandr
    feh
    spotify
    thefuck
#    discord
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
#    evolution-ews
#    wireguard
    wireguard-tools
    twmn
#    nerdfonts
#    aws-workspaces
    qbittorrent
    inkscape
    vlc
    amnezia-vpn
    jdk8
    tuxguitar
#    deadd-notification-center
    xmobar
    xarchiver
    xfce.xfce4-screenshooter
    pgadmin4-desktopmode
    pulsemixer
    hyprlock
    wl-clipboard
    grim
    unstable.elmPackages.elm-language-server
    unstable.elmPackages.elm
    unstable.elmPackages.elm-live
    unstable.elmPackages.elm-format
    unstable.elmPackages.nodejs
    gnome-tweaks
    libreoffice-qt
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
      window.opacity = 0.9;
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
          n = "steam-run nvim";
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
       n = "steam-run nvim";
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
#  programs.vscode = {
#
#    enable = true;
#    package = pkgs.vscode.fhs;
#};
#
# programs.neovim = {
#   enable = true;
#   extraConfig = lib.fileContents /home/honey/.config/nvim/init.vim;
# };
}


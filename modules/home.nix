{ pkgs, monitors, hyprpaperConf, ... }: {

  home = {
    username = "baptiste";
    homeDirectory = "/home/baptiste";
    stateVersion = "23.11";
    file."wallpapers".source = ../dot/wallpapers;
    file.".config/hypr/hyprpaper.conf".source = ../dot/hyprpaper.${hyprpaperConf}conf;
    file.".config/hypr/hypridle.conf".source = ../dot/hypridle.conf;
    file.".config/hypr/hyprlock.conf".source = ../dot/hyprlock.conf;
  };
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    gnupg
    thunderbird
    kubectl
    wireguard-tools
  ];

  programs.git = {
    enable = true;
    userEmail = "baptiste@forge.epita.fr";
    userName = "Baptiste Fontaine";
    signing = {
      key = "0F52C374F0E6FA6BE68140D0A6A2FCF37E96351E";
      signByDefault = true;
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    settings = {
      "$mod" = "WIN";
      bind =
        [
          "$mod, F, exec, firefox"
          "$mod, RETURN, exec, kitty"
          "$mod, Q, killactive,"
          "$mod, L, exec, hyprlock"
          "$mod SHIFT, S, exec, watershot --copy path $HOME/Screenshots"
          "$mod, M, exit,"
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"
          "$mod, R, exec, rofi -show run"
          "$mod, code:10, workspace, 1"
          "$mod, code:11, workspace, 2"
          "$mod, code:12, workspace, 3"
          "$mod, code:13, workspace, 4"
          "$mod, code:14, workspace, 5"
          "$mod, code:15, workspace, 6"
          "$mod, code:16, workspace, 7"
          "$mod, code:17, workspace, 8"
          "$mod, code:18, workspace, 9"
          "$mod, code:19, workspace, 10"
          "$mod SHIFT, code:10, movetoworkspace, 1"
          "$mod SHIFT, code:11, movetoworkspace, 2"
          "$mod SHIFT, code:12, movetoworkspace, 3"
          "$mod SHIFT, code:13, movetoworkspace, 4"
          "$mod SHIFT, code:14, movetoworkspace, 5"
          "$mod SHIFT, code:15, movetoworkspace, 6"
          "$mod SHIFT, code:16, movetoworkspace, 7"
          "$mod SHIFT, code:17, movetoworkspace, 8"
          "$mod SHIFT, code:18, movetoworkspace, 9"
          "$mod SHIFT, code:19, movetoworkspace, 10"
        ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      general = {
        gaps_in = 7;
        gaps_out = 15;
        border_size = 3;
        resize_on_border = "yes";
        extend_border_grab_area = 15;
        layout = "dwindle";
      };
      decoration = {
        rounding = 10;
        blur = {
          enabled = "true";
          size = 3;
          new_optimizations = "true";
          passes = 1;
        };
        drop_shadow = "yes";
        shadow_range = 4;
        shadow_render_power = 3;
      };
      animations = {
        enabled = "yes";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default, slidevert"
        ];
      };
      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
      };
      master = {
        new_is_master = "true";
      };
      windowrule = [
        "opacity 0.9 0.7, ^(kitty)$"
      ];
      input = {
        kb_layout = "fr";
        follow_mouse = 1;
      };
      monitor = monitors;
      exec-once = "waybar & hyprpaper & hypridle";
    };
  };


  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };
    settings = {
      mainBar = {
        layer = "top";
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "cpu" "memory" "pulseaudio" ];

        "hyprland/workspaces" = {
          "format" = "{icon}";
          "all-outputs" = true;
          "format-icons" = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "10";
          };
        };

        "clock" = {
          "format" = "<span color='#b4befe'> </span>{:%H:%M}";
          "tooltip" = true;
          "tooltip-format" = "{:%Y-%m-%d %a}";
        };

        "cpu" = { "format" = "<span color='#b4befe'> </span>{usage}%"; };
        "memory" = {
          "interval" = 1;
          "format" = "<span color='#b4befe'> </span>{used:0.1f}G/{total:0.1f}G";
        };
        "pulseaudio" = {
          "format" = "<span color='#b4befe'>{icon}</span> {volume}%";
          "format-muted" = "";
          "tooltip" = false;
          "format-icons" = {
            "headphone" = "";
            "default" = [ "" "" "󰕾" "󰕾" "󰕾" "" "" "" ];
          };
          "scroll-step" = 1;
          "on-click" = "pavucontrol";
        };
      };
    };
    style = ''
      * {
        border: none;
        font-family: 'Fira Code', 'Symbols Nerd Font Mono';
        font-size: 16px;
        font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
        min-height: 25px;
      }

      window#waybar {
        background: transparent;
      }
 
      #workspaces {
        border-radius: 10px;
        background-color: #11111b;
        color: #b4befe;
        margin-top: 15px;
        margin-right: 15px;
        padding-top: 1px;
        padding-left: 10px;
        padding-right: 10px;
      }

      #workspaces button.active {
        background: #11111b;
        color: #b4befe;
      }

      #clock, #pulseaudio, #cpu, #memory{
        border-radius: 10px;
        background-color: #11111b;
        color: #cdd6f4;
        margin-top: 15px;
        padding-left: 10px;
        padding-right: 10px;
        margin-right: 15px;
      }

      #pulseaudio {
        padding-left: 5px;
      }

      #clock {
        margin-right: 0;
      }
    '';
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = [
      pkgs.rofi-emoji
    ];
    theme = "Arc-Dark";
  };


  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
      k = "kubectl";
      kcx = "kubectl config use-context";
      nr = "nix run";
    };
    history = {
      expireDuplicatesFirst = true;
      save = 100000000;
      size = 1000000000;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "history" ];
      theme = "robbyrussell";
    };
    initExtra = ''
      export GPG_TTY=$TTY
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      gpgconf --launch gpg-agent
    '';
    envExtra = ''
      EDITOR=vim
    '';
  };


}  

{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      ${builtins.readFile "${pkgs.waybar}/etc/xdg/waybar/style.css"}
      * {
        font-size: 16px;
        font-family: "JetBrainsMono Nerd Font, JetBrainsMono NF";
        min-width: 8px;
        min-height: 0px;
        border: none;
        border-radius: 0;
        box-shadow: none;
        text-shadow: none;
        padding: 0px;
      }

      /* Waybar Styling */
      window#waybar {
        transition-property: background-color;
        transition-duration: 0.5s;
        border-radius: 8px;
        border: 2px solid #88c0d0; /* Primary color for borders */
        background: rgba(28, 28, 34, 0.7); /* Dark semi-transparent background */
        color: #e5e9f0; /* Light text color */
      }

      /* Menu and Tooltip Styling */
      menu, tooltip {
        border-radius: 8px;
        padding: 2px;
        border: 1px solid #81a1c1; /* Light blue border */
        background: rgba(28, 28, 34, 0.6); /* Semi-transparent dark background */
        color: #e5e9f0;
      }

      menu label, tooltip label {
        font-size: 14px;
        color: #d8dee9; /* Slightly darker text for labels */
      }

      /* Animation for attention indicators */
      #submap, #tray>.needs-attention {
        animation-name: blink-active;
        animation-duration: 1s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      /* Module Groups Styling */
      .modules-right, .modules-left {
        margin: 6px;
        border-radius: 4px;
        background: rgba(35, 35, 42, 0.4); /* Lighter semi-transparent background */
        color: #e5e9f0;
      }

      /* Custom Module Boxes */
      #gcpu, #custom-github, #memory, #disk, #together, #submap, #custom-weather, #custom-recorder, #connection, #cnoti, #brightness, #power, #custom-updates, #tray, #audio, #privacy, #sound {
        border-radius: 4px;
        margin: 2px;
        background: rgba(46, 52, 64, 0.3); /* Darker box background */
      }

      #custom-notifications {
        padding-left: 4px;
      }

      #custom-hotspot, #custom-github, #custom-notifications {
        font-size: 14px;
      }

      /* Specific Module Styling */
      #privacy-item, #gcpu, #custom-vpn, #custom-hotspot {
        padding: 6px;
        background: rgba(46, 52, 64, 0.3); /* Reusing dark background */
      }

      #custom-cpu-icon {
        font-size: 25px;
      }

      #custom-cputemp, #disk, #memory, #cpu {
        font-size: 14px;
        font-weight: bold;
      }

      #workspaces {
        margin: 2px;
        padding: 4px;
        border-radius: 8px;
      }

      #workspaces button {
        transition-property: background-color;
        transition-duration: 0.5s;
        color: rgba(236, 239, 244, 0.3); /* Light, semi-transparent text color */
        background: transparent;
        border-radius: 4px;
      }

      #workspaces button.urgent {
        font-weight: bold;
        color: #e5e9f0;
      }

      #workspaces button.active {
        padding: 4px 2px;
        background: rgba(88, 192, 208, 0.4); /* Light blue background */
        color: #e5e9f0;
        border-radius: 4px;
      }

      #network.wifi, #submap, #bluetooth, #battery, #clock, #pulseaudio.mic {
        padding: 4px;
        border-radius: 8px;
      }

      #pulseaudio.mic {
        color: #2e3440; /* Dark text */
        background: rgba(76, 86, 106, 0.6); /* Medium-dark background */
        padding-left: 4px;
      }

      /* Slider Styling */
      #backlight-slider slider, #pulseaudio-slider slider {
        background-color: transparent;
        box-shadow: none;
      }

      #backlight-slider trough, #pulseaudio-slider trough {
        margin-top: 4px;
        min-width: 6px;
        min-height: 60px;
        border-radius: 8px;
        background-color: rgba(28, 28, 34, 0.6);
      }

      #backlight-slider highlight, #pulseaudio-slider highlight {
        border-radius: 8px;
        background-color: #88c0d0; /* Light blue highlight */
      }

      /* Battery Warning and Animation */
      #battery.discharging.warning {
        animation-name: blink-yellow;
      }

      #battery.discharging.critical {
        animation-name: blink-red;
      }

      /* Keyframes */
      @keyframes blink-active {
        to {
          background-color: #88c0d0; /* Light blue color for blinking */
          color: #e5e9f0;
        }
      }

      @keyframes blink-red {
        to {
          background-color: #c64d4f; /* Red color for critical battery */
          color: #e5e9f0;
        }
      }

      @keyframes blink-yellow {
        to {
          background-color: #cf9022; /* Yellow color for battery warning */
          color: #e5e9f0;
        }
      }
    '';
    settings = {
      layer = "top";
      position = "right";
      margin = "5 2 5 0";
      reload_style_on_change = true;

      modules-left = ["custom/updates" "group/info"];

      "group/info" = {
        orientation = "inherit";
        drawer = {
          transition-duration = 500;
          transition-left-to-right = false;
        };
        modules = ["custom/dmark" "group/gcpu" "memory" "disk"];
      };

      "custom/dmark" = {
        format = "";
        tooltip = false;
      };

      "group/gcpu" = {
        orientation = "inherit";
        modules = ["custom/cpu-icon" "cpu"];
      };

      "custom/cpu-icon" = {
        format = "󰻠";
        tooltip = false;
      };

      cpu = {
        format = "<b>{usage}󱉸</b>";
        on-click = "foot btop";
      };

      memory = {
        format = "<b>  \n{:2}󱉸</b>";
      };

      disk = {
        interval = 600;
        format = "<b> 󰋊 \n{percentage_used}󱉸</b>";
        path = "/";
      };

      modules-right = ["privacy" "group/brightness" "group/sound" "group/connection" "group/together" "tray" "group/power"];

      privacy = {
        orientation = "vertical";
        icon-spacing = 4;
        icon-size = 14;
        transition-duration = 250;
        modules = [
          {
            type = "screenshare";
            tooltip = true;
            tooltip-icon-size = 24;
          }
        ];
      };

      "group/brightness" = {
        orientation = "inherit";
        drawer = {
          transition-duration = 500;
          transition-left-to-right = false;
        };
        modules = ["backlight" "backlight/slider"];
      };

      backlight = {
        device = "intel_backlight";
        format = "{icon}";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
        ];
        on-scroll-down = "brightnessctl s 5%-";
        on-scroll-up = "brightnessctl s +5%";
        tooltip = true;
        tooltip-format = "Brightness: {percent}% ";
        smooth-scrolling-threshold = 1;
      };

      "backlight/slider" = {
        min = 5;
        max = 100;
        orientation = "vertical";
        device = "intel_backlight";
      };

      "group/sound" = {
        orientation = "inherit";
        modules = ["group/audio" "custom/notifications"];
      };

      "group/audio" = {
        orientation = "inherit";
        drawer = {
          transition-duration = 500;
          transition-left-to-right = false;
        };
        modules = ["pulseaudio" "pulseaudio#mic" "pulseaudio/slider"];
      };

      "group/connection" = {
        orientation = "inherit";
        modules = ["group/network" "group/bluetooth"];
      };

      "group/together" = {
        orientation = "inherit";
        modules = ["group/utils" "clock"];
      };

      "group/utils" = {
        orientation = "inherit";
        drawer = {
          transition-duration = 500;
          transition-left-to-right = true;
        };
        modules = ["custom/mark" "idle_inhibitor"];
      };

      "group/network" = {
        orientation = "inherit";
        drawer = {
          transition-duration = 500;
          transition-left-to-right = true;
        };
        modules = ["network" "network#speed"];
      };

      "group/bluetooth" = {
        orientation = "inherit";
        drawer = {
          transition-duration = 500;
          transition-left-to-right = true;
        };
        modules = ["bluetooth" "bluetooth#status"];
      };

      "group/power" = {
        orientation = "inherit";
        drawer = {
          transition-duration = 500;
          transition-left-to-right = false;
        };
        modules = ["battery" "power-profiles-daemon"];
      };

      tray = {
        icon-size = 18;
        spacing = 10;
      };

      pulseaudio = {
        format = "{icon}";
        format-bluetooth = "{icon}";
        tooltip-format = "{volume}% {icon} | {desc}";
        format-muted = "󰖁";
        format-icons = {
          headphones = "󰋌";
          handsfree = "󰋌";
          headset = "󰋌";
          phone = "";
          portable = "";
          car = " ";
          default = ["󰕿" "󰖀" "󰕾"];
        };
        on-click = "volume mute";
        on-click-middle = "pavucontrol";
        on-scroll-up = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
        on-scroll-down = "pactl set-sink-volume @DEFAULT_SINK@ -5%";
        smooth-scrolling-threshold = 1;
      };

      "pulseaudio#mic" = {
        format = "{format_source}";
        format-source = "";
        format-source-muted = "";
        tooltip-format = "{volume}% {format_source} ";
        on-click = "pactl set-source-mute 0 toggle";
        on-scroll-down = "pactl set-source-volume 0 -1%";
        on-scroll-up = "pactl set-source-volume 0 +1%";
      };

      "pulseaudio/slider" = {
        min = 0;
        max = 140;
        orientation = "vertical";
      };

      network = {
        format = "{icon}";
        format-icons = {
          wifi = ["󰤨"];
          ethernet = ["󰈀"];
          disconnected = ["󰖪"];
        };
        tooltip = false;
        on-click = "pgrep -x rofi &>/dev/null && notify-send rofi || networkmanager_dmenu";
      };

      "network#speed" = {
        format = " {bandwidthDownBits} ";
        rotate = 90;
        interval = 5;
        tooltip = true;
        on-click = "pgrep -x rofi &>/dev/null && notify-send rofi || networkmanager_dmenu";
      };

      bluetooth = {
        format-on = "";
        format-off = "󰂲";
        format-disabled = "";
        format-connected = "<b></b>";
        on-click = "rofi-bluetooth -config ~/.config/rofi/menu.d/network.rasi -i";
      };

      "bluetooth#status" = {
        format-on = "";
        format-off = "";
        format-connected = "<b>{num_connections}</b>";
        on-click = "blueman-applet";
      };

      battery = {
        rotate = 270;
        states = {
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{icon}";
        tooltip-format = "{timeTo} {capacity} % | {power} W";
      };

      clock = {
        format = "{:%H\n%M}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
      };

      power-profiles-daemon = {
        format = "{icon}";
        tooltip-format = "Power profile: {profile}\nDriver: {driver}";
        tooltip = true;
      };

      "custom/mark" = {
        format = "";
        tooltip = false;
      };

      "custom/notifications" = {
        format = "<b>{}</b> ";
        exec = "noti-cycle -j";
        on-click = "noti-cycle";
        on-click-right = "noti-cycle rofi";
      };

      idle_inhibitor = {
        format = "{icon}";
        tooltip-format-activated = "Idle Inhibitor is active";
        tooltip-format-deactivated = "Idle Inhibitor is not active";
      };
    };
  };
}

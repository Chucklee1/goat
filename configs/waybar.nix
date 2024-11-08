{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.waybar = {
    enable = true;
    style = ''
      /* Base background colors */
      :root {
        --bg-main: rgba(25, 25, 25, 0.65);
        --bg-main-tooltip: rgba(0, 0, 0, 0.7);
        --bg-hover: rgba(200, 200, 200, 0.3);
        --bg-active: rgba(100, 100, 100, 0.5);
        --border-main: rgba(255, 255, 255, 0.2);
        --content-main: white;
        --content-inactive: rgba(255, 255, 255, 0.25);
        --warning-color: #ff6600; /* Example, you should define this color */
      }

      /* Global styling */
      * {
        text-shadow: none;
        box-shadow: none;
        border: none;
        border-radius: 0;
        font-family: "Segoe UI", "Ubuntu";
        font-weight: 600;
        font-size: 12.7px;
      }

      window#waybar {
        background: var(--bg-main);
        border-top: 1px solid var(--border-main);
        color: var(--content-main);
      }

      tooltip {
        background: var(--bg-main-tooltip);
        border-radius: 5px;
        border-width: 1px;
        border-style: solid;
        border-color: var(--border-main);
      }

      tooltip label {
        color: var(--content-main);
      }

      #custom-os_button {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 24px;
        padding-left: 12px;
        padding-right: 20px;
        transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
      }

      #custom-os_button:hover {
        background: var(--bg-hover);
        color: var(--content-main);
      }

      #workspaces {
        color: transparent;
        margin-right: 1.5px;
        margin-left: 1.5px;
      }

      #workspaces button {
        padding: 3px;
        color: var(--content-inactive);
        transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
      }

      #workspaces button.active {
        color: var(--content-main);
        border-bottom: 3px solid white;
      }

      #workspaces button.focused {
        color: var(--bg-active);
      }

      #workspaces button.urgent {
        background: rgba(255, 200, 0, 0.35);
        border-bottom: 3px dashed var(--warning-color);
        color: var(--warning-color);
      }

      #workspaces button:hover {
        background: var(--bg-hover);
        color: var(--content-main);
      }

      #taskbar {}

      #taskbar button {
        min-width: 130px;
        border-bottom: 3px solid rgba(255, 255, 255, 0.3);
        margin-left: 2px;
        margin-right: 2px;
        padding-left: 8px;
        padding-right: 8px;
        color: white;
        transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
      }

      #taskbar button.active {
        border-bottom: 3px solid white;
        background: var(--bg-active);
      }

      #taskbar button:hover {
        border-bottom: 3px solid white;
        background: var(--bg-hover);
        color: var(--content-main);
      }

      #cpu, #disk, #memory {
        padding: 3px;
      }

      #temperature {
        color: transparent;
        font-size: 0px;
        transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
      }

      #temperature.critical {
        padding-right: 3px;
        color: var(--warning-color);
        font-size: initial;
        border-bottom: 3px dashed var(--warning-color);
        transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
      }

      #window {
        border-radius: 10px;
        margin-left: 20px;
        margin-right: 20px;
      }

      #tray {
        margin-left: 5px;
        margin-right: 5px;
      }

      #tray > .passive {
        border-bottom: none;
      }

      #tray > .active {
        border-bottom: 3px solid white;
      }

      #tray > .needs-attention {
        border-bottom: 3px solid var(--warning-color);
      }

      #tray > widget {
        transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
      }

      #tray > widget:hover {
        background: var(--bg-hover);
      }

      #pulseaudio {
        font-family: "JetBrainsMono Nerd Font";
        padding-left: 3px;
        padding-right: 3px;
        transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
      }

      #pulseaudio:hover {
        background: var(--bg-hover);
      }

      #network {
        padding-left: 3px;
        padding-right: 3px;
      }

      #language {
        padding-left: 5px;
        padding-right: 5px;
      }

      #clock {
        padding-right: 5px;
        padding-left: 5px;
        transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
      }

      #clock:hover {
        background: var(--bg-hover);
      }
    '';
    settings = [
      {
        layer = "bottom";
        position = "bottom";
        mod = "dock";
        exclusive = true;
        gtk-layer-shell = true;
        margin-bottom = -1;
        passthrough = false;
        modules-left = ["custom/fuzz"];
        modules-center = ["custom/workspace1" "custom/workspace2"];
        modules-right = [
          "cpu"
          "temperature"
          "memory"
          "disk"
          "tray"
          "pulseaudio"
          "network"
          "battery"
          "clock"
        ];
        "custom/fuzz" = {
          format = "";
          on-click = "fuzzel";
          tooltip = false;
        };
        "custom/workspace1" = {
          format = "1";
          on-click = "niri msg action focus-workspace 1";
          tooltip = "Switch to workspace 1";
        };

        "custom/workspace2" = {
          format = "2";
          on-click = "niri msg action focus-workspace 2";
          tooltip = "Switch to workspace 2";
        };
        cpu = {
          interval = 5;
          format = "  {usage}%";
          max-length = 10;
        };

        temperature = {
          hwmon-path-abs = "/sys/devices/platform/coretemp.0/hwmon";
          input-filename = "temp2_input";
          critical-threshold = 75;
          tooltip = false;
          format-critical = "({temperatureC}°C)";
          format = "({temperatureC}°C)";
        };

        disk = {
          interval = 30;
          format = "󰋊 {percentage_used}%";
          path = "/";
          tooltip = true;
          unit = "GB";
          tooltip-format = "Available {free} of {total}";
        };

        memory = {
          interval = 10;
          format = "  {percentage}%";
          max-length = 10;
          tooltip = true;
          tooltip-format = "RAM - {used:0.1f}GiB used";
        };

        tray = {
          icon-size = 18;
          spacing = 3;
        };

        clock = {
          format = "      {:%R\n %d.%m.%Y}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            "on-click-right" = "mode";
            "on-click-forward" = "tz_up";
            "on-click-backward" = "tz_down";
            "on-scroll-up" = "shift_up";
            "on-scroll-down" = "shift_down";
          };
        };

        network = {
          format-wifi = " {icon}";
          format-ethernet = "  ";
          format-disconnected = "󰌙";
          format-icons = [
            "󰤯 "
            "󰤟 "
            "󰤢 "
            "󰤢 "
            "󰤨 "
          ];
        };

        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 20;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };

        pulseaudio = {
          max-volume = 150;
          scroll-step = 10;
          format = "{icon}";
          tooltip-format = "{volume}%";
          format-muted = " ";
          format-icons = {
            default = [
              " "
              " "
              " "
            ];
          };
          on-click = "pwvucontrol";
        };
      }
    ];
  };
}

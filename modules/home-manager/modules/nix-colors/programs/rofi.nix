{ config, lib, ... }:

with lib;

let
  csTypes = import ../types.nix { inherit config lib; };

  cfg = config.programs.rofi;
  colorscheme = cfg.nix-colors.colorscheme;
in
{
  options = {
    programs.rofi.nix-colors = mkOption {
      type = csTypes.nix-colors;
      default = { };
    };
  };

  config = mkIf cfg.nix-colors.enable {
    programs.rofi.theme = "base16-${ colorscheme.slug }";

    xdg.dataFile = {
      # https://gitlab.com/jordiorlando/base16-rofi
      "rofi/themes/base16-${ colorscheme.slug }.rasi" = {
        # red:                         rgba ( {{base08-rgb-r}}, {{base08-rgb-g}}, {{base08-rgb-b}}, 100 % );
        # blue:                        rgba ( {{base0D-rgb-r}}, {{base0D-rgb-g}}, {{base0D-rgb-b}}, 100 % );
        # lightfg:                     rgba ( {{base06-rgb-r}}, {{base06-rgb-g}}, {{base06-rgb-b}}, 100 % );
        # lightbg:                     rgba ( {{base01-rgb-r}}, {{base01-rgb-g}}, {{base01-rgb-b}}, 100 % );
        # foreground:                  rgba ( {{base05-rgb-r}}, {{base05-rgb-g}}, {{base05-rgb-b}}, 100 % );
        # background:                  rgba ( {{base00-rgb-r}}, {{base00-rgb-g}}, {{base00-rgb-b}}, 100 % );
        # background-color:            rgba ( {{base00-rgb-r}}, {{base00-rgb-g}}, {{base00-rgb-b}}, 0 % );
        text = ''
          /**
           * Base16 ${ colorscheme.name } ROFI Color theme
           *
           * Authors
           *  Scheme: ${ colorscheme.author }
           *  Template: Jordi Pakey-Rodriguez (https://github.com/0xdec), Andrea Scarpino (https://github.com/ilpianista)
           */

          * {
              red:                         #${ colorscheme.colors.base08 }FF;
              blue:                        #${ colorscheme.colors.base0D }FF;
              lightfg:                     #${ colorscheme.colors.base06 }FF;
              lightbg:                     #${ colorscheme.colors.base01 }FF;
              foreground:                  #${ colorscheme.colors.base05 }FF;
              background:                  #${ colorscheme.colors.base00 }FF;
              background-color:            #${ colorscheme.colors.base00 }00;
              separatorcolor:              @foreground;
              border-color:                @foreground;
              selected-normal-foreground:  @lightbg;
              selected-normal-background:  @lightfg;
              selected-active-foreground:  @background;
              selected-active-background:  @blue;
              selected-urgent-foreground:  @background;
              selected-urgent-background:  @red;
              normal-foreground:           @foreground;
              normal-background:           @background;
              active-foreground:           @blue;
              active-background:           @background;
              urgent-foreground:           @red;
              urgent-background:           @background;
              alternate-normal-foreground: @foreground;
              alternate-normal-background: @lightbg;
              alternate-active-foreground: @blue;
              alternate-active-background: @lightbg;
              alternate-urgent-foreground: @red;
              alternate-urgent-background: @lightbg;
              spacing:                     2;
          }
          window {
              background-color: @background;
              border:           1;
              padding:          5;
          }
          mainbox {
              border:           0;
              padding:          0;
          }
          message {
              border:           1px dash 0px 0px ;
              border-color:     @separatorcolor;
              padding:          1px ;
          }
          textbox {
              text-color:       @foreground;
          }
          listview {
              fixed-height:     0;
              border:           2px dash 0px 0px ;
              border-color:     @separatorcolor;
              spacing:          2px ;
              scrollbar:        true;
              padding:          2px 0px 0px ;
          }
          element-text, element-icon {
              background-color: inherit;
              text-color:       inherit;
          }
          element {
              border:           0;
              padding:          1px ;
          }
          element normal.normal {
              background-color: @normal-background;
              text-color:       @normal-foreground;
          }
          element normal.urgent {
              background-color: @urgent-background;
              text-color:       @urgent-foreground;
          }
          element normal.active {
              background-color: @active-background;
              text-color:       @active-foreground;
          }
          element selected.normal {
              background-color: @selected-normal-background;
              text-color:       @selected-normal-foreground;
          }
          element selected.urgent {
              background-color: @selected-urgent-background;
              text-color:       @selected-urgent-foreground;
          }
          element selected.active {
              background-color: @selected-active-background;
              text-color:       @selected-active-foreground;
          }
          element alternate.normal {
              background-color: @alternate-normal-background;
              text-color:       @alternate-normal-foreground;
          }
          element alternate.urgent {
              background-color: @alternate-urgent-background;
              text-color:       @alternate-urgent-foreground;
          }
          element alternate.active {
              background-color: @alternate-active-background;
              text-color:       @alternate-active-foreground;
          }
          scrollbar {
              width:            4px ;
              border:           0;
              handle-color:     @normal-foreground;
              handle-width:     8px ;
              padding:          0;
          }
          sidebar {
              border:           2px dash 0px 0px ;
              border-color:     @separatorcolor;
          }
          button {
              spacing:          0;
              text-color:       @normal-foreground;
          }
          button selected {
              background-color: @selected-normal-background;
              text-color:       @selected-normal-foreground;
          }
          inputbar {
              spacing:          0px;
              text-color:       @normal-foreground;
              padding:          1px ;
              children:         [ prompt,textbox-prompt-colon,entry,case-indicator ];
          }
          case-indicator {
              spacing:          0;
              text-color:       @normal-foreground;
          }
          entry {
              spacing:          0;
              text-color:       @normal-foreground;
          }
          prompt {
              spacing:          0;
              text-color:       @normal-foreground;
          }
          textbox-prompt-colon {
              expand:           false;
              str:              ":";
              margin:           0px 0.3000em 0.0000em 0.0000em ;
              text-color:       inherit;
          }
        '';
      };
    };
  };
}

#!/usr/bin/env bash

# Function to get the current workspace ID
get_current_workspace_id() {
    hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .activeWorkspace.id'
}

# Function to minimize all windows on the current workspace
minimize_windows() {
    local current_workspace_id=$(get_current_workspace_id)

    for id in $(hyprctl clients -j | jq -r ".[] | select(.workspace.id == $current_workspace_id) | select(.fullscreen > 0) | .address"); do
        hyprctl dispatch "fullscreenstate" "$id" 0
    done
}

handle() {
    case $1 in
    openwindow*) minimize_windows ;;
    esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done

#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.drawing=on
else
    sketchybar --set $NAME background.drawing=off
fi


for monitor in $(aerospace list-monitors --format "%{monitor-appkit-nsscreen-screens-id}"); do
    for sid in $(aerospace list-workspaces --monitor "$monitor"); do
        apps=$(aerospace list-windows --workspace "$sid" --format "%{app-name}" | sort | uniq)

        sketchybar --set space.$sid drawing=on

        if [ -n "$apps" ]; then
            while read -r app; do
                if [ "$app" = "Messages" ]; then
                    status=$(sqlite3 ~/Library/Messages/chat.db "SELECT COUNT(guid) FROM message WHERE NOT(is_read) AND NOT(is_from_me);")
                else
                    status="$(lsappinfo info -only StatusLabel "$app" | sed -n 's/.*"label"="\(.*\)".*/\1/p')"
                fi
                echo "$app - $status"
                icon_strip+="$($CONFIG_DIR/plugins/icon_map.sh "$app") "$status" "

                echo "$icon_strip"
            done <<< "$apps"
        else
            icon_strip=""
        fi

        if [ -n "$status" ]; then
            sketchybar --set space.$sid update_freq=60 label="$icon_strip"
        else
            sketchybar --set space.$sid label="$icon_strip"
        fi

        icon_strip=""
    done
done
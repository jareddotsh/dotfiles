### START ICON MAP PLUGIN ###
function get_icon() {
    case "$1" in
        "Finder") icon="" ;;
        "Google Chrome") icon="" ;;
        "Firefox") icon="" ;;
        "Code" | "VS Code") icon="" ;;
        "Slack") icon="" ;;
        "Spotify") icon="" ;;
        "Mail") icon="" ;;
        "Messages" | "Signal") icon="󰵅" ;;
        "Calendar") icon="" ;;
        "Ghostty" | "iTerm2" | "Terminal") icon="" ;;
        "Bambu Studio") icon="󰐫" ;;
        "Discord") icon="" ;;
        *) icon="$1" ;;  # Default icon
    esac
}

get_icon "$1"

echo "$icon"
### END ICON MAP PLUGIN ###
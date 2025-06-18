#!/bin/sh

# Options
window='󱣵 Select window'
screen='󰹑 Entire screen'

rofi_cmd() {
    rofi -dmenu \
        -i -l 2 -p "Screenshot:"
    }

run_rofi() {
    echo -e "$screen\n$window" | rofi_cmd
}

run_cmd() {
    if [[ $1 == '--window' ]]; then
        hyprshot -m window -o ~/Pictures/screenshots
    elif [[ $1 == '--screen' ]]; then
        hyprshot -m output -m active -o ~/Pictures/screenshots
    else
        exit 0
    fi
}

chosen="$(run_rofi)"


case ${chosen} in
    $screen)
        (sleep 0.5 && run_cmd --screen) &
        ;;
    $window)
        (sleep 0.5 && run_cmd --window) &
        ;;
esac

exit 0

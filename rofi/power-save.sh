#!/bin/sh

# Options
powersave='󰾆 Power save'
balanced='󰾅 Balanced'
performance='󰓅 Performance'

rofi_cmd() {
   rofi -dmenu \
      -i -l 3 -p "Power saving:"
}

run_rofi() {
   echo -e "$powersave\n$balanced\n$performance" | rofi_cmd
}

run_cmd() {
   if [[ $1 == '--powersave' ]]; then
      powerprofilesctl set power-saver
   elif [[ $1 == '--balanced' ]]; then
      powerprofilesctl set balanced
   elif [[ $1 == '--performance' ]]; then
      powerprofilesctl set performance
   else
      exit 0
   fi
}

chosen="$(run_rofi)"

case ${chosen} in
   $powersave)
      run_cmd --powersave
      ;;
   $balanced)
      run_cmd --balanced
      ;;
   $performance)
      run_cmd --performance
      ;;
esac

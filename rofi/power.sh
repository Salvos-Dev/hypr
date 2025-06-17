#!/bin/sh

# Options
shutdown='󰐥 Shutdown'
reboot='󰜉 Reboot'
firmware='󰜉 Reboot (firmware)'
hibernate='󰤄 Hibernate'
lock='󰌾 Lock'

rofi_cmd() {
   rofi -dmenu \
      -i -l 5 -p " "
}

run_rofi() {
   echo -e "$lock\n$hibernate\n$reboot\n$firmware\n$shutdown" | rofi_cmd
}

run_cmd() {
   if [[ $1 == '--shutdown' ]]; then
      systemctl poweroff
   elif [[ $1 == '--reboot' ]]; then
      systemctl reboot
   elif [[ $1 == '--firmware' ]]; then
      systemctl reboot --firmware-setup
   elif [[ $1 == '--hibernate' ]]; then
      systemctl hibernate
   elif [[ $1 == '--lock' ]]; then
       hyprlock
   else
      exit 0
   fi
}

chosen="$(run_rofi)"

case ${chosen} in
   $shutdown)
      run_cmd --shutdown
      ;;
   $reboot)
      run_cmd --reboot
      ;;
   $firmware)
      run_cmd --firmware
      ;;
   $hibernate)
      run_cmd --hibernate
      ;;
   $lock)
      run_cmd --lock
      ;;
esac

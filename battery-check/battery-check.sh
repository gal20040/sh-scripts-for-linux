#выполнить в консоли:
#$ touch /home/gal20040/apps/battery-check/battery-check.sh
#$ sudo chmod +x /home/gal20040/apps/battery-check/battery-check.sh

#$ crontab -e
#проверяем уровень заряда - сигнализируем
#* * * * * sh /home/gal20040/apps/battery-check/battery-check.sh
#у предыдущей строки убрать знак #
 
#всё, что ниже, надо добавить в созданный скрипт
#!/bin/bash

chargeStatus=$(acpi | awk '{print $3}' | sed "s/,//")
discharging='Discharging'

if [ "$chargeStatus" = "$discharging" ]; then

  batteryPercent=$(acpi | awk '{print $4}' | sed "s/%,//")
  if [ "$batteryPercent" -le "10" ]; then
    DISPLAY=:0 gdialog --msgbox "Battery discharching" 25 20 > /dev/null
  fi
  
#todo - звук не слышен, если запуск идёт через crontab; если же запускать скрипт вручную, то всё ок.
#если разобраться со звуком, то можно настроить разную тональность и продолжительность (т.е. надоедливость) для разного уровня заряда.
#  if [ "$batteryPercent" -gt "5" ] && [ "$batteryPercent" -le "10" ]; then
#    play -n synth 0.1 sin 2500
#    sleep 0.1
#    play -n synth 0.1 sin 2500
#    sleep 0.1
#    play -n synth 0.1 sin 2500 #это для просто низкого заряда
#    play -n synth 1 sin 4100 #это для совсем тревоги - громче и продолжительнее
#    DISPLAY=:0 gdialog --msgbox "Battery discharching" 25 20 > /dev/null
#  fi
fi

exit 0

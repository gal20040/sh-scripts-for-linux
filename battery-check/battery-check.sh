#проверить наличие утилит:
#acpi - для определения заряда
#$ sudo apt install acpi
#для звука
#$ sudo apt install sox

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
  if [ "$batteryPercent" -le "15" ]; then
    #todo - звук не всегда слышен, если запуск идёт через crontab; если же запускать скрипт вручную, то всё ок.
    play -n synth 0.1 sin 2500
    sleep 0.1
    if [ "$batteryPercent" -le "10" ]; then
      play -n synth 0.1 sin 2500
      sleep 0.1
      play -n synth 0.1 sin 2500
      sleep 0.1
      play -n synth 0.1 sin 2500
      play -n synth 1 sin 4100
    fi
    DISPLAY=:0 gdialog --msgbox "Battery discharching" 25 20 > /dev/null
  fi
fi

exit 0

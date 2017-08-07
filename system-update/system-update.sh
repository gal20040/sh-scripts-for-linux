#выполнить в консоли:
#$ touch /home/gal20040/apps/system-update/system-update.sh
#$ sudo chmod +x /home/gal20040/apps/system-update/system-update.sh

#$ sudo crontab -e
#обновляем систему
#0 * * * * sh /home/gal20040/apps/system-update/system-update.sh
#у предыдущей строки убрать знак #

#всё, что ниже, надо добавить в созданный скрипт
#!/bin/bash

wifi1='KAMA'
wifi2='gal'
wifi3='Innopolis'
charging='Charging'
full='Full'

logPath='/home/gal20040/apps/system-update/log.txt'
#todo как писать лог, используя переменную logPath?

echo '' >> /home/gal20040/apps/system-update/log.txt
myssid=$(sudo iwgetid -r)

if [ "$myssid" = "$wifi1" ] || [ "$myssid" = "$wifi2" ] || [ "$myssid" = "$wifi3" ]; then
  batteryPercent=$(acpi | awk '{print $4}' | sed "s/%,//")
  chargeStatus=$(acpi | awk '{print $3}' | sed "s/,//")

  date >> /home/gal20040/apps/system-update/log.txt
  mess='Connected to wifi: '
  echo $mess$myssid >> /home/gal20040/apps/system-update/log.txt

  if [ "$batteryPercent" -gt "50" ] && [ "$chargeStatus" = "$charging" ] && [ "$chargeStatus" = "$full" ]; then
    echo 'System updating start' >> /home/gal20040/apps/system-update/log.txt

    sudo apt update -y
    echo "sudo apt update -y" >> /home/gal20040/apps/system-update/log.txt

    sudo apt full-upgrade -y
    echo "sudo apt full-upgrade -y" >> /home/gal20040/apps/system-update/log.txt

    sudo apt autoremove -y
    echo "sudo apt autoremove -y" >> /home/gal20040/apps/system-update/log.txt

    sudo apt autoclean -y
    echo "sudo apt autoclean -y" >> /home/gal20040/apps/system-update/log.txt

    sudo apt-get --purge autoremove -y
    echo "sudo apt-get --purge autoremove -y" >> /home/gal20040/apps/system-update/log.txt

    date >> /home/gal20040/apps/system-update/log.txt
    echo 'System updated successfully' >> /home/gal20040/apps/system-update/log.txt
  else
    messChPercent='No update. Battery charge: '
    messChStatus='% Charge status: '
    echo $messChPercent$batteryPercent$messChStatus$chargeStatus >> /home/gal20040/apps/system-update/log.txt
  fi
else
  date >> /home/gal20040/apps/system-update/log.txt
  mess='There is no necessary connection - no update. Connected to wifi: '
  echo $mess$myssid >> /home/gal20040/apps/system-update/log.txt
fi

exit 0
#logPath='/home/gal20040/apps/system-update/log.txt'
#todo как писать лог, используя переменную logPath?

#todo: есть вероятность, что во время обновления системы я выключу комп. Что произойдёт с обновлением? Надо подумать, как избежать проблем.
#todo: даже если комп подключён к указанным сетям (см. wifi1-3), то не факт, что есть доступ в инет (инет может быть не оплачен) - надо сделать проверку по команде ping

#выполнить в консоли:
#$ touch /home/gal20040/apps/system-update/log.txt
#$ touch /home/gal20040/apps/system-update/system-update.sh
#$ sudo chmod +x /home/gal20040/apps/system-update/system-update.sh

#Dependencies:
#$ sudo apt install acpi

#$ sudo crontab -e
#обновляем систему
#0 * * * * sh /home/gal20040/apps/system-update/system-update.sh
#у предыдущей строки убрать знак #

#всё, что ниже, надо добавить в созданный скрипт
#!/bin/bash

wifi1='KAMA'
wifi2='gal'
charging='Charging'
full='Full'
minChargePercent='50'
seemsPCHasNoBattery='No support for device type: power_supply'

myssid=$(sudo iwgetid -r)
mess='Connected to wifi: '

echo '' >> /home/gal20040/apps/system-update/log.txt
date >> /home/gal20040/apps/system-update/log.txt
echo $mess$myssid >> /home/gal20040/apps/system-update/log.txt

if [ "$myssid" = "$wifi1" ] || [ "$myssid" = "$wifi2" ]; then

	#todo результат acpi не присваивается acpiResult, а выводится на экран.
	#переменная acpiResult - остаётся пустой.
    acpiResult=$(acpi)
    if [ "$acpiResult" = "$seemsPCHasNoBattery" ]; then
		#todo эта часть не работает, потому что в acpiResult пусто.
        batteryPercent='-1'
        chargeStatus=$(seemsPCHasNoBattery)
    else
        batteryPercent=$(acpi | awk '{print $4}' | sed "s/,//" | sed "s/%//")
        chargeStatus=$(acpi | awk '{print $3}' | sed "s/,//")
    fi

    messChPercent='Battery charge: '
    messChStatus='% Charge status: '
    echo $messChPercent$batteryPercent$messChStatus$chargeStatus >> /home/gal20040/apps/system-update/log.txt

    if [ "$chargeStatus" = "$full" ] || [ "$chargeStatus" = "$seemsPCHasNoBattery" ] || ([ "$chargeStatus" = "$charging" ] && [ "$batteryPercent" -gt "$minChargePercent" ]); then
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
        mess='Insufficient charge, no update.'
        echo $mess >> /home/gal20040/apps/system-update/log.txt
    fi
else
    mess='There is no necessary connection - no update.'
    echo $mess >> /home/gal20040/apps/system-update/log.txt
fi

exit 0

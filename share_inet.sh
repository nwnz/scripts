#!/bin/sh
# интерфейс локальной сети
LAN_IFACE="eth0:0"
INTERNET_IFACE="ppp0"
IP_SERVER="192.168.0.1"
IP_NETMASK="255.255.255.0"
# список разрешённых ip
IP_ALLOWED="192.168.0.2 192.168.0.3 192.168.0.4"
IPTABLES="/sbin/iptables"


case "$1" in
    -h)
	echo "666(расшарить)"
	echo "777(статистика)"
	echo "888(граф  статистика)"
	;;
    --help)
	echo "666(расшарить)"
	echo "777(статистика)"
	echo "888(граф  статистика)"
	;;
    777)
	(sudo watch $0)
	;;
    888)
	gksudo $0 | zenity --text-info
	;;
    666)
	/sbin/ifconfig $LAN_IFACE $IP_SERVER netmask $IP_NETMASK
	# обнулить таблицы
	echo -n "Обнуляю таблицы ..."
	$IPTABLES -t nat -F
	$IPTABLES -F
	echo " [OK]"
	##########################
	for IP in $IP_ALLOWED
	do
	    echo -n "Разрешаю: $IP"
	    $IPTABLES -A FORWARD -d $IP -j ACCEPT
	    $IPTABLES -t nat -A POSTROUTING -s $IP -o $INTERNET_IFACE -j MASQUERADE
	    echo " [OK]"
	done

	# разрешить передачу трафика от интерфейса к интерфейсу
	# TODO: LAN_IFACE
	echo 1 |  tee /proc/sys/net/ipv4/ip_forward >/dev/null
	echo "Интернет раздаётся [OK]"
	;;
    *)
	$IPTABLES -L -n -v | sed -r "s/^\s+//" | sed -r "s/\s+/ /g" \
	    | cut -f 2,9  -d ' ' \
	    | grep -v FORWARD | grep -v INPUT | grep -v OUTPUT \
	    | grep -v byte | grep -v "^$" | sort | uniq
	
	;;
esac

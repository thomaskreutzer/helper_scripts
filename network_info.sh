#!/bin/bash
### This script is to gather build/installation information on RHEL nodes
###
### Release: 1.0
### 
### By: Andrew Heichelbech
###
CLIENT=""  ### Fill in prior to running
HOSTNAME=`hostname`
DATE=`date +%d%b%Y`
LOGFILE=/tmp/$CLIENT_$HOSTNAME_$DATE.log
hwmodel(){
    cat /sys/class/dmi/id/product_name
}
hwmake(){
    cat /sys/class/dmi/id/chassis_vendor
}
hwserial(){
    cat /sys/class/dmi/id/product_serial
}
numcpu(){
	grep -i "physical id" /proc/cpuinfo | sort -u | wc -l 
}
findcpu(){
	grep 'model name' /proc/cpuinfo  | uniq | awk -F':' '{ print $2}'
}
 
findkernelversion(){
	uname -mrs
}
 
totalmem(){
	grep -i 'memtotal' /proc/meminfo | awk -F':' '{ print $2}'
}
securelin(){
	getenforce
}
thp(){
	cat /sys/kernel/mm/transparent_hugepage/enabled
	cat /sys/kernel/mm/transparent_hugepage/defrag
}
swappiness(){
	cat /proc/sys/vm/swappiness
}
javaver(){
	java -version
	which java
}
ipt(){
	service iptables status
}
ntp(){
	service ntp status
        ntpq -p
}
net(){
	ifconfig -a
}
netbond(){
    if [ `ifconfig |grep bond| awk -F: '{ print $1 }' | head -1` != "" ];
    then
        echo "Found Bonded Interfaces : "
        for i in `ifconfig |grep bond| awk -F: '{ print $1 }`;
        do
            echo -n "$i Bonding Mode: "; cat /sys/class/net/$i/bonding/mode;
            echo -n "$i Bond Interfaces: "; cat /sys/class/net/$i/bonding/slaves;
            for e in `cat /sys/class/net/$i/bonding/slaves`
            do
                echo -n "$i:$e speed:"; cat /sys/class/net/$e/speed;
                echo -n "$i:$e duplex:"; cat /sys/class/net/$e/duplex;
                echo -n "$i:$e mtu:"; cat /sys/class/net/$e/mtu;
                echo -n "$i:$e state:"; cat /sys/class/net/$e/operstate;
            done
            echo "";
        done
    else
        echo "No Bonded Interfaces Found"
    fi
}
RPMS(){
	rpm -qa |sort
}
account(){
	cat /etc/passwd | sort
	cat /etc/group | sort
}
procs(){
	ps -elf
} 
sysctl(){
	echo -e "\t /etc/sysctl.conf :\n ";cat /etc/sysctl.conf
	echo -e "\t /etc/sysctl.d :\n ";ls -l /etc/sysctl.d/*
}
fstab(){
	cat /etc/fstab
}
        
        
echo "Run Date : $DATE"
echo "Client : $CLIENT"
echo -e "Hostname : $HOSTNAME\n"
echo "HW Make : $(hwmodel)"
echo "HW Model : $(hwmake)"
echo "CPU Type : $(hwserial)"
echo "CPU Type : $(findcpu)"
echo "Number of CPUs : $(numcpu)"
echo "Kernel version : $(findkernelversion)"
echo "Total memory : $(totalmem)"
echo "Network interfaces : $(net)"
echo "Network Bond interfaces: $(netbond)"
echo -e "\n\n##################\n"
echo "Swappiness : $(swappiness)"
echo -e "Transparent Huge Page : \n $(thp)"
echo "SELINUX : $(securelin)"
echo -e " JAVA INFO : \n $(javaver)"
echo "IPTABLES : $(ipt)"
echo "NTP : $(ntp)"
echo -e "NETWORK : \n $(net)"
echo -e "\n\n##################\n" 
echo -e "Account Info : \n $(account)"
echo -e "\n\n##################\n" 
echo -e "sysctl.conf : \n $(sysctl)"
echo -e "\n\n##################\n" 
echo -e "fstab : \n $(fstab)"
echo -e "\n\n##################\n" 
echo -e "Processes : \n $(procs)"
echo -e "\n\n##################\n" 

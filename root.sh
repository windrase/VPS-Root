#!/bin/bash

green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
[[ $EUID -ne 0 ]] && su='sudo' 
lsattr /etc/passwd /etc/shadow >/dev/null 2>&1
chattr -i /etc/passwd /etc/shadow >/dev/null 2>&1
chattr -a /etc/passwd /etc/shadow >/dev/null 2>&1
lsattr /etc/passwd /etc/shadow >/dev/null 2>&1
prl=`grep PermitRootLogin /etc/ssh/sshd_config`
pa=`grep PasswordAuthentication /etc/ssh/sshd_config`
if [[ -n $prl && -n $pa ]]; then
echo "==============================================="
echo "                   LazyDev                     "
echo "==============================================="
    read -p "Masukkan password root yang ingin disetel: " mima
    echo root:$mima | $su chpasswd root
    $su sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
    $su sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
    $su service sshd restart
    green "VPS username saat ini: root"
    green "VPS password root saat ini: $mima"
else
    red "VPS ini tidak mendukung akun root atau tidak dapat menyetel password root kustom" && exit 1
fi

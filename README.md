# Extreme-DOT ROUTER Project
Turn your Linux Machine into MultiVPN LoadBalancer

PC Configuration: [ What i Have]
- 3 NIC Lan Cards
- Intel CPU
- 4 GB RAM
- 16 GB SanDisk USB 3.1 , UBUNTU 22.12 Server has installed on it.

## AUto Scipted Menu
cd /tmp
curl -O https://raw.githubusercontent.com/ExtremeDot/DOT_ROUTER/master/main.sh
chmod +x /tmp/main.sh
mv /tmp/main.sh /bin/dotrouter
chmod +x /bin/dotrouter

## STEPS
* Installing Linux UBUNTU 22.12 on USB FLASH DISK
- after installing of ubuntu has finishs

```sh
sudo -i
```
get root access,enter your password 

```sh
apt-get update 
apt upgrade
apt install -y mc
```
* REDUCE WAIT TIME FOR SYSTEM STARTUP MENU
```sh
nano /etc/default/grub
```
- change GRUB_DEFAULT=1
- change GRUB_TIMEOUT=1
save and exit nano
```sh
nano /boot/grub/grub.cfg
```

set timeout_style=menu
if [ "${timeout}" = 0 ]; then
  set timeout=1 
fi

save and exit nano

* ENABLING SSH ROOT ACCESS
```sh
nano /etc/ssh/sshd_config
```
- PermitRootLogin yes

save and Exit nano

```sh
service ssh restart

sudo passwd root
admin # type your password

reboot
```

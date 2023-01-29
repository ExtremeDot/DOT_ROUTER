#!/bin/bash
clear
#DOTDIR=/dot_router
DOTDIR=/ExtremeDOT/Router
mkdir -p $DOTDIR

#IF DEF VALS ARE AVAILABLE
touch $DOTDIR/common.sh
cat <<EOF > $DOTDIR/common.sh
RED='\033[0;31m'        # Red
BLUE='\033[1;34m'       # LIGHTBLUE
GREEN='\033[0;32m'      # Green
NC='\033[0m'            # No Color
HOST_PING=8.8.8.8
PINGTXT1=\`echo "-- PING Check: -----------------------------------------------" | cut -c 1-45\`
INTFTXT1=\`echo "-- INTERFACE Check: -----------------------------------------------" | cut -c 1-45\`

EOF

YELLOW='\033[0;33m'	# YELLOW
RED='\033[0;31m'        # Red
BLUE='\033[1;34m'       # LIGHTBLUE
GREEN='\033[0;32m'      # Green
NC='\033[0m'            # No Color
clear

echo -e "\033[0;31m G O L D E N   D O T   R O U T E R      Version:1.027  "
echo "======================================================"
echo -e "${YELLOW} Application Status"
PS3=" $(echo $'\n'-----------------------------$'\n' "   Enter Option: " ) "
SSTPCVERSION=`sstpc -version | head -n 1`
XRAYVERSION=`xray --version | head -n 1`
V2RAYVERSION=`v2ray version | head -n 1`
BADVPNVERSION=`badvpn-tun2socks --version | head -n 1`
TUN2SOCKSVERSION=`tun2socks -version | head -n 1`
LOADBALANCERVERSION=`load_balance.pl -V`
echo -e "${GREEN}    $SSTPCVERSION "
echo -e "    $XRAYVERSION"
echo -e "    $V2RAYVERSION"
echo -e "    $BADVPNVERSION"
echo -e "    $TUN2SOCKSVERSION"
echo -e "    Load Balancer $LOADBALANCERVERSION ${NC}"
echo " ----------------------------------------------------"
echo -e "${YELLOW} Clients Status"

#SSTP1

CLIENT_FILE1=$DOTDIR/client1.sh
CLIENT_NAME1=`sed -n -e '/client_name/{s/.*= *//p}' $CLIENT_FILE1 | sed  's/.*"\(.*\)".*/\1/'`

CLIENT_FILE2=$DOTDIR/client2.sh
CLIENT_NAME2=`sed -n -e '/client_name/{s/.*= *//p}' $CLIENT_FILE2 | sed  's/.*"\(.*\)".*/\1/'`

HTT1=`ip address show label $CLIENT_NAME1 | grep inet | awk '{print $2}'`
HTT2=`ip address show label $CLIENT_NAME2 | grep inet | awk '{print $2}'`

if [ -n "$HTT1" ] ; then echo -e "${GREEN}    $CLIENT_NAME1 [OK RUNNING]${NC} " ; else echo -e "${RED}    $CLIENT_NAME1 [NOT RUNNING]${NC}" ; fi
if [ -n "$HTT2" ] ; then echo -e "${GREEN}    $CLIENT_NAME2 [OK RUNNING]${NC} " ; else echo -e "${RED}    $CLIENT_NAME2 [NOT RUNNING]${NC}" ; fi

V2RAYSTATUS=`systemctl status v2ray | grep Active | cut -c 14-100`
XRAYSTATUS=`systemctl status xray | grep Active | cut -c 14-100`

echo -e "${GREEN}    V2RAY: $V2RAYSTATUS"
echo -e "${GREEN}    XRAY: $V2RAYSTATUS ${NC}"
echo " ----------------------------------------------------"
echo
options=(
"Installing DHCP Server"
"Install All Clients, SSTP V2ray Xray BadVPN tun2socks"
"Install LoadBalancer" 
"Setup SSTP Client Number 1" 
"Setup SSTP Client Number 2" 
"Setup V2ray Client" 
"V2Ray Config Editor" 
"XRay Config Editor" 
"LoadBalancer Config" 
"SSTP1-CHECK" 
"SSTP2-CHECK" 
"V2RAY-CHECK" 
"XRAY-CHECK" 
"CLEAR" "UPDATE" "Quit")
select opt in "${options[@]}"
do
case $opt in

"SSTP1-CHECK")
clear
SSTP1PING=`curl --connect-timeout 20 --interface $CLIENT_NAME1 -o /dev/null -s -w 'Total: %{time_total}s\n' google.com | cut -c 7-20`
SSTP1IP=`curl --silent --connect-timeout 20 --interface $CLIENT_NAME1 -4 myip.wtf/json | grep YourFuckingIPAddress | sed  's/.*"\(.*\)".*/\1/'`
SSTP1LOCATION=`curl --silent --connect-timeout 20 --interface $CLIENT_NAME1 -4 myip.wtf/json | grep YourFuckingLocation | sed  's/.*"\(.*\)".*/\1/'`
echo
echo -e "${YELLOW}Connection Name [SSTP1]= $CLIENT_NAME1" ;echo ""
echo -e "${RED}IP=$SSTP1IP ${GREEN}IP Location=$SSTP1LOCATION "
echo -e "${BLUE}Ping to Google=$SSTP1PING ${NC}" ; echo ""
;;

"SSTP2-CHECK")
clear
SSTP2PING=`curl --connect-timeout 20 --interface $CLIENT_NAME2 -o /dev/null -s -w 'Total: %{time_total}s\n' google.com | cut -c 7-20`
SSTP2IP=`curl --silent --connect-timeout 20 --interface $CLIENT_NAME2 -4 myip.wtf/json | grep YourFuckingIPAddress | sed  's/.*"\(.*\)".*/\1/'`
SSTP2LOCATION=`curl --silent --connect-timeout 20 --interface $CLIENT_NAME2 -4 myip.wtf/json | grep YourFuckingLocation | sed  's/.*"\(.*\)".*/\1/'`
echo
echo -e "${YELLOW}Connection Name [SSTP2]= $CLIENT_NAME2" ;echo ""
echo -e "${RED}IP=$SSTP2IP ${GREEN}IP Location=$SSTP2LOCATION "
echo -e "${BLUE}Ping to Google=$SSTP2PING ${NC}" ; echo ""
;;

"V2RAY-CHECK")
clear
echo
V2RAYPORT=10808
read -e -i "$V2RAYPORT" -p "Enter The V2ray Running Local Port: " input
V2RAYPORT="${input:-$V2RAYPORT}"
V2RAYPING=`curl --silent --connect-timeout 20 --socks5 socks5://localhost:$V2RAYPORT -o /dev/null -s -w 'Total: %{time_total}s\n' google.com | cut -c 7-20`
V2RAYIP=`curl --silent --connect-timeout 20 --socks5 socks5://localhost:$V2RAYPORT https://myip.wtf/json | grep YourFuckingIPAddress | sed  's/.*"\(.*\)".*/\1/'`
V2RAYLOCATION=`curl --silent --connect-timeout 20 --socks5 socks5://localhost:$V2RAYPORT https://myip.wtf/json | grep YourFuckingLocation | sed  's/.*"\(.*\)".*/\1/'`
echo
echo -e "${YELLOW}Connection Name [V2RAY]= NEEDUPDATE" ;echo ""
echo -e "${RED}IP=$V2RAYIP ${GREEN}IP Location=$V2RAYLOCATION "
echo -e "${BLUE}Ping to Google=$V2RAYPING ${NC}" ; echo ""
;;

"XRAY-CHECK")
clear
echo
XRAYPORT=20808
read -e -i "$XRAYPORT" -p "Enter The X-ray Running Local Port: " input
XRAYPORT="${input:-$XRAYPORT}"
XRAYPING=`curl --silent --connect-timeout 20 --socks5 socks5://localhost:$XRAYPORT -o /dev/null -s -w 'Total: %{time_total}s\n' google.com | cut -c 7-20`
XRAYIP=`curl --silent --connect-timeout 20 --socks5 socks5://localhost:$XRAYPORT https://myip.wtf/json | grep YourFuckingIPAddress | sed  's/.*"\(.*\)".*/\1/'`
XRAYLOCATION=`curl --silent --connect-timeout 20 --socks5 socks5://localhost:$XRAYPORT https://myip.wtf/json | grep YourFuckingLocation | sed  's/.*"\(.*\)".*/\1/'`
echo
echo -e "${YELLOW}Connection Name [X-RAY]= NEEDUPDATE" ;echo ""
echo -e "${RED}IP=$XRAYIP ${GREEN}IP Location=$XRAYLOCATION "
echo -e "${BLUE}Ping to Google=$XRAYPING ${NC}" ; echo ""
;;

"V2Ray Config Editor")
nano /usr/local/etc/v2ray/config.json
;;

"XRay Config Editor")
nano /usr/local/etc/xray/config.json
;;

"LoadBalancer Config")
clear
nano /etc/network/balance.conf
;;

#Installing LOAD BALANCER
"Install LoadBalancer")
apt-get install -y build-essential
apt-get install -y perl
mkdir -p $DOTDIR/lb_dotrouter && cd $DOTDIR/lb_dotrouter
wget https://github.com/lstein/Net-ISP-Balance/archive/master.zip
sleep 2
unzip $DOTDIR/lb_dotrouter/master.zip
sleep 1
cd $DOTDIR/lb_dotrouter/Net-ISP-Balance-master
cpan Module::Build
sleep 1
perl ./Build.PL
sleep 1
./Build installdeps
sleep 1
./Build test
sleep 2
sudo ./Build install
echo
echo "nano /etc/network/balance.conf to edit load balancer config"
echo
echo "load_balance.pl  -d > commands.sh "
echo "run above command to have your custom loadbalancer by running commands.sh script"
;;

# INSTALLING SSTP CLIENT
"Install All Clients, SSTP V2ray Xray BadVPN tun2socks")
clear
echo
echo "Installing pre-req apps"
apt install -y unzip
apt install -y shadowsocks-libev
apt install -y make cmake build-essential
apt-get install -y iptables-persistent

echo
echo "Installing sstp latest apt"
apt install -y sstp-client
echo "sstp client installing has finished."
sstpc --version

echo
echo "Installing v2ray,v2fly latest version"
mkdir -p $DOTDIR/v2rclient
cd $DOTDIR/v2rclient
touch $DOTDIR/v2rclient/info.txt
echo "DotRouter v2ray client folder" > $DOTDIR/v2rclient/info.txt
echo
echo "Installing latest V2Ray,V2fly clients"
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)
echo
echo "Updating Geo Files for V2ray Client"
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)
sleep 2
systemctl enable v2ray && sleep 2
echo
echo "Installing BADVPN " 
mkdir -p $DOTDIR/badvpn && cd $DOTDIR/badvpn && wget https://github.com/ambrop72/badvpn/archive/refs/tags/1.999.130.zip
sleep 2
unzip $DOTDIR/badvpn/1.999.130.zip && cd $DOTDIR/badvpn/badvpn-1.999.130/
sleep 2
cmake -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_TUN2SOCKS=1
sleep 1
make
sleep 1
make install
sleep 1
echo " badvpn finished ...."
echo
echo "Installing tune2socks"
mkdir -p $DOTDIR/tun2s
cd $DOTDIR/tun2s
wget https://github.com/xjasonlyu/tun2socks/releases/download/v2.4.1/tun2socks-linux-amd64.zip
unzip tun2socks-linux-amd64.zip
# 7z x tun2socks-linux-amd64.zip
rm *.zip
mv tun2socks-linux-amd64 /bin/tun2socks
chmod +x /bin/tun2socks
echo "finishing tun2socks ......"
echo
echp "Installing latest xray core"
mkdir -p $DOTDIR/xrayclient
cd $DOTDIR/xrayclient
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
sleep 2
systemctl enable xray
sleep 2
echo
echo "Updating geo files to latest"
cd $DOTDIR/xrayclient
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install-geodata
echo " all client requirements has installed"

;;

# SETTING UP SSTP CLIENT 1
"Setup SSTP Client Number 1")
mkdir -p $DOTDIR/sstp
cd $DOTDIR/sstp

echo
SSTPCONAME1="sstp_"
read -e -i "$SSTPCONAME1" -p "SSTP CLient1: Please enter name for connection: " input
SSTPCONAME1="${input:-$SSTPCONAME1}"
echo
SSTPIP1="78."
read -e -i "$SSTPIP1" -p "SSTP CLient1: Please enter the SSTP Server IP: " input
SSTPIP1="${input:-$SSTPIP1}"
echo
SSTPORT1="443"
read -e -i "$SSTPORT1" -p "SSTP CLient1: Please enter the SSTP Server Port: " input
SSTPORT1="${input:-$SSTPORT1}"
echo
USERNAME1=""
read -e -i "$USERNAME1" -p "SSTP CLient1: Please enter username: " input
USERNAME1="${input:-$USERNAME1}"
echo
PASSWORD1=""
read -e -i "$PASSWORD1" -p "SSTP CLient1: Please enter password: " input
PASSWORD1="${input:-$PASSWORD1}"

# CLIENT1.SH
touch $DOTDIR/sstp/client1.sh
sleep 1
cat <<EOF > $DOTDIR/sstp/client1.sh
#!/bin/bash
client_name=$SSTPCONAME1
user=$USERNAME1
pass=$PASSWORD1
server=$SSTPIP1
port=$SSTPORT1

sstpc --cert-warn --save-server-route --user \$user --password \$pass \$server:\$port usepeerdns require-mschap-v2 noauth noipdefault ifname \$client_name

EOF

chmod +x $DOTDIR/sstp/client1.sh

# SSTP1 CONNECT1.SH
touch $DOTDIR/sstp/connect1.sh
cat <<EOF > $DOTDIR/sstp/connect1.sh
#!/bin/bash
source $DOTDIR/common.sh
CLIENT_FILE=$DOTDIR/sstp/client1.sh
CLIENT_NAME=\`sed -n -e '/client_name/{s/.*= *//p}' \$CLIENT_FILE | sed  's/.*"\(.*\)".*/\1/'\`

echo
echo -e "\${BLUE}[\$CLIENT_NAME] ---------------------------------------------- \${NC}" | cut -c 1-60
HTT=\`ip address show label \$CLIENT_NAME | grep inet | awk '{print \$2}'\`
if [ -n "\$HTT" ] ; then
echo -e "\${GREEN}\$INTFTXT1 [OK]\${NC} "
PINGTEST=\`ping -I \$CLIENT_NAME -qc2 \$HOST_PING | awk -F'/' 'END{ print (/^rtt/? "1":"0") }'\`
sleep 1
if [ \$PINGTEST = 1 ] ; then
echo -e "\${GREEN}\$PINGTXT1 [OK] \${NC}"
exit
else
# IF NO RESPONCE
echo -e "\${RED}\$PINGTXT1 [ER]\${NC}"
fi

fi
echo -e "\${RED}\$INTFTXT1 [ER]\${NC}"
# IF NO RESPONCE
# KILLING LAST CONNECTION IF EXISTS
SSTPID1=\`ps -ef | grep sstpc | grep \$CLIENT_NAME | awk '{print \$2}'\`
kill -9 \$SSTPID1
sleep 1
echo "\$CLIENT_NAME: STARTING SSTP CONNECTION"
# RUNNING CONNECTING SCRIPT SILENTLY
bash \$CLIENT_FILE </dev/null &>/dev/null &

EOF

chmod +x $DOTDIR/sstp/connect1.sh

echo
echo "Run SSTP Client1?"
echo
until [[ $SSTP1_RUN =~ (y|n) ]]; do
read -rp "Run SSTP Connection: $SSTPCONAME1 ? [y/n]: " -e -i y SSTP1_RUN
done

if [[ $SSTP1_RUN == "y" ]]; then
echo
echo " Running $SSTPCONAME1 "
bash $DOTDIR/sstp/connect1.sh
else
echo "you can test connection using these command"
echo "bash $DOTDIR/sstp/connect1.sh"
fi
;;

################################
# SETTING UP SSTP CLIENT 2
"Setup SSTP Client Number 2")
mkdir -p $DOTDIR/sstp
cd $DOTDIR/sstp
echo
SSTPCONAME2="sstp_"
read -e -i "$SSTPCONAME2" -p "SSTP Client2: Please enter name for connection: " input
SSTPCONAME2="${input:-$SSTPCONAME2}"
echo
SSTPIP2="78."
read -e -i "$SSTPIP2" -p "SSTP Client2: Please enter the SSTP Server IP: " input
SSTPIP2="${input:-$SSTPIP2}"
echo
SSTPORT2="443"
read -e -i "$SSTPORT2" -p "SSTP Client2: Please enter the SSTP Server Port: " input
SSTPORT2="${input:-$SSTPORT2}"
echo
USERNAME2=""
read -e -i "$USERNAME2" -p "SSTP Client2: Please enter username: " input
USERNAME2="${input:-$USERNAME2}"
echo
PASSWORD2=""
read -e -i "$PASSWORD2" -p "SSTP Client2: Please enter password: " input
PASSWORD2="${input:-$PASSWORD2}"

# Client2.sh
touch $DOTDIR/sstp/client2.sh
sleep 1
cat <<EOF > $DOTDIR/sstp/client2.sh
#!/bin/bash
client_name2=$SSTPCONAME2
user=$USERNAME2
pass=$PASSWORD2
server=$SSTPIP2
port=$SSTPORT2

sstpc --cert-warn --save-server-route --user \$user --password \$pass \$server:\$port usepeerdns require-mschap-v2 noauth noipdefault ifname \$client_name2

EOF

chmod +x $DOTDIR/sstp/client2.sh

# SSTP1 CONNECT2.SH
touch $DOTDIR/sstp/connect2.sh
cat <<EOF > $DOTDIR/sstp/connect2.sh
#!/bin/bash
source $DOTDIR/common.sh
CLIENT_FILE2=$DOTDIR/sstp/client2.sh
CLIENT_NAME2=\`sed -n -e '/client_name/{s/.*= *//p}' \$CLIENT_FILE2 | sed  's/.*"\(.*\)".*/\1/'\`

echo
echo -e "\${BLUE}[\$CLIENT_NAME2] ---------------------------------------------- \${NC}" | cut -c 1-60
HTT2=\`ip address show label \$CLIENT_NAME2 | grep inet | awk '{print \$2}'\`
if [ -n "\$HTT2" ] ; then
echo -e "\${GREEN}\$INTFTXT1 [OK]\${NC} "
PINGTEST2=\`ping -I \$CLIENT_NAME2 -qc2 \$HOST_PING | awk -F'/' 'END{ print (/^rtt/? "1":"0") }'\`
sleep 1
if [ \$PINGTEST2 = 1 ] ; then
echo -e "\${GREEN}\$PINGTXT1 [OK] \${NC}"
exit
else
# IF NO RESPONCE
echo -e "\${RED}\$PINGTXT1 [ER]\${NC}"
fi

fi
echo -e "\${RED}\$INTFTXT1 [ER]\${NC}"
# IF NO RESPONCE
# KILLING LAST CONNECTION IF EXISTS
SSTPID2=\`ps -ef | grep sstpc | grep \$CLIENT_NAME2 | awk '{print \$2}'\`
kill -9 \$SSTPID2
sleep 1
echo "\$CLIENT_NAME2: STARTING SSTP CONNECTION"
# RUNNING CONNECTING SCRIPT SILENTLY
bash \$CLIENT_FILE2 </dev/null &>/dev/null &

EOF

chmod +x $DOTDIR/sstp/connect2.sh

echo
echo "Run SSTP Client2?"
echo
until [[ $SSTP2_RUN =~ (y|n) ]]; do
read -rp "Run SSTP Connection: $SSTPCONAME2 ? [y/n]: " -e -i y SSTP2_RUN
done

if [[ $SSTP2_RUN == "y" ]]; then
echo
echo " Running $SSTPCONAME2 "
bash $DOTDIR/sstp/connect2.sh
else
echo "you can test connection using these command"
echo "bash $DOTDIR/sstp/connect2.sh"
fi
;;
##############################

# DHCP SERVER
"Installing DHCP Server")
if test -f "$DOTDIR/dhcp-server.sh";
then
bash $DOTDIR/dhcp-server.sh
else
mkdir -p $DOTDIR/
cd $DOTDIR/
curl -O https://raw.githubusercontent.com/ExtremeDot/ubuntu-dhcp-server/master/dhcp-server.sh
chmod +x $DOTDIR/dhcp-server.sh
bash $DOTDIR/dhcp-server.sh
fi

;;
# Quit
"Quit")
	break
;;

# CLEAR SCREEN
"CLEAR")
	clear
;;

# CLEAR SCREEN
"UPDATE")
cd /tmp
rm /tmp/main.sh
sleep 1
curl -H 'Cache-Control: no-cache, no-store' -O https://raw.githubusercontent.com/ExtremeDot/DOT_ROUTER/master/main.sh
chmod +x /tmp/main.sh
mv /tmp/main.sh /bin/dotrouter
chmod +x /bin/dotrouter
sleep 2
clear
bash /bin/dotrouter ; exit 0
;;

# WRONG INPUT
*) echo "invalid option $REPLY"

;;
esac

# DONE
done

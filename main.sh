#!/bin/bash
DOTDIR=/dot_router
mkdir -p $DOTDIR
#IF DEF VALS ARE AVAILABLE
touch /sstp/defaults.sh
cat <<EOF > /sstp/defaults.sh
RED='\033[0;31m'        # Red
BLUE='\033[1;34m'       # LIGHTBLUE
GREEN='\033[0;32m'      # Green
NC='\033[0m'            # No Color
HOST_PING=8.8.8.8
PINGTXT1=\`echo "-- PING Check: -----------------------------------------------" | cut -c 1-45\`
INTFTXT1=\`echo "-- INTERFACE Check: -----------------------------------------------" | cut -c 1-45\`

EOF

clear
echo -e "\033[0;31m\G O L D E N   D O T   R O U T E R  - Version:1.015 \033[0m "
echo "----------------------------------------"
PS3=" $(echo $'\n'-----------------------------$'\n' "   Enter Option: " ) "
echo ""
options=( "DHCP Server" "Install SSTP Client" "Setup SSTP Client1" "Setup SSTP Client2" "CLEAR" "UPDATE" "Quit")
select opt in "${options[@]}"
do
case $opt in

# INSTALLING SSTP CLIENT
"Install SSTP Client")
apt install sstp-client
sstpc --version
;;

# SETTING UP SSTP CLIENT 1
"Setup SSTP Client1")
mkdir -p /sstp
cd /sstp

echo " "
SSTPCONAME1="sstp_"
read -e -i "$SSTPCONAME1" -p "SSTP CLient1: Please enter name for connection: " input
SSTPCONAME1="${input:-$SSTPCONAME1}"
echo " "
SSTPIP1="78."
read -e -i "$SSTPIP1" -p "SSTP CLient1: Please enter the SSTP Server IP: " input
SSTPIP1="${input:-$SSTPIP1}"
echo " "
SSTPORT1="443"
read -e -i "$SSTPORT1" -p "SSTP CLient1: Please enter the SSTP Server Port: " input
SSTPORT1="${input:-$SSTPORT1}"
echo " "
USERNAME1=""
read -e -i "$USERNAME1" -p "SSTP CLient1: Please enter username: " input
USERNAME1="${input:-$USERNAME1}"
echo " "
PASSWORD1=""
read -e -i "$PASSWORD1" -p "SSTP CLient1: Please enter password: " input
PASSWORD1="${input:-$PASSWORD1}"

# CLIENT1.SH
touch /sstp/client1.sh
sleep 1
cat <<EOF > /sstp/client1.sh
#!/bin/bash
client_name=$SSTPCONAME1
user=$USERNAME1
pass=$PASSWORD1
server=$SSTPIP1
port=$SSTPORT1

sstpc --cert-warn --save-server-route --user \$user --password \$pass \$server:\$port usepeerdns require-mschap-v2 noauth noipdefault ifname \$client_name

EOF

chmod +x /sstp/client1.sh

# SSTP1 CONNECT1.SH
touch /sstp/connect1.sh
cat <<EOF > /sstp/connect1.sh
#!/bin/bash
source /sstp/defaults.sh
CLIENT_FILE=/sstp/client1.sh
CLIENT_NAME=\`sed -n -e '/client_name/{s/.*= *//p}' \$CLIENT_FILE | sed  's/.*"\(.*\)".*/\1/'\`

echo ""
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

chmod +x /sstp/connect1.sh

echo ""
echo "Run SSTP Client1?"
echo ""
until [[ $SSTP1_RUN =~ (y|n) ]]; do
read -rp "Run SSTP Connection: $SSTPCONAME1 ? [y/n]: " -e -i y SSTP1_RUN
done

if [[ $SSTP1_RUN == "y" ]]; then
echo ""
echo " Running $SSTPCONAME1 "
bash /sstp/connect1.sh
else
echo " you can test connection using these command"
echo "bash /sstp/connect1.sh"
fi
;;

################################
# SETTING UP SSTP CLIENT 2
"Setup SSTP Client2")
mkdir -p /sstp
cd /sstp

echo " "
SSTPCONAME2="sstp_"
read -e -i "$SSTPCONAME2" -p "SSTP Client2: Please enter name for connection: " input
SSTPCONAME2="${input:-$SSTPCONAME2}"
echo " "
SSTPIP2="78."
read -e -i "$SSTPIP2" -p "SSTP Client2: Please enter the SSTP Server IP: " input
SSTPIP2="${input:-$SSTPIP2}"
echo " "
SSTPORT2="443"
read -e -i "$SSTPORT2" -p "SSTP Client2: Please enter the SSTP Server Port: " input
SSTPORT2="${input:-$SSTPORT2}"
echo " "
USERNAME2=""
read -e -i "$USERNAME2" -p "SSTP Client2: Please enter username: " input
USERNAME2="${input:-$USERNAME2}"
echo " "
PASSWORD2=""
read -e -i "$PASSWORD2" -p "SSTP Client2: Please enter password: " input
PASSWORD2="${input:-$PASSWORD2}"

# Client2.sh
touch /sstp/client2.sh
sleep 1
cat <<EOF > /sstp/client2.sh
#!/bin/bash
client_name2=$SSTPCONAME2
user=$USERNAME2
pass=$PASSWORD2
server=$SSTPIP2
port=$SSTPORT2

sstpc --cert-warn --save-server-route --user \$user --password \$pass \$server:\$port usepeerdns require-mschap-v2 noauth noipdefault ifname \$client_name2

EOF

chmod +x /sstp/client2.sh

# SSTP1 CONNECT2.SH
touch /sstp/connect2.sh
cat <<EOF > /sstp/connect2.sh
#!/bin/bash
CLIENT_FILE2=/sstp/client2.sh
CLIENT_NAME2=\`sed -n -e '/client_name2/{s/.*= *//p}' \$CLIENT_FILE2 | sed  's/.*"\(.*\)".*/\1/'\`
HOST_PING2=8.8.8.8
echo " \$CLIENT_NAME2 ------------------------------------"
HTT2=\`ip address show label $CLIENT_NAME2 | grep inet | awk '{print \$2}'\`
if [ -n "\$HTT2" ] ;

        then
                echo " \$CLIENT_NAME2: Interface Check:           [OK]"

                # check for pinging
                PINGTEST2=\`ping -I \$CLIENT_NAME2 -qc2 \$HOST_PING2 2>&1 | awk -F'/' 'END{ print (/^rtt/? "1":"0") }'\`
                if [ \$PINGTEST2 = 1 ] ; then
                                echo " \$CLIENT_NAME2: PING Check:                        [OK]"
                                exit
                        else
                                # IF NO RESPONCE
                                echo " \$CLIENT_NAME2: PING Check:                        [ERROR]"
                fi

fi

echo " \$CLIENT_NAME2: Interface Check:            [ERROR]"
# IF NO RESPONCE
# KILLING LAST CONNECTION IF EXISTS
# KILLING LAST CONNECTION IF EXISTS
SSTPID2=\`ps -ef | grep sstpc | grep \$CLIENT_NAME2 | awk '{print \$2}'\`
kill -9 \$SSTPID2
sleep 1

echo "\$CLIENT_NAME2: STARTING SSTP CONNECTION"
# RUNNING CONNECTING SCRIPT SILENTLY
bash \$CLIENT_FILE2 </dev/null &>/dev/null &

EOF

chmod +x /sstp/connect2.sh

echo ""
echo "Run SSTP Client2?"
echo ""
until [[ $SSTP2_RUN =~ (y|n) ]]; do
read -rp "Run SSTP Connection: $SSTPCONAME2 ? [y/n]: " -e -i y SSTP2_RUN
done

if [[ $SSTP2_RUN == "y" ]]; then
echo ""
echo " Running $SSTPCONAME2 "
bash /sstp/connect2.sh
else
echo " you can test connection using these command"
echo "bash /sstp/connect2.sh"
fi
;;
##############################


# DHCP SERVER
"DHCP Server")
if test -f "/Golden1/dhcp-server.sh";
then
bash /Golden1/dhcp-server.sh
else
mkdir -p /Golden1
cd /Golden1
curl -O https://raw.githubusercontent.com/ExtremeDot/ubuntu-dhcp-server/master/dhcp-server.sh
chmod +x /Golden1/dhcp-server.sh
bash /Golden1/dhcp-server.sh
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
exit 0
;;

# WRONG INPUT
*) echo "invalid option $REPLY"
;;
esac

# DONE
done

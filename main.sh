#!/bin/bash
DOTDIR=/dot_router
mkdir -p $DOTDIR
clear
echo "G O L D E N   D O T   R O U T E R  - Version:1.001"
echo "----------------------------------------"
PS3=" $(echo $'\n'-----------------------------$'\n' "   Enter Option: " ) "
echo ""
options=( "DHCP Server" "Install SSTP Client" "Setup SSTP Client1" "CLEAR" "UPDATE" "Quit")
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
SSTPCONAME1="sstp88"
read -e -i "$SSTPCONAME1" -p "SSTP CLient1: Please enter name for connection: " input
SSTPCONAME1="${input:-$SSTPCONAME1}"
echo " "
SSTPIP1="100.101.102.103"
read -e -i "$SSTPIP1" -p "SSTP CLient1: Please enter the SSTP Server IP: " input
SSTPIP1="${input:-$SSTPIP1}"
echo " "
SSTPORT1="443"
read -e -i "$SSTPORT1" -p "SSTP CLient1: Please enter the SSTP Server Port: " input
SSTPORT1="${input:-$SSTPORT1}"
echo " "
USERNAME1="name"
read -e -i "$USERNAME1" -p "SSTP CLient1: Please enter username: " input
USERNAME1="${input:-$USERNAME1}"
echo " "
PASSWORD1="pass"
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
CLIENT_FILE=/sstp/client1.sh
CLIENT_NAME=`sed -n -e '/client_name/{s/.*= *//p}' \$CLIENT_FILE | sed  's/.*"\(.*\)".*/\1/'`
HOST_PING=8.8.8.8
echo " \$CLIENT_NAME ------------------------------------"
HTT=ifconfig \$CLIENT_NAME 1</dev/null
if \$HTT ;
        then
                echo " \$CLIENT_NAME: Interface Check:           [OK]"

                # check for pinging
                PINGTEST=ping -I \$CLIENT_NAME -qc2 \$HOST_PING 2>&1 | awk -F'/' 'END{ print (/^rtt/? "1":"0") }'
                if [ \$PINGTEST = 1 ] ; then
                                echo " \$CLIENT_NAME: PING Check:                        [OK]"
                                exit
                        else
                                # IF NO RESPONCE
                                echo " \$CLIENT_NAME: PING Check:                        [ERROR]"
                fi

fi

echo " \$CLIENT_NAME: Interface Check:            [ERROR]"
# IF NO RESPONCE
# KILLING LAST CONNECTION IF EXISTS
kill -9 ps -ef | grep sstpc | grep \$CLIENT_NAME | awk '{print \$2}'
sleep 1

echo "\$CLIENT_NAME: STARTING SSTP CONNECTION"
# RUNNING CONNECTING SCRIPT SILENTLY
sudo bash \$CLIENT_FILE </dev/null &>/dev/null &

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
curl -O https://raw.githubusercontent.com/ExtremeDot/DOT_ROUTER/master/main.sh
chmod +x /tmp/main.sh
cp /tmp/main.sh /bin/dotrouter
chmod +x /bin/dotrouter
exit 0
;;

# WRONG INPUT
*) echo "invalid option $REPLY"
;;
esac

# DONE
done

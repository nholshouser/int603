#!/bin/bash

# connect to server and start performance monitor agent

# check connection
# enter the correct certificate for login
echo -e "Enter the Server Ceertificate for connection"
ls -1 CERTS/*.ppk
echo ""
read CERTIFICATE

# enter server IP
echo -e "Enter server IP Address"
read SERVER_IP

export CERTIFICATE
export SERVER_IP

# Start performance agent
echo " starting performance agent"
echo "CERTS/plink.exe root@${SERVER_IP} -i ${CERTIFICATE} 'bash /hana/shared/agent/startAgent'"
CERTS/plink.exe root@${SERVER_IP} -i ${CERTIFICATE} 'bash /hana/shared/agent/startAgent'
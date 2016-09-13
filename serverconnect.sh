#/bin/bash

# connect to server and start performance monitor agent

# check connection
# enter the correct certificate for login
echo -e "Enter the Server Ceertificate for connection"
ls -1 CERTS/*.ppk
read CERTIFICATE

# enter server IP
echo ""
echo -e "Enter server IP Address"
read SERVER_IP

export CERTIFICATE
export SERVER_IP

# check connection with simple command
echo "CERTS/plink.exe root@${SERVER_IP} -i ${CERTIFICATE} 'df -h'"
CERTS/plink.exe root@${SERVER_IP} -i ${CERTIFICATE} 'df -h'
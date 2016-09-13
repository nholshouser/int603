#/bin/bash

# setup the working directory
# directory csv needs to exist
# CERT/* need 'chmod 600'
# scrtipts/* need 'chmod 755'
# chmod 755 jmeter30/apache-jmeter-3.0/bin/jmeter

echo "###################################################"
echo "Setting up directory for testing"
echo "Create csv directory"
mkdir csv
ls -al | grep csv

echo "###################################################"
echo "Setting permissions on certificates"
chmod 600 CERTS/*.ppk
chmod 600 CERTS/*.pem
ls -al CERTS/

echo "###################################################"
echo "Setting permissions on all scripts"
chmod 755 scripts/*.sh
ls -al scripts

echo "###################################################"
echo "Unzipping JMeter"
unzip jmeter30.zip

echo "###################################################"
echo "Setting permission on jmeter30/apache-jmeter-3.0/bin/jmeter"
chmod 755 jmeter30/apache-jmeter-3.0/bin/jmeter
chmod 755 jmeter30/apache-jmeter-3.0/bin/jmeter.sh

echo "###################################################"
echo "All setup complete"




#!/bin/bash

# Assumption we are using Ubuntu precise 64 bits (12.04)

# First we update apt
sudo apt-get update

# Install tomcat
sudo apt-get install tomcat6 -y



# Download Solr 3.6.1 in the the directory and extract install
mkdir -p /tmp/solr/
cd /tmp/solr/

wget http://archive.apache.org/dist/lucene/solr/3.6.1/apache-solr-3.6.1.tgz
tar xvf apache-solr-3.6.1.tgz

# check for solr base directory, if not create it
if [ ! -d "/var/solr" ]; then
  # create the Solr base directory
  mkdir /var/solr
fi

# Copy the Solr webapp and the example multicore configuration files:
sudo cp apache-solr-3.6.1/dist/apache-solr-3.6.1.war /var/solr/solr.war
sudo cp -R apache-solr-3.6.1/example/multicore/* /var/solr/

# set filepermissions to Tomcat user
sudo chown -R tomcat6 /var/solr/

# Configure Catalina with our Solr base directory
echo -e '<Context docBase="/var/solr/solr.war" debug="0" privileged="true" allowLinking="true" crossContext="true">\n<Environment name="solr/home" type="java.lang.String" value="/var/solr" override="true" />\n</Context>' | sudo tee -a /etc/tomcat6/Catalina/localhost/solr.xml

# activate the following line if you have access problems
#echo 'TOMCAT6_SECURITY=no' | sudo tee -a /etc/default/tomcat6

#restart the Tomcat server
sudo service tomcat6 restart

#!/bin/sh
#sudo su

find /usr/share/tomcat/logs -type f -name '*.log' -delete
find /usr/share/tomcat/logs -type f -name '*.txt' -delete
find /usr/share/tomcat/logs -type f -name '*.out' -delete
touch -f /usr/share/tomcat/logs/catalina.out
chown tomcat:tomcat  /usr/share/tomcat/logs/catalina.out
chmod 755 /usr/share/tomcat/logs/catalina.out
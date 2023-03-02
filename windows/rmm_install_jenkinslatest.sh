#!/bin/sh
#sudo su
exec 1> >(logger -s -t $(basename $0)) 2>&1

#SO FAR WE MAINTAIN SUPPORT FOR THESE SYSTEMS
#buildxsl instance-id: i-8c7a56a7
#jenkins instance-id: i-d4db024d

#Get the instance name using the above tool
instancename=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
instanceregion=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

#jenkins
if [ "$instancename" == "i-123" ]
then
	echo $instancename
	echo "JENKINS UPGRADE script has started a job for $instancename."
    mkdir -p /DATA/ops/temp
    mv -v /usr/share/tomcat/webapps/jenkins.war /DATA/backup_server/jenkins-$(date -d "today" +"%Y%m%d%H%M").war
    find /DATA/ops/temp -type f -name 'jenkins.war' -delete
    wget -N http://mirrors.jenkins.io/war/latest/jenkins.war -P /DATA/ops/temp
    chown -R tomcat.tomcat /DATA/ops/temp/jenkins.war

    sleep 10

    if [ ! -d "/usr/share/tomcat/webapps/jenkins" ]; then

        mv -v /DATA/ops/temp/jenkins.war /usr/share/tomcat/webapps/

    fi

#buildxsl
elif [ "$instancename" == "i-1234" ]
then
	echo $instancename
	echo "JENKINS UPGRADE script has started a job for $instancename."
    sudo yum update –y
    sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
    sudo rpm — import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
    sudo yum update jenkins -y

 else
	echo "JENKINS UPGRADEE script has found there are no tasks configured for $instancename."

fi

#!/bin/bash
# A menu driven corp Cloud setup script
#
# wget -N https://url/s//buildcloud.sh -P /home/user/
# chmod +x /home/user/buildcloud.sh
# /home/user/buildcloud.sh
#
## ----------------------------------
# Step #1: Define variables
# ----------------------------------
EDITOR=vim
PASSWD=/etc/passwd
RED='\033[0;41;30m'
STD='\033[0;0;39m'

# ----------------------------------
# Step #2: User defined function
# ----------------------------------
pause(){
  thisHost=$(hostname)
  now=$(date +"%Y-%m-%d-%H-%M-%S")
  read -p "Press [Enter] key to continue..." fackEnterKey
}

# simple function to check http response code before downloading a remote file
# example usage:
# if `validate_url $url >/dev/null`; then dosomething; else echo "does not exist"; fi
function validate_url(){
  if [[ `wget -S --spider $1  2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then echo "true"; fi
}

# do something in sample()
sample(){
	echo "================================================================="
	echo "sample"


	#notification and escape block
		#functionInfo = ${FUNCNAME[*]}
		#functionInfoNotes="." #extra notes
		#notifySlack "${functionInfoNotes}"
	#end notification stack

	pause

}

notifySlack(){
	echo "================================================================="
	echo "Slack Notification is being sent."
	thisHost=$(hostname)
	i=$1
	functions=${FUNCNAME[*]}
	curl -X POST --data-urlencode 'payload={"channel": "#cloud_ops", "username": "webhookbot", "text": "'"$thisHost"' is presently undergoing maintenance.\n DETAILS: '"${i}"'.\n", "icon_emoji": ":crystal_ball:"}' https://hooks.slack.com/services/HIDDEN
	#curl -X POST --data-urlencode 'payload={"channel": "#cloud_ops", "username": "webhookbot", "text": "'"$thisHost"' is presently undergoing maintenance.\n DETAILS: '"${i}"'.\n Functions: '"${functions}"'", "icon_emoji": ":crystal_ball:"}' https://hooks.slack.com/services/HIDDEN
}

actionJava(){
  #UPDATED FOR JDK 10
  #wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/10.0.1+10/fb4372174a714e6b8c52526dc134031e/jdk-10.0.1_linux-x64_bin.tar.gz
  #
  #UPDATED FOR JDK 9 it looks like you can download it now directly from java.net without sending a header
  #wget http://download.java.net/java/GA/jdk9/9/binaries/jdk-9+181_linux-x64_bin.tar.gz
  #
  #UPDATED FOR JDK 8u151
  #wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.tar.gz
  #
  #UPDATED FOR JDK 8u151
  #wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.rpm"

	echo "================================================================="
	echo "Testing Java version."
	java -version
  rpm -qa | grep -E 'jdk'
	echo "Install OpenJDK via Amazon Corretto."
	echo "Do you wish to proceed with this action? 1 for YES, 2 for NO."
	read -n1 -p "[1,2]. . . . . :" actionJavaVar
	if [ "$actionJavaVar" == "1" ]
	then
    sudo amazon-linux-extras enable corretto8
    sudo yum -y install java-1.8.0-amazon-corretto
    sudo yum -y install java-1.8.0-amazon-corretto-devel
    sudo alternatives --config java
    sudo alternatives --config javac
  	echo "hope that worked"
  	read -p "Press [Enter] to continue..."
	#sudo ln -sfn /usr/java/jdk$javaversion java_sdk
	#sudo ln -sfn /usr/java/jdk$javaversion/jre jre
	else "Looks like you chose to skip this step. Press any key to continue..."
	fi
	pause
}

actionWebMin(){
	echo "================================================================="
	echo "Install WebMin management GUI for administering the server."
	wget -N  http://prdownloads.sourceforge.net/webadmin/webmin-1.920-1.noarch.rpm -P /home/user/
	sudo yum -y install perl perl-Net-SSLeay openssl perl-IO-Tty perl-Encode-Detect perl-Data-Dumper
	sudo rpm -U /home/user/webmin-1.920-1.noarch.rpm
	echo "Please specify WebMin root password:"
	read varWebMinPassword
	/usr/libexec/webmin/changepass.pl /etc/webmin root $varWebMinPassword
	pause

}

actionSSL(){
	echo "================================================================="
	echo "Download and save our SSL certificates for corp.NET"
	mkdir -P /DATA/SSL

	pause

}

actionHTTPD(){
	echo "================================================================="
	echo "Setting up all HTTPD Services with default configurations for Cloud including SSL and redirect."
	sudo yum groupinstall "Web Server"
	wget -N https://url/s//httpd.conf -P /etc/httpd/conf/
	wget -N https://url/s//ssl.conf -P /etc/httpd/conf.d/
	echo "${RED}Apache was pre-loaded with defaults. Remember to edit the files because all proxy redirects are presently INCORRECT!${STD}"
	pause

}

actionTomcatuser(){
	echo "================================================================="
	echo "Setting up Tomcat User only; creates a user."
	groupadd tomcat
	useradd -s /sbin/nologin -g tomcat tomcat
	sudo chsh -s /bin/bash tomcat
	pause

}

actionTomcat(){
	echo "================================================================="
	echo "This routine will give you multiple choices to reconfigure Tomcat."
	#notification and escape block
	#functionInfo = ${FUNCNAME[*]}
	#functionInfoNotes="Tomcat server for corp is undergoing maintenance. This outage may last several minutes or longer. Please stay tuned." #extra notes
	#notifySlack "${functionInfoNotes}"
	#end notification stack

	stopcorpTomcat
	stopcorpTomcat

	while true
	do
		actionTomcat_showMenu
		actionTomcat_readOptions
	done
}

actionTomcat_showMenu(){
	clear
	echo "Which install sequence do you wish to run?:"
	echo "a) Install clean download and install from our repository; you can choose only available versions."
	echo "b) Install ready-to-go tar.gz package with preconfigured files."
	echo "c) Swap Tomcat installations by updating /usr/local/share links."
	echo "d) Create Tomcat Startup Item."
	echo "e) Refresh Tomcat configuration files."
	echo "z) Debug this menu."
	echo "x) Exit."
}



actionTomcat_readOptions(){
	local selectSequence
	read -p "Enter choice [ a - x] " selectSequence
	case $selectSequence in
		a) actionTomcat_sub_A ;;
		b) actionTomcat_sub_B ;;
		c) actionTomcat_sub_C ;;
		d) actionTomcat_sub_D ;;
		e) actionTomcat_sub_E ;;
		z) actionTomcat_sub_Z ;;
		x) break ;;
		xxx) exit 0 ;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac

}

actionTomcat_sub_A(){
	echo "Replacing Tomcat Installation"
	echo "Specify Tomcat Version."
	echo "Tomcat installations are sourced from FTP/s3buckets/corp-shared-out/Tomcat."
	read -p "Type the Tomcat version you want to use, ie: 8.5.6. . . . . :" versionTomcat

	 if [[ `wget -S --spider http://url/Tomcat/apache-tomcat-$versionTomcat.tar.gz  2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then
	 	echo "File check passed. Downloading source file."
	 	wget -N  http://url/Tomcat/apache-tomcat-$versionTomcat.tar.gz -P /opt/
	 	tar -zxvf /opt/apache-tomcat-$versionTomcat.tar.gz -C /opt
		#now call a procedure to map /usr/share/tomcat
		actionTomcat_sub_C #symlink for /usr/share/tomcat
		actionTomcat_sub_E  #reload all the config files
		#startup item gets an IF!
		actionTomcat_sub_D  #startup item
	else
		echo "FAILED to detect Tomcat source file at:"
		echo "http://url/Tomcat/apache-tomcat-$versionTomcat.tar.gz"
		echo "Please upload the file."
		echo "See https://wiki.corp.com/display/Infrastructure/Apache+Tomcat+Baseline+for+corp+Systems+and+Cloud for help."
	 fi
	pause
}

actionTomcat_sub_B(){
	echo "Replacing Tomcat Installation"
	echo "Specify Tomcat Version."
	read -p "Paste the download link to your tar.gz file. . . . . :" downloadlinkTomcat
	wget -N  $downloadlinkTomcat -P /opt/
	ls -l /opt
	read -p "What is the name of your tar.gz file? . . . . :" zipfilenameTomcat
	tar -zxvf /opt/$zipfilenameTomcat -C /opt
	#now call a procedure to map /usr/share/tomcat
	actionTomcat_sub_C
	#startup item gets an IF!
	actionTomcat_sub_D
	pause
}

actionTomcat_sub_C(){
	echo "Repointing the /usr/share/tomcat symlink"
	rm -f /usr/share/tomcat
	ls -l /opt
	read -p "What is the name of your Tomcat directory?. . . . :" shareTomcatLink
	ln -s /opt/$shareTomcatLink /usr/share/tomcat
	chown tomcat.tomcat /usr/share/tomcat -R
	chown tomcat.tomcat /usr/share/tomcat/* -R
	pause
}

actionTomcat_sub_D(){
	echo "Do you need to rebuilt the Linux Startup Item? [Y,n]"
		read input
		if [[ $input == "Y" || $input == "y" ]]; then
			wget -N https://url/s//1tomcat -P /etc/init.d/
			chown tomcat.tomcat /etc/init.d/1tomcat
			chmod +775 /etc/init.d/1tomcat
			sudo ln -s /etc/init.d/1tomcat /etc/rc5.d/S71tomcat

		else
			echo "Not touching startup items."

	fi
	pause
}

actionTomcat_sub_E(){
	echo "Starting configuration overrides."
	mkdir -p /DATA/backup_server
	ls -l /DATA/backup_server
	mv -v /usr/share/tomcat/conf/tomcat-users.xml /DATA/backup_server/$thisHost.$now.tomcat-users.xml
	mv -v /usr/share/tomcat/conf/server.xml /DATA/backup_server/$thisHost.$now.server.xml
	mv -v /usr/share/tomcat/conf/web.xml /DATA/backup_server/$thisHost.$now.web.xml
	mv -v /usr/share/tomcat/bin/catalina.sh /DATA/backup_server/$thisHost.$now.catalina.sh
	mv -v /usr/share/tomcat/bin/setenv.sh /DATA/backup_server/$thisHost.$now.setenv.sh
	mv -v /usr/share/tomcat/bin/startup.sh /DATA/backup_server/$thisHost.$now.startup.sh
	mv -v /usr/share/tomcat/conf/Catalina/localhost/manager.xml /DATA/backup_server/$thisHost.$now.manager.xml
	wget -N  https://url/s//tomcat-users.xml -P /usr/share/tomcat/conf/
	wget -N  https://url/s//server.xml -P /usr/share/tomcat/conf/
	wget -N  https://url/s//web.xml -P /usr/share/tomcat/conf/
	wget -N  https://url/s//manager.xml -P /usr/share/tomcat/conf/Catalina/localhost/
	wget -N  https://url/s//catalina.sh -P /usr/share/tomcat/bin/
	wget -N  https://url/s//setenv.sh -P /usr/share/tomcat/bin/
	wget -N  https://url/s//startup.sh -P /usr/share/tomcat/bin/
	chown tomcat.tomcat /usr/share/tomcat/conf/server.xml
	chown tomcat.tomcat /usr/share/tomcat/conf/tomcat-users.xml
	chown tomcat.tomcat /usr/share/tomcat/conf/web.xml
	chown tomcat.tomcat /usr/share/tomcat/conf/Catalina/localhost/manager.xml
	chown tomcat.tomcat /usr/share/tomcat/bin/catalina.sh
	chown tomcat.tomcat /usr/share/tomcat/bin/setenv.sh
	chown tomcat.tomcat /usr/share/tomcat/bin/startup.sh
	chmod +x /usr/share/tomcat/bin/*.sh
	echo "Take a look at the backups..."
	ls -l /DATA/backup_server
	pause
}


actionTomcat_sub_Z(){
	echo "Debug seems OK. You should get a pause and then the Tomcat install menu."
	pause
}


actioncorp(){
	echo "================================================================="
	echo "Setting up corp 8."
	#start corp Tomcat, as it is required for this procedure.
	#first, we do a nice clean restart - always a good way to begin an update.
	stopcorpTomcat
	#then, we fire things up.  Once ready, we roll forward.
	startcorpTomcat

	#notification and escape block
	functionInfo = ${FUNCNAME[*]}
	functionInfoNotes="corp application maintenance is starting on this system.  corp console will be down for several minutes.  Please check back soon. " #extra notes
	notifySlack "${functionInfoNotes}"
	#end notification stack


	read -p "How many seconds should I nap for?: " -e -i 20 naptime
	echo "Backing up existing ROOT.war file.  Here is what we currently have available:"
	mkdir -p /DATA/backup_server
	ls -l /DATA/backup_server
	cp -v /usr/share/tomcat/webapps/ROOT.war /DATA/backup_server/$thisHost.$now.ROOT.war
	echo "Is this a REFRESH-UPGRADE-REINSTALL or are you doing a completely brand new install? Default answer is Y, [Y,n]"
		read input
		if [[ $input == "Y" || $input == "y" ]]; then
			# now deploy the latest ROOT.WAR file.
			actioncorp_sub1
		else
			echo "Safety check, because I don't trust myself. If the zip is present, then we skip this step."
			FILE=/usr/local/corp/bin_cloud.zip
				if [ -f $FILE ];
				then
				   echo "File $FILE exists.  Cannot execute function."
				   echo "sleeping 10 seconds"
				   sleep 10
				else
				   echo "File $FILE does not exist."
				   echo "Brand new installation, here we go!"
				   mkdir /usr/local/corp
					chown tomcat.tomcat /usr/local/corp
					wget -N  https://url/s//bin_cloud.zip -P /usr/local/corp/
					unzip /usr/local/corp/bin_cloud.zip -d /usr/local/corp/
					rm -rf /usr/local/corp/__MACOSX
					chown tomcat.tomcat /usr/local/corp/*
					# now deploy the latest ROOT.WAR file.
					actioncorp_sub1
				fi
	fi

}


#sub-action for grabbing the corp ROOT.war file
actioncorp_sub1(){
	echo "Use the warserver bucket? [Y,n]"
	read input
	if [[ $input == "Y" || $input == "y" ]]; then
		mkdir -p /home/user/rootTemp
		cp -v /DATA/warserver/ROOT.war /home/user/rootTemp/ROOT.war
		chown tomcat.tomcat /home/user/rootTemp/ROOT.war
		chmod 755 /home/user/rootTemp/ROOT.war
		rm -rfv /usr/share/tomcat/webapps/ROOT.war
		ls -l /usr/share/tomcat/webapps
		echo "taking a nap for $naptime seconds"
		sleep $naptime
		echo "all rested"
		ls -l /usr/share/tomcat/webapps/
		echo "ROOT folder should be gone, but we'll nap another $naptime seconds."
		sleep $naptime
		echo "new file coming through!"
		mv -v /home/user/rootTemp/ROOT.war /usr/share/tomcat/webapps/ROOT.war
	else
		echo "Please paste a direct download link for the latest ROOT.WAR file:"
		read varROOT
		wget -N  $varROOT -P /usr/share/tomcat/webapps/
		chown tomcat.tomcat /usr/share/tomcat/webapps/ROOT.war
		chmod 755 /usr/share/tomcat/webapps/ROOT.war
		echo "taking a nap for $naptime seconds"
		sleep $naptime
	fi
}

actionSamba(){
	echo "================================================================="
	echo "Install SAMBA File Server."
	yum install samba

	echo "Do you want to configure SAMBA server using our custom smb.conf? [Y,n]"
	read input
	if [[ $input == "Y" || $input == "y" ]]; then
		actionSambaConfig
	else
		echo "Nothing to do."

	fi
	pause
}

actionSambaConfig(){
	echo "================================================================="
	echo "Configure SAMBA File Server; uses our specific configuration file."
	/etc/rc.d/init.d/smb stop ; /etc/rc.d/init.d/nmb stop
	wget -N https://url/s//smb.conf -P /etc/samba/
	echo "Configuration assumes FileStore location.  Edit smb.conf to change."

	echo "Do you want to start SAMBA server? [Y,n]"
	read input
	if [[ $input == "Y" || $input == "y" ]]; then
		startSAMBA
	else
		echo "Nothing to do."

	fi
	pause
}

actionFuse(){
	echo "================================================================="
	echo "FUSE file system for S3 buckets."
	yum remove fuse fuse-s3fs
	yum install fuse-libs
	yum install gcc libstdc++-devel gcc-c++ curl-devel libxml2-devel openssl-devel mailcap
	wget -N https://url/s//fuse-2.9.3.tar.gz -P /usr/src/
	tar xzf /usr/src/fuse-2.9.3.tar.gz -C /usr/src
	chmod +x /usr/src/fuse-2.9.3/configure
	/usr/src/fuse-2.9.3/configure --prefix=/usr
	make && make install
	export PKG_CONFIG_PATH=/usr/lib/pkgconfig
	ldconfig
	modprobe fuse
	read -p "${RED}FUSE complete, review output and press [Enter] to move forward...${STD}"
	wget -N https://url/s//s3fs-1.74.tar.gz -P /usr/src/
	tar xzf /usr/src/s3fs-1.74.tar.gz -C /usr/src
	chmod +x /usr/src/s3fs-1.74/configure
	/usr/src/s3fs-1.74/configure --prefix=/usr
	make && make install
	read -p "${RED}S3FS complete, review output and press [Enter] to move forward...${STD}"
	echo "user_allow_other" > '/etc/fuse.conf'
	pause

}

actionAWScred1(){
	echo "================================================================="
	echo "Set DEFAULT Amazon Access Credentials."
	echo "Specify AWS Key"
	read -p "Type the AWS KEY. . . . . :" awsKEY
	echo "Specify AWS Secret"
	read -p "Type AWS Secret. . . . . :" awsSECRET
	echo $awsKEY:$awsSECRET > ~/.passwd-s3fs
	chmod 600 ~/.passwd-s3fs
	pause

}

actionAWScred2(){
	echo "================================================================="
	echo "Set Advanced Amazon Access Credentials.  These must be supplied during the mount."
	ls -l /etc/passwd*
	echo "Type the name of the credential file you want to create."
	read -p "/etc/passwd-s3fs-" credentialFileName
	echo "Will create /etc/passwd-s3fs-$credentialFileName."
	echo "Specify AWS Key"
	read -p "Type the AWS KEY. . . . . :" awsKEY
	echo "Specify AWS Secret"
	read -p "Type AWS Secret. . . . . :" awsSECRET
	echo $awsKEY:$awsSECRET > /etc/passwd-s3fs-$credentialFileName
	chmod 600 /etc/passwd-s3fs-$credentialFileName
	echo "Operation completed."
	ls -l /etc/passwd*
	pause

}

actionAWSbucket(){
	echo "================================================================="
	echo "Mount a bucket using the simplest settings in /DATA/. "
	echo "Check out what's already there:"
	ls -l /DATA
	echo "Specify bucket name, ie: warserver."
	read -p "Bucket name. . . . . :" mntBucket
	echo "Check it out!  We are mounting on /DATA/$mntBucket"
	echo "Do you wish to proceed with this action? 1 for YES, 2 for NO."
	read -n1 -p "[1,2]. . . . . :" yesMount
	if [ "$yesMount" == "1" ]
	then
		mkdir -p /DATA/$mntBucket
		chmod 600 /DATA/$mntBucket
		s3fs $mntBucket  /DATA/$mntBucket  -o allow_other
		echo "mission accomplished, but did it work? Look for output"
		ls -l /DATA/$mntBucket
		pause
	else
		echo "skipping"
		pause
	fi
}

actionAWSbetter(){
	echo "================================================================="
	echo "Sorry, I dropped this. Nothing gonna happen."
	pause
}

actionAWScustomCreds(){
	echo "================================================================="
	echo "Mount a bucket using the custom parameters?"
	echo "Specify bucket name, ie: warserver."
	read -p "Bucket name. . . . . :" mntBucket
	echo "Specify bucket name, ie: warserver."
	read -p "Now provide the full path to the folder we are mounting on, ei /usr/local/corp/plugins. . . . . :" mntFolder
	echp "Does this look right? Check."
	ls -l mntFolder
	echo "Now review password files."
	ls -l /etc/passwd*
	echo "Type the name of the credential file you want to use:"
	read -p "/etc/passwd-s3fs-" credentialFile
	echo "Check it out!  We are mounting $mntBucket on /DATA/$mntBucket and the /etc/passwd-s3fs-$credentialFile."
	echo "Do you wish to proceed with this action? 1 for YES, 2 for NO."
	read -n1 -p "[1,2]. . . . . :" yesMount
	if [ "$yesMount" == "1" ]
	then
		mkdir -p $mntFolder
		chmod 600 $mntFolder
		s3fs $mntBucket $mntFolder  -o allow_other -o passwd_file=/etc/passwd-s3fs-$credentialFile
		echo "mission accomplished, but did it work? Look for output"
		ls -l /DATA/$mntBucket
		pause
	else
		echo "skipping"
		pause
	fi
}

actionFuseBoot(){
	echo "================================================================="
	echo "Create a S3FS Fuse entry"
	touch /etc/init.d/s3fs || exit
	chmod +775 /etc/init.d/s3fs
	ln -s /etc/init.d/s3fs /etc/rc5.d/s3fs
	echo "#example: s3fs $mntBucket $mntFolder  -o allow_other -o passwd_file=/etc/passwd-s3fs-$credentialFile\n" >> /etc/init.d/s3fs
	echo "Now opening the startup file. Use :q or :wq to exit or save and exist."
	cat /etc/init.d/s3fs
	pause

}

actionMountKnownBuckets(){
	echo "================================================================="
	echo "Expedite mounting of common s3 buckets."
	echo "user_allow_other" > '/etc/fuse.conf'
	ls -l /DATA
	mkdir -p /DATA/warserver
	chmod 600 /DATA/warserver
	s3fs warserver /DATA/warserver -o allow_other -o passwd_file=/etc/passwd-s3fs-warserver

	mkdir -p /DATA/warfiles
	chmod 600 /DATA/warfiles
	s3fs warfiles /DATA/warfiles -o allow_other -o passwd_file=/etc/passwd-s3fs-warfiles
	ls -l /DATA
	pause
}

actionAWSbucketAdmin(){
	#Only works on admin server and requires different keys and ACL.
	echo "================================================================="
	echo "Expedite mounting of admin server s3 buckets."
	ls -l /usr/local/corp/admin
	echo "user_allow_other" > '/etc/fuse.conf'
	sudo su -c "s3fs warfiles /usr/local/corp/admin/plugins -o allow_other" -s /bin/sh tomcat
	ls -l /usr/local/corp/admin
	pause
}

actionRelaodAllcorpPlugins(){
	echo "================================================================="
	echo "Mother of...  what have you done?! All plugins being reloaded."

	#start Tomcat if not running; this action requires Tomcat Manager to autodeploy.
	startcorpTomcat

	rm -rf `find /usr/share/tomcat/webapps -name "*.war" ! -name "ROOT.war"`

	#notification and escape block
	functionInfo = ${FUNCNAME[*]}
	functionInfoNotes="An administrator is currently reinstalling all corp Actions/Plugins.  System will be unable to process workflows for a few minutes." #extra notes
	notifySlack "${functionInfoNotes}"
	#end notification stack

	echo "sleep for 20 seconds"
	sleep 20
	echo "awake"

	#plugin="corp-plugin-"
	#file=$(ls /DATA/warfiles/$plugin -t | head -1)
	#cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	#chmod 600 /usr/share/tomcat/webapps/$file

	plugin="corp-plugin-ant"
	file=$(ls /DATA/warfiles/$plugin -t | head -1)
	cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	chmod 600 /usr/share/tomcat/webapps/$file

	#plugin="corp-plugin-dita"
	#file=$(ls /DATA/warfiles/$plugin -t | head -1)
	#cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	#chmod 600 /usr/share/tomcat/webapps/$file

	#plugin="corp-plugin-docbook"
	#file=$(ls /DATA/warfiles/$plugin -t | head -1)
	#cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	#chmod 600 /usr/share/tomcat/webapps/$file

	plugin="corp-plugin-docx"
	file=$(ls /DATA/warfiles/$plugin -t | head -1)
	cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	chmod 600 /usr/share/tomcat/webapps/$file

	#plugin="corp-plugin-edgar"
	#file=$(ls /DATA/warfiles/$plugin -t | head -1)
	#cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	#chmod 600 /usr/share/tomcat/webapps/$file

	plugin="corp-plugin-epub"
	file=$(ls /DATA/warfiles/$plugin -t | head -1)
	cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	chmod 600 /usr/share/tomcat/webapps/$file

	plugin="corp-plugin-id"
	file=$(ls /DATA/warfiles/$plugin -t | head -1)
	cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	chmod 600 /usr/share/tomcat/webapps/$file

	#plugin="corp-plugin-isosts"
	#file=$(ls /DATA/warfiles/$plugin -t | head -1)
	#cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	#chmod 600 /usr/share/tomcat/webapps/$file

	plugin="corp-plugin-jats"
	file=$(ls /DATA/warfiles/$plugin -t | head -1)
	cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	chmod 600 /usr/share/tomcat/webapps/$file

	#plugin="corp-plugin-md"
	#file=$(ls /DATA/warfiles/$plugin -t | head -1)
	#cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	#chmod 600 /usr/share/tomcat/webapps/$file

	#plugin="corp-plugin-nlm"
	#file=$(ls /DATA/warfiles/$plugin -t | head -1)
	#cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	#chmod 600 /usr/share/tomcat/webapps/$file

	#plugin="corp-plugin-runscript"
	#file=$(ls /DATA/warfiles/$plugin -t | head -1)
	#cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	#chmod 600 /usr/share/tomcat/webapps/$file

	#plugin="corp-plugin-spl"
	#file=$(ls /DATA/warfiles/$plugin -t | head -1)
	#cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	#chmod 600 /usr/share/tomcat/webapps/$file

	plugin="corp-plugin-util"
	file=$(ls /DATA/warfiles/$plugin -t | head -1)
	cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	chmod 600 /usr/share/tomcat/webapps/$file

	#plugin="corp-plugin-xls"
	#file=$(ls /DATA/warfiles/$plugin -t | head -1)
	#cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	#chmod 600 /usr/share/tomcat/webapps/$file

	plugin="corp-plugin-xsl"
	file=$(ls /DATA/warfiles/$plugin -t | head -1)
	cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	chmod 600 /usr/share/tomcat/webapps/$file




}


stopSAMBA(){
	echo "================================================================="
	echo "Stop SAMBA File Server (smb)."
	/etc/rc.d/init.d/smb stop ; /etc/rc.d/init.d/nmb stop
	pause
}

startSAMBA(){
	echo "================================================================="
	echo "Start SAMBA File Server (smb)."
	/etc/rc.d/init.d/smb start ; /etc/rc.d/init.d/nmb start
	pause
}



specialOperations(){
	echo "================================================================="

	while true
		do
			specialOperations_showMenu
			specialOperations_readOptions
		done

}

specialOperations_showMenu(){
	clear
	echo "Which special operation do you wish to run?:"
	echo "a) Migrate Alfresco to Local FileStore using corp CMS migration tool."
	echo "x) Back/Exit."
}



specialOperations_readOptions(){
	local selectSequence
	read -p "Enter choice [ a - x] " selectSequence
	case $selectSequence in
		a) specialOperations_sub_migrateCMS ;;
		x) break ;;
		xxx) exit 0 ;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac

}

specialOperations_sub_migrateCMS(){
	echo "Migrate Alfresco to FileStore on ${thisHost}"
	#collect important information
	read -p "Where is the local filestore? . . . : " -e -i /DATA/FileStore localFileStore

	if [ ! -f "$localFileStore/alfrescoMigration/migrationattemptedx.txt" ]

	then
		echo "Migration was previously not attempted on this system, moving forward."
		specialOperations_sub_migrateCMS_GO

	else
		echo "Previous migration attempt detect. Cannot continue."
		pause
	fi

}

specialOperations_sub_migrateCMS_GO(){

	#notification stage
	functionInfo = ${FUNCNAME[*]}
	functionInfoNotes="ALFRESCO to LOCAL FILESTORE migration is starting, expect minor interruptions to services. Data will take time to transfer -while- the system will remain ONLINE. A completion message will be displayed once finished." #extra notes
	notifySlack "${functionInfoNotes}"
	#end notification stack

	#prepare environment
	#stopcorpTomcat

	mkdir -p $localFileStore/alfrescoMigration
	touch $localFileStore/alfrescoMigration/migrationattempted.txt
	wget -N https://url/s//export.jar -P $localFileStore/alfrescoMigration
	chmod +x $localFileStore/alfrescoMigration/export.jar
	chmod 600 $localFileStore/alfrescoMigration/export.jar

	#run migration
	local selectCloudSystem
	read -p "Enter [cloud] for Cloud Production, enter [cloudsandbox] for Cloud Sandbox.  Enter [x] to go back. . . . . :" selectCloudSystem
	case $selectCloudSystem in
		cloudsandbox) specialOperations_sub_migrateCMS_cloudsandbox ;;
		cloud) specialOperations_sub_migrateCMS_cloud ;;
		x) break ;;
		xxx) exit 0 ;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac

	#update permissions
	chmod -R 777 $localFileStore

	notification stage
	functionInfo = ${FUNCNAME[*]}
	functionInfoNotes="DATA MIGRATION HAS COMPLETED ON THIS SYSTEM." #extra notes
	notifySlack "${functionInfoNotes}"
	end notification stack

	pause
}

specialOperations_sub_migrateCMS_cloudsandbox(){
	echo "cloudsandbox"
	corpHome="/usr/local/corp/corp-customers"

	#permissions
	chmod -R 777 $corpHome
	chown -R tomcat.tomcat $corpHome


	# Tomcat should be started up now, since we want to maximize system uptime.
	sleep 5
	service 1tomcat start

	# Alfresco Migration Kickoff!
	echo "T-minus 60 seconds to start.  Hold on to your pants."
	sleep 60
	DEBUG java -jar /DATA/FileStore/alfrescoMigration/export.jar user pass http:///alfresco/cmisatom code "/" /DATA//
	java -jar $localFileStore/alfrescoMigration/export.jar user pass http://1/alfresco/cmisatom code "/" /DATA//



}

specialOperations_sub_migrateCMS_cloud(){
	echo "cloud"
	corpHome="/usr/local/corp/corp-customers"
	#permissions
	chmod -R 777 $corpHome
	chown -R tomcat.tomcat $corpHome

	# Tomcat should be started up now, since we want to maximize system uptime.
	sleep 5
	service 1tomcat start

	# Alfresco Migration Kickoff!
	echo "T-minus 60 seconds to start.  Hold on to your pants."
	sleep 60
	java -jar $localFileStore/alfrescoMigration/export.jar corpcloud KnETONGz0g21O http:///alfresco/cmisatom ---- "/" /DATA//

}


actionInspectorInstall(){
	echo "================================================================="
	echo "Amazon Inspector, see https://docs.aws.amazon.com/inspector/latest/userguide/inspector_working-with-agents.html"
	wget -N https://d1wk0tztpsntt1.cloudfront.net/linux/latest/install
	bash install
	/opt/aws/awsagent/bin/awsagent status

	#notification and escape block
	functionInfo = ${FUNCNAME[*]}
	functionInfoNotes="Installed vulnerability and configuration inspector for advanced auditing of this system. This system is now better equipped to report possible security issues with processes, configurations, activity, and more." #extra notes
	notifySlack "${functionInfoNotes}"
	#end notification stack

	pause

}

restartTomcat(){
	echo "================================================================="
	echo "Restarting corp Tomcat service called 1tomcat."
	#notification and escape block
	functionInfo = ${FUNCNAME[*]}
	functionInfoNotes="Tomcat is being restarted by an administrator. Expect a momentary outage as services fire up." #extra notes
	notifySlack "${functionInfoNotes}"
	#end notification stack

	stopcorpTomcat #do it once
	stopcorpTomcat #do it again
	startcorpTomcat

	}

stopcorpTomcat(){
	echo "================================================================="
	echo "This function is often called by other functions."
	echo "================================================================="
	echo "Stop corp Tomcat service called 1tomcat."
	if (( $(ps -ef | grep -v grep | grep 1tomcat | wc -l) > 0 ))
	then
		echo "Attempting to stop service."
		service 1tomcat stop
		sleep 10
	else
		echo "Service is no longer running."
	fi

	pidResult=$(ps -ef | grep tomcat | grep java | awk ' { print $2 } ')
	if [ "${pidResult:-null}" = null ];
	then
		echo "OK. Process is not running"
	else
		echo "Attempting to kill the process $pidResult."
		kill $(ps -ef | grep tomcat | grep java | awk ' { print $2 } ')
		echo "Process action complete. Start verification."
	fi

	pidResultCheck=$(ps -ef | grep tomcat | grep java | awk ' { print $2 } ')
	if [ "${pidResultCheck:-null}" = null ];
	then
		echo "OK. Verification complete. Process was closed."
	else
		echo "WARNING: the system was unable to kill the process. Rerun this action or manually troubleshoot."
	fi

	echo "README - Moving forward in 10 seconds without your intervention!"
	sleep 5


}

startcorpTomcat(){
	echo "================================================================="
	echo "This function is often called by other functions."
	echo "================================================================="
	echo "Start corp Tomcat service called 1Tomcat."
	if (( $(ps -ef | grep -v grep | grep 1tomcat | wc -l) > 0 ))
	then
		echo "Service already running."
	else
		echo "Service not running, attempting to start."
		service 1tomcat start
	fi
	echo "Patience please..."
	sleep 10
	echo "should be good! Process output should be checked below:"
	ps -ef | grep tomcat

	echo "README - Moving forward in 10 seconds without your intervention!"
	sleep 10


}

actionresetLogFiles(){
	echo "================================================================="
	echo "Sets up blank log files while preserving old ones."
	stopcorpTomcat
	stopcorpTomcat
	now=$(date +"%Y-%m-%d-%H-%M-%S")
	mv -v /usr/local/corp/tpss.log /DATA/backup_server/$thisHost.tpss.$now.log
	mkdir -p /DATA/backup_server/$thisHost/$now
	mv -v /usr/share/tomcat/logs/* /DATA/backup_server/$thisHost/$now/
	#catalina and others
	startcorpTomcat
	pause
}



actionSecurity(){
	echo "================================================================="

	while true
		do
			actionSecurity_showMenu
			actionSecurity_readOptions
		done

}

actionSecurity_showMenu(){
	clear
	echo "Which special operation do you wish to run?:"
	echo "a) Lock down Tomcat Manager from external access."
	echo "x) Back/Exit."
}



actionSecurity_readOptions(){
	local selectSequence
	read -p "Enter choice [ a - x] " selectSequence
	case $selectSequence in
		a) actionSecurity_sub_migrateCMS ;;
		x) break ;;
		xxx) exit 0 ;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac

}

actionSecurity_sub_migrateCMS(){

	echo "Locking down Tomcat Manager."
	mv -v /usr/share/tomcat/conf/Catalina/localhost/manager.xml /DATA/backup_server/$thisHost.$now.manager.xml
	wget -N  https://url/s//manager.xml -P /usr/share/tomcat/conf/Catalina/localhost
	sleep 5
	chown tomcat.tomcat /usr/share/tomcat/conf/Catalina/localhost/manager.xml
	echo "View current list of files in this location:"
	ls -l /usr/share/tomcat/conf/Catalina/localhost/
	pause
}

actionGhostScript(){
	echo "================================================================="
	echo "Installing or updating GhostScript and ImageMagick."
	yum install ghostscript
	yum install ImageMagick
	ghostscript -version
	identify -version
	pause


}

actionNXLOG(){
	echo "Setting up logging"
	yum install libdbi
	wget -N  https://url/s//nxlog-ce-2.10.2102-1_rhel6.x86_64.rpm -P /opt/
	rpm -ivh /opt/nxlog-ce-2.10.2102-1_rhel6.x86_64.rpm
	wget -N  https://url/s/nxlog.conf -P /etc/
  chmod -R 755 /var/log/
	service nxlog start
	pause
}

actionNXLOGConfigChange(){
	echo "Upgrading NXLOG and installing default linux conifugration."
	service nxlog stop
  wget -N  https://url/s//nxlog-ce-2.10.2102-1_rhel6.x86_64.rpm -P /opt/
  rpm -U /opt/nxlog-ce-2.10.2102-1_rhel6.x86_64.rpm
	wget -N  https://url/s/nxlog.conf -P /etc/
  chmod -R 755 /var/log/
	service nxlog start
	pause
}

actionUJMTotalInstall(){
	echo "Installing Docker, NodeJS, and corp UJM"
	sudo yum update -y
	sudo yum install -y gcc-c++ make
	sudo yum install -y openssl-devel
	sudo yum install -y git
	yum install -y nmap
	git clone https://github.com/nodejs/node.git
	cd node
	git checkout v6.3.0
	./configure
	make
	sudo make install
	sudo yum install -y docker
	sudo service docker start
	sudo usermod -a -G docker user
	docker info
	sudo mkdir -p /usr/src/app
	sudo chmod 600 /usr/src/app
	sudo wget -N https://url/s//ujm.zip -P /usr/src/app
	sudo unzip /usr/src/app/ujm.zip
	docker run -p 8070 -p 8080 -it --rm --name alljobs -v "$PWD":/usr/src/app -w /usr/src/app node:4 node server.js
	pause
}

actionCleanActionsCache(){
	echo "Clean corp Plugin Actions Cache"
	find /usr/local/corp -type f -name '*.corp_action' -print
	echo "Do you wish to purge all those files? 1 for YES, 2 for NO."
	read -n1 -p "[1,2]. . . . . :" yesPurge
	if [ "$yesPurge" == "1" ]
	then
		find /usr/local/corp -type f -name '*.corp_action' -delete
		pause
	else
		echo "Doing nothing."
		pause
	fi
}

actionCreateCustomer(){
	echo "================================================================="
	echo "Creates a customer on corp Cloud."
	echo "Retrieving latest available copy of FileStore settings."
	wget -N https://url/s//Filestore.properties -P /usr/local/corp/corp-customers/Template
	wget -N https://url/s//Users.txt -P /usr/local/corp/corp-customers/Template
	wget -N https://url/s//License.properties -P /usr/local/corp/corp-customers/Template
	chmod -R 777 /usr/local/corp/corp-customers/Template/
	chown -R tomcat.tomcat /usr/local/corp/corp-customers/Template/
	echo "================================================================="
	echo "- - - Current Customers"
	echo "================================================================="
	ls -l /usr/local/corp/corp-customers
	echo "================================================================="
	echo "- - - Current FileStores"
	echo "================================================================="
	ls -l /DATA/FileStore
	echo "================================================================="
	echo "- - - COLLECT SETTINGS"
	echo "================================================================="
	read -p "What filestore is this?  corp_Cloud, corp_Cloud_Sandbox?. . . . . :"  -e -i corp_Cloud fileStoreSub
	read -p "What should the customer be called? Do not use spaces or punctuation. . . . . :" customerName
	cp -R -v /usr/local/corp/corp-customers/Template/ /usr/local/corp/corp-customers/$customerName/
	chmod -R 777 /usr/local/corp/corp-customers/$customerName/
	chown -R tomcat.tomcat /usr/local/corp/corp-customers/$customerName/
	sed -i "s/EDITTHISSPOT/$customerName/g" /usr/local/corp/corp-customers/$customerName/Filestore.properties
	sed -i "s/EDITTHISSTORE/$fileStoreSub/g" /usr/local/corp/corp-customers/$customerName/Filestore.properties
	mkdir -p -v /DATA/FileStore/$fileStoreSub/$customerName
	chmod -R 777 /DATA/FileStore/$fileStoreSub/$customerName/
	chown -R tomcat.tomcat /DATA/FileStore/$fileStoreSub/$customerName/
	echo "================================================================="
	echo "- - - Current Results"
	echo "================================================================="
	ls -l /usr/local/corp/corp-customers
	ls -l /DATA/FileStore/$fileStoreSub
	echo "Tomcat restart may be required to apply the FileStore property changes."
	#notification and escape block
	functionInfo = ${FUNCNAME[*]}
	functionInfoNotes="A new customer - $customerName - has been added to this system." #extra notes
	notifySlack "${functionInfoNotes}"
	#end notification stack
	pause
}

actionPULSE(){
	echo "================================================================="
	echo "RMM."
 	yum install openssl-devel -y
	thisHost=$(hostname)
	read -p "What do we want to call this machine in the dashboard?. . . . . :" -e -i $thisHost machineName
	echo "Machine name $machineName."
	read -p "Press [Enter] to continue..."
  	ln -s  /usr/lib64/libcrypto.so /usr/lib64/libcrypto.so.0.9.8
	mkdir -P /DATA/ops
	sudo wget -N http://www.RMM.com/download/RMM_x64.rpm -P /DATA/ops/
	sudo rpm -ivh /DATA/ops/RMM_x64.rpm
	sudo RMM-registration
	sudo systemctl start RMM
}

actionCertBot(){
	echo "================================================================="
	echo "Install Certbot and LetsEncrypt."
	thisHost=$(hostname)
	read -p "What do we want to call this machine in the dashboard?. . . . . :" -e -i $thisHost machineName
	echo "Machine name $machineName"
	read -p "Press [Enter] to continue..."
  	mkdir -P /DATA/ops
	sudo wget -N https://dl.eff.org/certbot-auto -P /DATA/ops/
	sudo chmod a+x certbot-auto
	sudo ./certbot-auto --debug -v --server https://acme-v02.api.letsencrypt.org/directory certonly -d $machineName
	echo "Please edit WebMin and HTTPD configuration manually."
	pause
}

actionCertBotRenew(){
	echo "================================================================="
	echo "Renew certs."
	sudo certbot-auto renew
	echo "Done. Consider automating this command..."
	pause

}

actionUpdateLinux(){
	echo "================================================================="
	echo "Run System Updates."
	yum update

	#notification and escape block
	functionInfo = ${FUNCNAME[*]}
	functionInfoNotes="Running all linux patches and updates." #extra notes
	notifySlack "${functionInfoNotes}"
	#end notification stack

	pause
}

systemInfo(){
	clear
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo " System information."
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo ""
	echo "================================================================="
	echo "- - - - - - - - - Memory:"
	echo "================================================================="
	free -m
	echo ""
	echo "================================================================="
	echo "- - - - - - - - - Java details:"
	echo "================================================================="
	java -version
	echo ""
	echo "================================================================="
	echo "- - - - - - - - - Process details:"
	echo "================================================================="
	ps -ef | grep tomcat
	echo ""
	echo "================================================================="
	echo "- - - - - - - - - Common volume mounts contents."
	echo "================================================================="
	ls -l /DATA
	ls -l /DATA/warserver
	ls -l /DATA/warfiles
	ls -l /DATA/backup_server
	echo ""
	echo "================================================================="
	echo "- - - - - - - - - Disk Usage"
	echo "================================================================="
	du -sh /DATA
	du -sh /usr/share/tomcat
	du -sh /usr/local/corp
	echo ""
	echo "================================================================="
	echo "- - - - - - - - - Known Credential Files."
	echo "================================================================="
	ls -l /etc/passwd*
	echo ""
	echo "================================================================="
	echo "- - - - - - - - - HOSTNAME"
	echo "================================================================="
	thisHost=$(hostname)
	echo "$thisHost."
	echo ""
	pause
}

setHostName(){
	echo "================================================================="
	echo "Change Hostname, current hostname is:"
	echo $(hostname)
	read -p "What is the new hostname? " newHostName
	hostname $newHostName
	pause

}

restart(){
	echo "================================================================="
	echo "Restart about to happen."

	#notification and escape block
	functionInfo = ${FUNCNAME[*]}
	functionInfoNotes="This system is presently restarting. Restart times vary between 2 and 7 minutes depending on the services and load." #extra notes
	notifySlack "${functionInfoNotes}"
	#end notification stack

	#here we go!
	shutdown -r now

	#should never even get this far.
	pause
}

alarm(){
	echo "================================================================="
	echo "Sending alerts now."
	read -p "What would you like to say?. . . . . : " alertMessage
	#notification and escape block
	functionInfo = ${FUNCNAME[*]}
	notifySlack "${alertMessage}"
	#end notification stack

	pause
}

# function to display menus
show_menus() {
	clear
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo " corp Automation Script for Cloud - TASC - Main Menu."
	echo " Did you remember to run as sudo?"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo ""
	echo "0.  Display System Info."
	echo ""
	echo ""
	echo "================================================================="
	echo "- - - Management & Maintenance."
	echo "================================================================="
	echo ""
	echo "a. Send an Alarm or Notice Message."
	echo "60. Create a new corp Cloud customer."
	echo "20. Update latest security overrides - multiple choice menu."
	echo "95. corp Tomcat - RESTART - with notice."
	echo "96. corp Tomcat - STOP."
	echo "97. corp Tomcat - START."
	echo "90. Stop SAMBA file server."
	echo "91. Start SAMBA file server."
	echo "18. Reload all corp Plugins. Nuke and bring over most recent release."
	echo "19. Reset tpss.log with backup. This will restart Tomcat!"
	echo "25. Purge/Delete the corp Actions Cache."
	echo "98. Run System Updates - with notice."
	echo "100. Restart this machine - with notice."
	echo ""
	echo "================================================================="
	echo "- - - Installation & Provisioning."
	echo "================================================================="
	echo ""
	echo "1a. Install OpenJDK via Amazon Corretto."
	echo "1b. --."
	echo "2.  Install WebMin management GUI for administering the server."
	echo "3.  Download and save our SSL certificates for corp.NET."
	echo "4.  Create all HTTPD Services with default configurations for Cloud including SSL and redirect."
	echo "5.  Create Tomcat User."
	echo "6.  Install/Reinstall/Reconfigure Tomcat Server."
	echo "7.  Install or upgrade corp 8."
	echo "8.  Install SAMBA File Server."
	echo "9.  Configure SAMBA File Server."
	echo "22. Install and Configure NXLOG for PaperTrail."
	echo "23. INXLOG for PaperTrail configuration update."
	echo "21. Install or Update GhostScript and ImageMagick."
	echo "24. Install Docker, NodeJS, and the UJHM."
	echo "26. Install RMM Agent."
	echo "27. Install and configure CertBot."
	echo "28. Renew LetsEncrypt SSL with CertBot."
	echo ""
	echo "================================================================="
	echo "- - - File systems and storage."
	echo "================================================================="
	echo ""
	echo "10. Build the FUSE filesystem."
	echo "11. Set Credentials for AWS S3 - Default - Recommended"
	echo "12. Set Credentials for AWS S3 - Custom - Advanced Use."
	echo "13. Mount any Amazon S3 bucket - Recommended."
	echo "14. Mount any Amazon S3 bucket with cache."
	echo "15. Mount any Amazon S3 bucket with custom credentials."
	echo "16. Enable FUSE S3FS on Boot."
	echo "17. Attempt to mount all known AWS S3 volumes used by corp Cloud Servers."
	echo ""
	echo "================================================================="
	echo "- - - Admin License Server Specific Functions."
	echo "================================================================="
	echo ""
	echo "30. Mount Amazon S3 plugins bucket."
	echo ""
	echo ""
	echo "================================================================="
	echo "- - - Custom Functions."
	echo "================================================================="
	echo ""
	echo "70. Advanced menu for operations, migrations, and unique events."
	echo "80. Install AWS Inspector for advanced monitoring."
	echo "99. Set hostname to something humans understand."
	echo ""
	echo "================================================================="
	echo "- - - Exit."
	echo "================================================================="
	echo ""
	echo "x. Exit."
	echo ""
	echo "--!--!--!--!--!--!--!--!--!--!--!--!--!--!--!--!--!--!--!--!--!--!"
	thisHost=$(hostname)
	echo "Host: $thisHost"
	echo "--!--!--!--!--!--!--!--!--!--!--!--!--!--!--!--!--!--!--!--!--!--!"
	echo ""
}


# read input from the keyboard and take a action
# invoke the task() when the user selects number from the menu option.
# Exit when user the user select 99 form the menu option.
read_options(){
	local choice
	read -p "Enter choice [ 1 - x] " choice
	case $choice in
		0) systemInfo ;;
		1a) actionJava ;;
		2) actionWebMin ;;
		3) actionSSL ;;
		4) actionHTTPD ;;
		5) actionTomcatuser ;;
		6) actionTomcat ;;
		7) actioncorp ;;
		8) actionSamba ;;
		9) actionSambaConfig ;;
		10) actionFuse ;;
		11) actionAWScred1 ;;
		12) actionAWScred2 ;;
		13) actionAWSbucket ;;
		14) actionAWSbetter ;;
		15) actionAWScustomCreds ;;
		16) actionFuseBoot ;;
		17) actionMountKnownBuckets ;;
		18) actionRelaodAllcorpPlugins ;;
		19) actionresetLogFiles ;;
		20) actionSecurity ;;
		21) actionGhostScript ;;
		22) actionNXLOG ;;
		23) actionNXLOGConfigChange ;;
		24) actionUJMTotalInstall ;;
		25) actionCleanActionsCache ;;
		26) actionPULSE ;;
		27) actionCertBot ;;
		28) actionCertBotRenew ;;
		30) actionAWSbucketAdmin ;;
		60) actionCreateCustomer ;;
		70) specialOperations ;;
		80) actionInspectorInstall ;;
		90) stopSAMBA ;;
		91) startSAMBA ;;
		95) restartTomcat ;;
		96) stopcorpTomcat ;;
		97) startcorpTomcat ;;
		98) actionUpdateLinux ;;
		99) setHostName ;;
		100) restart ;;
		a) alarm ;;
		x) exit 0 ;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}


# ----------------------------------------------
# Step #3: Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP

# -----------------------------------
# Step #4: Main logic - infinite loop
# ------------------------------------
while true
do

 	show_menus
	read_options

done

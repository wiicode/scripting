#!/bin/bash
# A menu driven corp setup script for Linux
#
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


actionHTTPD(){
	echo "================================================================="
	echo "Setting up all HTTPD Services with default configurations for Cloud including SSL and redirect."
	sudo yum groupinstall "Web Server"
	wget -N <YOURPATH>/httpd.conf -P /etc/httpd/conf/
	wget -N <YOURPATH>//ssl.conf -P /etc/httpd/conf.d/
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
	read -p "Type the Tomcat version you want to use, ie: 8.5.35. . . . . :" versionTomcat

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
		echo "Please request the file from your infrastructure team."
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
			wget -N <YOURPATH>//1tomcat -P /etc/init.d/
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

actionRelaodAllcorpPlugins(){
	echo "================================================================="
	echo "What have you done?! All plugins being reloaded."

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


	plugin="corp-plugin-ant"
	file=$(ls /DATA/warfiles/$plugin -t | head -1)
	cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	chmod 600 /usr/share/tomcat/webapps/$file


	plugin="corp-plugin-docx"
	file=$(ls /DATA/warfiles/$plugin -t | head -1)
	cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	chmod 600 /usr/share/tomcat/webapps/$file


	plugin="corp-plugin-epub"
	file=$(ls /DATA/warfiles/$plugin -t | head -1)
	cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	chmod 600 /usr/share/tomcat/webapps/$file

	plugin="corp-plugin-id"
	file=$(ls /DATA/warfiles/$plugin -t | head -1)
	cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	chmod 600 /usr/share/tomcat/webapps/$file


	plugin="corp-plugin-jats"
	file=$(ls /DATA/warfiles/$plugin -t | head -1)
	cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	chmod 600 /usr/share/tomcat/webapps/$file


	plugin="corp-plugin-util"
	file=$(ls /DATA/warfiles/$plugin -t | head -1)
	cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	chmod 600 /usr/share/tomcat/webapps/$file


	plugin="corp-plugin-xsl"
	file=$(ls /DATA/warfiles/$plugin -t | head -1)
	cp -v /DATA/warfiles/$plugin/$file /usr/share/tomcat/webapps/$file
	chmod 600 /usr/share/tomcat/webapps/$file




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


# function to display menus
show_menus() {
	clear
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo " corp Automation Script for Linux - TASL - Main Menu."
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
	echo "20. Update latest security overrides - multiple choice menu."
	echo "95. corp Tomcat - RESTART - with notice."
	echo "96. corp Tomcat - STOP."
	echo "97. corp Tomcat - START."
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
	echo "5.  Create Tomcat User."
	echo "6.  Install/Reinstall/Reconfigure Tomcat Server."
	echo "7.  Install or upgrade corp 8."
	echo ""
	echo "================================================================="
	echo "- - - Custom Functions."
	echo "================================================================="
	echo ""
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
		5) actionTomcatuser ;;
		6) actionTomcat ;;
		7) actioncorp ;;
		18) actionRelaodAllcorpPlugins ;;
		19) actionresetLogFiles ;;
		20) actionSecurity ;;
		95) restartTomcat ;;
		96) stopcorpTomcat ;;
		97) startcorpTomcat ;;
		98) actionUpdateLinux ;;
		99) setHostName ;;
		100) restart ;;
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

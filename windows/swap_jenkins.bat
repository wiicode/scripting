ECHO OFF
CLS
:STOP
Set propdir=D:\jenkins\jobs
set jenkinsFuture=jenkins-slave.future.xml
set jenkinsLegacy=jenkins-slave.legacy.xml
set jenkinsProperty=jenkins-slave.xml

net stop "jenkinsslave-D__jenkins_jobs"

:CHECK
set ready=0
 	IF EXIST %propdir%\jenkins-slave.future.xml (
       	set ready=1
    ) ELSE (
        ECHO WARNING: The file jenkins-slave.future.xml is missing.  This script will not work.
    )

 	IF EXIST %propdir%\jenkins-slave.legacy.xml (
       	set ready=2
    ) ELSE (
        set ready=0
        ECHO WARNING: The file jenkins-slave.legacy.xml is missing.  This script will not work.
    )

	IF %ready%==2 (
		ECHO Starting JENKINS config swap.
	) ELSE (
		ECHO Unable to continue due to missing config files. Please contact support.
		pause
		exit
	)

:MENU
ECHO.
ECHO ...............................................
ECHO corp JENKINS SWAPPER
ECHO ...............................................
ECHO Please select your location:
ECHO ...............................................
ECHO.
ECHO 1 - future (jenkins.corp.com)
ECHO 2 - legacy (build.corp.com)
ECHO 3 - EXIT
ECHO.
SET /P M=Type 1, 2, or 3 then press ENTER:
IF %M%==1 GOTO future
IF %M%==2 GOTO legacy
IF %M%==3 GOTO START

:future
ECHO future run
MOVE /-y %propdir%\%jenkinsProperty% %propdir%\%jenkinsProperty%.backup
COPY %propdir%\%jenkinsFuture% %propdir%\%jenkinsProperty%
GOTO START

:legacy
ECHO legacy run
MOVE /-y %propdir%\%jenkinsProperty% %propdir%\%jenkinsProperty%.backup
COPY %propdir%\%jenkinsLegacy% %propdir%\%jenkinsProperty%
GOTO START

:START
ECHO Starting jenkins
net start "jenkinsslave-D__jenkins_jobs"
pause

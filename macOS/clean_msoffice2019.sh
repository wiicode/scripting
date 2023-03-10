### Script to remove all Microsoft Office 2016 file from local computer. Script will force quit running Microsoft Applications
#####

## VARIABLES ##
WORDAPP="/Applications/Microsoft Word.app"
EXCELAPP="/Applications/Microsoft Excel.app"
POWERAPP="/Applications/Microsoft PowerPoint.app"
OUTLOOKAPP="/Applications/Microsoft Outlook.app"
ONENOTEAPP="/Applications/Microsoft OneNote.app"
declare -a APPARRAY=( "Microsoft Word"
"Microsoft Excel"
"Microsoft PowerPoint"
"Microsoft Outlook"
"Microsoft OneNote" )

## FORCE QUIT RUNNING MICROSOFT APPLICATIONS ##
echo "Close running Office applications"
for APP in "${APPARRAY[@]}"
do
  if ps axc | grep -q "$APP$"; then
    echo "Application $APP is running. Quitting application now..."
    PID=`ps axc | grep "$APP$" | awk '{print $1}'`
    osascript -e 'quit app "$APP$"'
    if ps axc | grep "$APP$"; then
      echo "Application $APP did not quit with osascript. Killing application now..."
      kill $PID
    fi
  fi
done

## DETERMINE IF MICROSOFT APPLICATIONS ARE STILL RUNNING. IF SO, EXIT SCRIPT ##
echo "Determine what Office products are currently running..."
MicrosoftRunning=$( ps axc | grep MICROSOFT )
if [ -z $MicrosoftRunning ]; then
  echo "No Microsoft applications are running. Continue removal script."
else
  echo "Microsoft applications are running. Exiting script."
  echo $MicrosoftRunning
  exit 0
fi

## REMOVE OFFICE ICONS FROM DOCK ##
if [ -f /usr/local/bin/dockutil ]; then
  for APP in "${APPARRAY[@]}"
  do
    /usr/local/bin/dockutil —-allhomes —-remove “${APP}”
  done
fi

## REMOVE APPLICATIONS FROM "/APPLICATIONS/"
sudo rm -rf "${WORDAPP}"
sudo rm -rf "${EXCELAPP}"
sudo rm -rf "${POWERAPP}"
sudo rm -rf "${OUTLOOKAPP}"
sudo rm -rf "${ONENOTEAPP}"

## REMOVE SUPPORTING OFFICE FILES FROM SYSTEM LIBRARY ##
if [ ! -d "${WORDAPP}" ] && \
  [ ! -d "${EXCELAPP}" ] && \
  [ ! -d "${POWERAPP}" ] && \
  [ ! -d "${OUTLOOKAPP}" ] && \
  [ ! -d "${ONENOTEAPP}" ]; then
    sudo rm -rf “/Library/LaunchDaemons/com.microsoft.office.licensingV2.helper.plist”
    sudo rm -rf “/Library/LaunchDaemons/com.microsoft.autoupdate.helper.plist
    sudo rm -rf “/Library/LaunchDaemons/com.microsoft.onedriveupdaterdaemon.plist
    sudo rm -rf “/Library/LaunchAgents/com.microsoft.update.agent.plist
    sudo rm -rf “/Library/PrivilegedHelperTools/com.microsoft.office.licensingV2.helper”
    sudo rm -rf “/Library/PrivilegedHelperTools/com.microsoft.autoupdate.helper”
    sudo rm -rf “/Library/Preferences/com.microsoft.office.licensingV2.plist”

    ## REMOVE SUPPORTING OFFICE FILES FROM END USER LIBRARIES ##
    for i in $(/bin/ls /Users | sed -e '/Shared/d' \
    -e '/Deleted Users/d' \
    -e '/.localized/d' \
    -e '/.DS_Store/d' \
    -e '/.com.apple.timemachine.supported/d' \
    -e '/Adobe/d' -e '/Library/d')
    do 
      sudo rm -rf “/Users/$I/Library/Containers/com.microsoft.errorreporting“
      sudo rm -rf “/Users/$i/Library/Containers/com.microsoft.Excel“
      sudo rm -rf “/Users/$i/Library/Containers/com.microsoft.netlib.shipassertprocess“
      sudo rm -rf “/Users/$i/Library/Containers/com.microsoft.Office365ServiceV2“
      sudo rm -rf “/Users/$i/Library/Containers/com.microsoft.onedrive.findersync“
      sudo rm -rf “/Users/$i/Library/Containers/com.microsoft.Outlook“
      sudo rm -rf “/Users/$i/Library/Containers/com.microsoft.Powerpoint“
      sudo rm -rf “/Users/$i/Library/Containers/com.microsoft.RMS-XPCService“
      sudo rm -rf “/Users/$i/Library/Containers/com.microsoft.Word“
      sudo rm -rf “/Users/$i/Library/Containers/com.microsoft.onenote.mac“
      sudo rm -rf “/Users/$i/Library/Cookies/com.microsoft.onedrive.binarycookies”
      sudo rm -rf “/Users/$i/Library/Cookies/com.microsoft.onedriveupdater.binarycookies”
      sudo rm -rf “/Users/$i/Library/Group Containers/UBF8T346G9.ms”
      sudo rm -rf “/Users/$i/Library/Group Containers/UBF8T346G9.Office”
      sudo rm -rf “/Users/$i/Library/Group Containers/UBF8T346G9.OfficeOneDriveSyncIntegration”
      sudo rm -rf “/Users/$i/Library/Group Containers/UBF8T346G9.OfficeOsfWebHost”
      sudo rm -rf “/Users/$i/Library/Group Containers/UBF8T346G9.OneDriveStandaloneSuite”
    done
fi
#!/bin/bash
launchctl unload /Library/LaunchDaemons/com.webroot.security.mac.plist
launchctl unload /Library/LaunchDaemons/com.webroot.webfilter.mac.plist
sudo launchctl unload /Library/LaunchDaemons/com.webroot.security.mac.plist
sudo launchctl unload /Library/LaunchDaemons/com.webroot.webfilter.mac.plist
rm /usr/local/bin/WSDaemon
rm /usr/local/bin/WFDaemon
sudo rm /usr/local/bin/WSDaemon
sudo rm /usr/local/bin/WFDaemon
killall -9 WSDaemon
killall -9 WFDaemon
killall -9 "Webroot SecureAnywhere"
sudo killall -9 WSDaemon
sudo killall -9 WFDaemon
sudo killall -9 "Webroot SecureAnywhere"
rm -rf /System/Library/Extensions/SecureAnywhere.kext
rm -rf "/Applications/Webroot SecureAnywhere.app"
rm /Library/LaunchAgents/com.webroot.webfilter.mac.plist
rm /Library/LaunchDaemons/com.webroot.security.mac.plist 
sudo rm -rf /System/Library/Extensions/SecureAnywhere.kext
sudo rm -rf "/Applications/Webroot SecureAnywhere.app"
sudo rm /Library/LaunchAgents/com.webroot.webfilter.mac.plist
sudo rm /Library/LaunchDaemons/com.webroot.security.mac.plist 
sudo rm -rf "/Applications/Webroot SecureAnywhere.app"
curl -o /tmp/wsamacsme.dmg https://anywhere.webrootcloudav.com/zerol/wsamacsme.dmg
hdiutil attach -nobrowse /tmp/wsamacsme.dmg
cp -R "/Volumes/Webroot SecureAnywhere/Webroot SecureAnywhere.app" /Applications/ 
diskutil unmount "/Volumes/Webroot SecureAnywhere" 
sudo "/Applications/Webroot SecureAnywhere.app/Contents/MacOS/Webroot SecureAnywhere" install -keycode="SACA-WRSM-987B-7B44-9E89" -language=en -silent

#!/bin/sh
curl -o /tmp/wsamacsme.dmg http://anywhere.webrootcloudav.com/zerol/wsamacsme.dmg
hdiutil attach -nobrowse /tmp/wsamacsme.dmg
ditto /Volumes/Webroot\ SecureAnywhere /Applications/
diskutil list | grep Webroot\ SecureAnywhere | diskutil unmount /Volumes/Webroot\ SecureAnywhere
"/Applications/Webroot SecureAnywhere.app/Contents/MacOS/Webroot SecureAnywhere" install -keycode=KEYCODEGOESHERE -language=en -silent
rm -rf /tmp/wsamacsme.dmg

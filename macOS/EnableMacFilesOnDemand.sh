echo OneDrive Enable On-Demand Features. 
Defaults write com.microsoft.OneDriveUpdater Tier Insiders
echo Restarting Defaults Cache
killall cfprefsd
echo Refreshing Update Rings
rm ~/Library/Caches/OneDrive/UpdateRingSettings.json
echo All set!

set -eux
cd ~/Downloads
curl -O https://{link-to-your-custom-host-module}.pkg
curl -O https://{link-to-the-assignment-tool}/TeamViewer_Assignment
chmod +x TeamViewer_Assignment
sudo installer -pkg TeamViewerHost-idc{your-custom-host-id}.pkg -target /
sudo ./TeamViewer_Assignment -apitoken "{API-token-of-your-host-module}" -datafile /Library/Application\ Support/TeamViewer\ Host/Custom\ Configurations/{the-Config-ID-of-your-host-module}/AssignmentData.json


##EXAMPLE
#set -eux
#cd ~/Downloads
#curl -O https://teamviewer.com/TeamViewerHost-idc12abc3d.pkg
#curl -O https://teamviewer.com/TeamViewer_Assignment
#chmod +x TeamViewer_Assignment
#sudo installer -pkg TeamViewerHost-idc12abc3d.pkg -target /
#sudo ./TeamViewer_Assignment -apitoken "1234-ylQcaABCDE5e6p7YEzYu" -datafile /Library/Application\ Support/TeamViewer\ Host/Custom\ Configurations/12abc3d/AssignmentData.json 

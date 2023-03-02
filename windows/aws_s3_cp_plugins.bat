REM copies latest plugins to the defined path.  Requires credentials corpplugins to be set.


REM These are from the admin server, fully ready for public consumption.
aws s3 sync s3://warfiles/all-latest-plugins "m:\corpwarfiles\latest" --profile corpplugins --delete

REM These are from the admin server, fully for internal consumption only.
aws s3 sync s3://warfiles "m:\corpwarfiles\archive" --profile corpplugins --delete --exclude "all-latest-plugins/*"
aws s3 sync s3://warfiles-prerelease/ "m:\corpwarfiles Prerelease" --profile corpplugins --delete

REM this seemingly does not exist
REM aws s3 cp s3://warfiles-builds/jobs/ "m:\corp__Server Builds" --profile corpplugins --recursive
Read-Host -Prompt "Press Enter to exit"

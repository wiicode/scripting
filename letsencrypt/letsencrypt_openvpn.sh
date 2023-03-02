#!/bin/bash

# IMPORTANT: Make sure your VM's network security rules allows access over TCP Port 80.
#            This is required to pass the HTTP challenge.

# Download: curl -o setup.sh <raw URL of this gist>
# Enable execution: sudo chmod +x setup.sh
# Run: ./setup.sh -d "yourdomain.tld" -e "youremail@yourdomain.tld"

while getopts d:e: option
do
case "${option}"
in
d) DOMAIN=${OPTARG};;
e) EMAIL=${OPTARG};;
esac
done

sudo apt-get -y install software-properties-common
sudo add-apt-repository -y ppa:certbot/certbot
sudo apt-get -y update
sudo apt-get -y install certbot

sudo service openvpnas stop

# Delete existing certificates
/usr/local/openvpn_as/scripts/confdba -mk cs.ca_bundle
/usr/local/openvpn_as/scripts/confdba -mk cs.priv_key
/usr/local/openvpn_as/scripts/confdba -mk cs.cert

# Generate certificates through Let's Encrypt
sudo certbot certonly \
  --standalone \
  --non-interactive \
  --agree-tos \
  --email $EMAIL \
  --domains $DOMAIN \
  --pre-hook 'sudo service openvpnas stop' \
  --post-hook 'sudo service openvpnas start'

# symlink the generated certificates to the OpenVPN certificate location
sudo ln -s -f /etc/letsencrypt/live/$DOMAIN/cert.pem /usr/local/openvpn_as/etc/web-ssl/server.crt
sudo ln -s -f /etc/letsencrypt/live/$DOMAIN/privkey.pem /usr/local/openvpn_as/etc/web-ssl/server.key
sudo ln -s -f /etc/letsencrypt/live/$DOMAIN/fullchain.pem /usr/local/openvpn_as/etc/web-ssl/ca.crt

# Restart the service to pickup the certs
sudo service openvpnas restart
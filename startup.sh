#!/bin/bash
echo "Starting user data"
whoami
yum update -y
yum -y install httpd
cat > /etc/httpd/conf.d/foundry.conf <<eof
<VirtualHost *:80>
    ServerName              www.inharnsway.com

    # Proxy Server Configuration
    ProxyPreserveHost       On
    ProxyPass "/socket.io/" "ws://localhost:30000/socket.io/"
    ProxyPass /             http://localhost:30000/
    ProxyPassReverse /      http://localhost:30000/
</VirtualHost>
# Increase the maximum upload limit Apache will allow
<Location / >
# 100MB upload
LimitRequestBody 104857600 
</Location>
eof
systemctl start httpd
mount /dev/sdb1 /home/ec2-user/foundrydata
FOUNDRY_CONF=/home/ec2-user/foundrydata/Config/options.json
mkdir -p $(dirname $FOUNDRY_CONF)
cat > ${FOUNDRY_CONF} <<eof
{
  "hostname": "www.inharnsway.com",
  "routePrefix": null,
  "sslCert": null,
  "sslKey": null,
  "port": 30000,
  "proxyPort": 80,
  "upnp": false,
  "fullscreen": false,
  "routePrefix": null,
  "sslCert": null,
  "sslKey": null,
  "awsConfig": null,
  "dataPath": "/home/ec2-user/foundrydata",
  "proxySSL": false,
  "proxyPort": null,
  "minifyStaticFiles": false,
  "updateChannel": "release",
  "language": "en.core",
  "world": null
}
eof
chown -R ec2-user:ec2-user /home/ec2-user/foundrydata
su - ec2-user -c "node /home/ec2-user/foundryvtt/resources/app/main.js --dataPath=/home/ec2-user/foundrydata"
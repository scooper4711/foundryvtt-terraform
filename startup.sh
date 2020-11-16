#!/bin/bash
echo "Starting user data"
whoami
yum update -y

FOUNDRY_CONF=/home/ec2-user/foundrydata/Config/options.json
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
chown ec-user:ec2-user ${FOUNDRY_CONF}
su - ec2-user -c "node /home/ec2-user/foundryvtt/resources/app/main.js"
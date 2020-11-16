#!/bin/bash
echo "Starting user data"
whoami
yum update -y

cat > /home/ec2-user/foundrydata/Config/options.json <<eof
{
  "hostname": "www.inharnsway.com",
  "routePrefix": null,
  "sslCert": null,
  "sslKey": null,
  "port": 30000,
  "proxyPort": 80,
  "upnp": false,
  "fullscreen": false,
  "hostname": null,
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
chown ec-user:ec2-user /home/ec2-user/foundrydata/Config/options.json
systemctl start httpd
su - ec2-user -c "node /home/ec2-user/foundryvtt/resources/app/main.js --dataPath=/home/ec2-user/foundrydata --nopnp --hostname=inharnsway.com"
#!/bin/bash
echo "Starting user data"
hostnamectl set-hostname foundryvtt.inharnsway.com
cat >> /etc/fstab <<eof
/dev/sdb     /home/ec2-user/foundrydata           xfs    defaults,noatime  1   1
eof
mount /home/ec2-user/foundrydata
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
systemctl enable httpd
cat > /etc/systemd/system/foundryvtt.service <<eof
[Unit]
Description=Foundry VTT

[Service]
ExecStart=/usr/bin/node /home/ec2-user/foundryvtt/resources/app/main.js --dataPath=/home/ec2-user/foundrydata
User=ec2-user

[Install]
WantedBy=default.target
eof
systemctl start foundryvtt
systemctl enable foundryvtt
#!/bin/bash
echo "Starting user data"
echo "Set a consistent server name for FoundryVTT Licensing"
hostnamectl set-hostname ${server}.${domain}

if [[ ! -z "${foundry_download}" && ! -d /home/ec2-user/foundryvtt ]] ; then
    echo "Downloading FoundryVTT software"
    mkdir /home/ec2-user/foundryvtt
    wget -nv -O foundryvtt.zip "${foundry_download}"
    unzip -d /home/ec2-user/foundryvtt foundryvtt.zip
    chown -R ec2-user:ec2-user /home/ec2-user/foundryvtt
fi

if ( ! grep -q foundrydata /etc/fstab ); then 
    echo "Mount the EBS volume for foundrydata"
    mkdir /home/ec2-user/foundrydata
    chown ec2-user:ec2-user /home/ec2-user/foundrydata
    cat >> /etc/fstab <<eof
/dev/sdb     /home/ec2-user/foundrydata           xfs    defaults,noatime  1   1
eof
    mount /home/ec2-user/foundrydata
fi

echo "Update to the lastest of all software, and install node and https"
yum update -y
curl --silent --location https://rpm.nodesource.com/setup_12.x | bash -
yum -y install httpd mod_ssl openssl-devel nodejs socat

if [[ ! -d /root/.acme.sh ]]; then
    echo "Get certificate from let's encrypt"
    mkdir /etc/pki/tls/certs/${domain}
    export HOME=/root
    curl https://get.acme.sh | sh
fi
if ! /root/.acme.sh/acme.sh --list | grep ${name}.${domain}; then
    # Need http running to get a cert issued
    systemctl start httpd
    /root/.acme.sh/acme.sh --issue -d ${name}.${domain} -w /var/www/html --debug
    /root/.acme.sh/acme.sh --install-cert -d ${name}.${domain} \
        --cert-file /etc/pki/tls/certs/${domain}/cert.pem \
        --key-file /etc/pki/tls/certs/${domain}/key.pem  \
        --fullchain-file /etc/pki/tls/certs/${domain}/fullchain.pem
fi

if [[ ! -f /etc/httpd/conf.d/foundry.conf ]]; then
    echo "Create http configuration for FoundryVTT"
    cat > /etc/httpd/conf.d/foundry.conf <<eof
<VirtualHost _default_:443>
    ServerName              ${name}.${domain}
    # Proxy Server Configuration
    ProxyPreserveHost       On
    ProxyPass "/socket.io/" "ws://localhost:30000/socket.io/"
    ProxyPass /             http://localhost:30000/
    ProxyPassReverse /      http://localhost:30000/
    ErrorLog logs/ssl_error_log
    TransferLog logs/ssl_access_log
    LogLevel warn
    SSLEngine on
    SSLProtocol all -SSLv3
    SSLCipherSuite HIGH:MEDIUM:!aNULL:!MD5:!SEED:!IDEA
    SSLCertificateFile /etc/pki/tls/certs/${domain}/cert.pem
    SSLCertificateKeyFile /etc/pki/tls/certs/${domain}/key.pem
    SSLCertificateChainFile /etc/pki/tls/certs/${domain}/fullchain.pem
</VirtualHost>
<VirtualHost *:80>
    ServerName              www.${domain}
    # Anything starting with a 'dot' might be part of the let's encrypt program. Don't redirect it
    <Location ~ "^/\..*$">
    </Location>
    # If it *doesn't start with a dot, then re-direct it to https.
    <Location ~ "(^$|^/[^\.].*$)">
        Redirect / https://www.${domain}/
    </Location>
</VirtualHost>
# Increase the maximum upload limit Apache will allow
<Location / >
# 100MB upload
LimitRequestBody 104857600 
</Location>
eof
fi

systemctl restart httpd
systemctl enable httpd

if [[ ! -f /etc/systemd/system/foundryvtt.service ]]; then
    echo "Create a foundryvtt service"
    cat > /etc/systemd/system/foundryvtt.service <<eof
[Unit]
Description=Foundry VTT

[Service]
ExecStart=/usr/bin/node /home/ec2-user/foundryvtt/resources/app/main.js --dataPath=/home/ec2-user/foundrydata
User=ec2-user

[Install]
WantedBy=default.target
eof
fi

systemctl start foundryvtt
systemctl enable foundryvtt
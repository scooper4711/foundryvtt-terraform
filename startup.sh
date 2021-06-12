#!/bin/bash
echo "Starting user data"
mount /home/ec2-user/foundrydata

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

#!/bin/bash
echo "Update to the lastest of all software"
sudo yum update -y
echo "Enable amazon ssm agent"
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
sudo systemctl status amazon-ssm-agent
if [[ ! -z "/tmp/foundryvtt.zip" && ! -d /home/ec2-user/foundryvtt ]] ; then
    echo "Installing FoundryVTT software"
    mkdir /home/ec2-user/foundryvtt
    unzip -qd /home/ec2-user/foundryvtt /tmp/foundryvtt.zip
    rm /tmp/foundryvtt.zip
fi

echo "Create fstab entry for EBS volume for foundrydata"
mkdir /home/ec2-user/foundrydata

echo "Install node and https"
curl --silent --location https://rpm.nodesource.com/setup_14.x | sudo bash -
sudo yum -y install httpd mod_ssl openssl-devel nodejs socat

echo "Create a foundryvtt service"
sudo mv /tmp/foundryvtt.service /etc/systemd/system/foundryvtt.service
sudo mv /tmp/foundry.conf /etc/httpd/conf.d/foundry.conf
sudo cat /etc/fstab /tmp/fstab >> /tmp/fstab2
sudo mv /etc/fstab2 /tmp/fstab

sudo systemctl enable foundryvtt
sudo systemctl enable httpd

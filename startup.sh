#!/bin/bash
echo "Starting user data"
whoami
yum update all
su - ec2-user -c "whoami; node /home/ec2-user/foundryvtt/resources/app/main.js --dataPath=/home/ec2-user/foundrydata --nopnp --hostname=inharnsway.com"
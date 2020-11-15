#!/bin/bash
echo "Starting user data"
whoami
yum update all
su - ec2-user -c "node $HOME/foundryvtt/resources/app/main.js --dataPath=$HOME/foundrydata --nopnp --hostname=inharnsway.com"
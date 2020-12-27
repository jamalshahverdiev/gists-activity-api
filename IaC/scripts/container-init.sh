#!/bin/bash

cloneFolder='/root/gistapidir'
dockerComposeVersion='1.27.4'
apt update
apt remove -y docker docker-engine docker.io containerd runc
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common python3-pip && pip3 install flask
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt-get install -y docker-ce docker-ce-cli containerd.io
wget https://github.com/docker/compose/releases/download/$dockerComposeVersion/docker-compose-Linux-x86_64 -O /bin/docker-compose && chmod +x /bin/docker-compose
git clone 'https://github.com/jamalshahverdiev/gists-activity-api.git' $cloneFolder && cd $cloneFolder && docker-compose up -d

sed -i "s/replace_api_token/${API_TOKEN}/g" $cloneFolder/check_users_activity.py
echo "0  */3    * * *   root    $cloneFolder/check_users_activity.py >> ~/cron.log 2>&1" >> /etc/crontab
systemctl restart cron

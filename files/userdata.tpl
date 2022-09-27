#!/bin/bash
sudo yum -y update
sudo yum install git-all python3 -y
sudo yum install -y jq


# Installing Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install 8.5

SECRET=`aws secretsmanager get-secret-value --region us-west-1 --secret-id GITHUB_TOKEN --query SecretString --output text | jq -r .SECRET`


#Need to read secret from aws secrets manager and authenticate
cd /home/ec2-user
git clone https://rayala3314:$SECRET@github.com/LousAutoGlass.git

cd LousAutoGlass

npm install

npm install -g pm2

# pm2 start server.js 
# pm2 save 
# pm2 startup systemd
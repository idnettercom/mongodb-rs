#!/bin/bash
sudo apt-get install gnupg curl -y

# Import the public key 
curl -fsSL https://pgp.mongodb.com/server-6.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg \
   --dearmor

# Add repository
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

# Update
sudo apt-get update -y

# Install MongoDB 6:latest
sudo apt-get install -y mongodb-org

# Do on MongoDB Master only
# Generate key
mkdir -p /etc/mongodb/keys/
openssl rand -base64 756 > /etc/mongodb/keys/mykey
chmod 400 /etc/mongodb/keys/mykey
chown -R mongodb:mongodb /etc/mongodb

# Backup original mongod.conf and create one
mv /etc/mongod.conf /etc/mongod.conf_bak
cat << "EOF" | tee /etc/mongod.conf
storage:
  dbPath: /var/lib/mongodb
  journal:
    enabled: true

systemLog:
  destination: file
  path: /var/log/mongodb/mongod.log
  logAppend: true

net:
  bindIp: 0.0.0.0
  port: 27017

security:
 authorization: enabled
 keyFile:  /etc/mongodb/keys/mykey

replication:
  replSetName: myrs
EOF


# Start mongod
service mongod restart

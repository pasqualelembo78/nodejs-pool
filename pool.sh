#!/bin/bash

set -e

# Aggiorna sistema e installa dipendenze
apt update && apt upgrade -y
apt install -y build-essential python make gcc g++ git curl mariadb-server
npm install -g pm2
# Installa Node.js 10
curl -sL https://deb.nodesource.com/setup_10.x | bash -
apt install -y nodejs
sudo apt install php7.4-curl
# Clona il repository del pool (sostituisci con il tuo fork se serve)
cd /opt
# git clone https://github.com/pasqualelembo78/nodejs-pool.git mevapool
cd mevapool

# Installa pacchetti npm
npm install || true

# Avvia e abilita MariaDB
systemctl enable mariadb
systemctl start mariadb
mysql -u root -p mevapool < /opt/mevapool/deployment/base.sql

mkdir -p /opt/mevapool/logs
mkdir -p /opt/mevapool/json_rpc_logs
mkdir -p /opt/mevapool/block_share_dumps

chmod 755 /opt/mevapool/logs /opt/mevapool/json_rpc_logs /opt/mevapool/block_share_dumps

# File di configurazione iniziale
ufw allow 8001/tcp
ufw reload
EOF
cd ~/nodejs-pool/
pm2 start init.js --name=blockManager --log-date-format="YYYY-MM-DD HH:mm Z"  -- --module=blockManager
pm2 start init.js --name=worker --log-date-format="YYYY-MM-DD HH:mm Z" -- --module=worker
pm2 start init.js --name=payments --log-date-format="YYYY-MM-DD HH:mm Z" -- --module=payments
pm2 start init.js --name=remoteShare --log-date-format="YYYY-MM-DD HH:mm Z" -- --module=remoteShare
pm2 start init.js --name=longRunner --log-date-format="YYYY-MM-DD HH:mm Z" -- --module=longRunner
pm2 start init.js --name=pool --log-date-format="YYYY-MM-DD HH:mm Z" -- --module=pool

pm2 start init.js --name api -- --module=api

echo "Installazione completata. Ora puoi avviare il pool con:"
echo "  node init.js"

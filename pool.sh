#!/bin/bash

set -e

# Aggiorna sistema e installa dipendenze
apt update && apt upgrade -y
apt install -y build-essential python make gcc g++ git curl mariadb-server

# Installa Node.js 10
curl -sL https://deb.nodesource.com/setup_10.x | bash -
apt install -y nodejs

# Clona il repository del pool (sostituisci con il tuo fork se serve)
cd /opt
git clone https://github.com/MoneroOcean/nodejs-pool.git mevapool
cd mevapool

# Installa pacchetti npm
npm install || true

# Avvia e abilita MariaDB
systemctl enable mariadb
systemctl start mariadb

# Sicurezza MariaDB automatizzata (opzionale, modifica se vuoi input manuale)
mysql -u root <<EOF
CREATE DATABASE mevapool;
CREATE USER 'mevauser'@'localhost' IDENTIFIED BY 'mevapass';
GRANT ALL PRIVILEGES ON mevapool.* TO 'mevauser'@'localhost';
FLUSH PRIVILEGES;
EOF

# File di configurazione iniziale
cat > config.json <<EOF
{
  "pool_id": 0,
  "bind_ip": "0.0.0.0",
  "hostname": "mevapool.local",
  "db_storage_path": "storage/",
  "coin": "xmr",
  "mysql": {
    "connectionLimit": 20,
    "host": "127.0.0.1",
    "database": "mevapool",
    "user": "mevauser",
    "password": "mevapass"
  }
}
EOF

echo "Installazione completata. Ora puoi avviare il pool con:"
echo "  node init.js"

# Installa requisiti per compilare moduli nativi
apt update && apt install -y curl build-essential python g++ make

# Rimuovi la vecchia versione di Node.js (facoltativo)
apt remove -y nodejs

# Installa Node.js 18.x (LTS)
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

# Verifica versione aggiornata
node -v
npm -v

# Entra nella cartella del mining pool
cd /opt/mevapool

# Rimuovi dipendenze vecchie
rm -rf node_modules package-lock.json

# Reinstalla tutte le dipendenze
npm install

# Riavvia i processi con PM2
pm2 restart all

# Controlla se l'API ora ascolta correttamente sulla porta 8117
ss -tulpn | grep 8117

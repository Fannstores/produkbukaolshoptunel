#!/bin/bash

# Warna
cyan='\e[0;36m'
green='\e[0;32m'
nc='\e[0m'

# Bersihkan Layar
clear

echo -e "${cyan}=======================================${nc}"
echo -e "${cyan}   INSTALLER OTOMATIS BUKAOLSHOP VPS   ${nc}"
echo -e "${cyan}=======================================${nc}"
echo -e ""

# --- BAGIAN TANYA (INPUT) ---
# Script akan berhenti di sini untuk minta jawabanmu
read -p "1. Masukkan Token Bot Telegram: " tele_token
read -p "2. Masukkan ID Telegram Admin: " tele_id
read -p "3. Masukkan API Key BukaOlshop: " bo_api
read -p "4. Masukkan Subdomain API (Misal: api.fanstore-vip.pro): " domain_api

echo -e ""
echo -e "${green}[*] Memulai instalasi, mohon tunggu...${nc}"

# Install Webserver
apt update && apt install nginx php-fpm php-curl php-cli -y

# Buat Folder
mkdir -p /var/www/html/api

# Download File PHP (Pastikan link ini benar ke repo kamu)
wget -O /var/www/html/api/bukaolshop.php "https://raw.githubusercontent.com/Fannstores/produkbukaolshoptunel/main/bukaolshop.php"

# Ganti Placeholder di PHP dengan hasil input tadi
sed -i "s/TOKEN_TELE_PLACEHOLDER/$tele_token/g" /var/www/html/api/bukaolshop.php
sed -i "s/ID_TELE_PLACEHOLDER/$tele_id/g" /var/www/html/api/bukaolshop.php
sed -i "s/API_BO_PLACEHOLDER/$bo_api/g" /var/www/html/api/bukaolshop.php
sed -i "s/DOMAIN_PLACEHOLDER/$domain_api/g" /var/www/html/api/bukaolshop.php

# Setting Nginx
cat > /etc/nginx/sites-available/bukaolshop <<EOF
server {
    listen 80;
    server_name $domain_api;
    root /var/www/html;
    index index.php index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php-fpm.sock;
    }
}
EOF

# Aktifkan Nginx
ln -sf /etc/nginx/sites-available/bukaolshop /etc/nginx/sites-enabled/
systemctl restart nginx

# Izin Sudo
echo "www-data ALL=(ALL) NOPASSWD: /usr/bin/create-ssh.sh, /usr/bin/create-vmess.sh, /usr/bin/create-vless.sh, /usr/bin/create-trojan.sh, /usr/bin/create-zivpn.sh" >> /etc/sudoers

echo -e ""
echo -e "${green}=======================================${nc}"
echo -e "${green}  INSTALASI BERHASIL!                  ${nc}"
echo -e "${green}  Silakan setting Callback di BO.      ${nc}"
echo -e "${green}=======================================${nc}"

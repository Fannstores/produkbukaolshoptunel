#!/bin/bash

# Warna
cyan='\e[0;36m'
green='\e[0;32m'
nc='\e[0m'

clear

echo -e "${cyan}=======================================${nc}"
echo -e "${cyan}   INSTALLER OTOMATIS BUKAOLSHOP VPS   ${nc}"
echo -e "${cyan}=======================================${nc}"
echo -e ""

# 1. Tanya Data
read -p "Token Bot Telegram: " tele_token
read -p "ID Telegram Admin : " tele_id
read -p "API Key BukaOlshop: " bo_api
read -p "Subdomain API (ex: api.domain.com): " domain_api

# 2. Update & Install
echo -e "${green}[*] Menginstall Nginx & PHP...${nc}"
apt-get update -y
apt-get install nginx php-fpm php-curl php-cli -y

# 3. Download PHP
echo -e "${green}[*] Mengunduh script PHP...${nc}"
mkdir -p /var/www/html/api
wget -qO /var/www/html/api/bukaolshop.php "https://raw.githubusercontent.com/Fannstores/produkbukaolshoptunel/main/bukaolshop.php"

# 4. Ganti Variable di PHP (Pakai pemisah | agar aman dari karakter khusus)
echo -e "${green}[*] Konfigurasi token...${nc}"
sed -i "s|TOKEN_TELE_PLACEHOLDER|$tele_token|g" /var/www/html/api/bukaolshop.php
sed -i "s|ID_TELE_PLACEHOLDER|$tele_id|g" /var/www/html/api/bukaolshop.php
sed -i "s|API_BO_PLACEHOLDER|$bo_api|g" /var/www/html/api/bukaolshop.php
sed -i "s|DOMAIN_PLACEHOLDER|$domain_api|g" /var/www/html/api/bukaolshop.php

# 5. Konfigurasi Nginx
echo -e "${green}[*] Menyiapkan konfigurasi Nginx...${nc}"
rm -f /etc/nginx/sites-available/bukaolshop
printf "server {\n    listen 80;\n    server_name %s;\n    root /var/www/html;\n    index index.php index.html;\n    location / {\n        try_files \$uri \$uri/ =404;\n    }\n    location ~ \.php$ {\n        include snippets/fastcgi-php.conf;\n        fastcgi_pass unix:/run/php/php-fpm.sock;\n    }\n}\n" "$domain_api" > /etc/nginx/sites-available/bukaolshop

# 6. Aktifkan
ln -sf /etc/nginx/sites-available/bukaolshop /etc/nginx/sites-enabled/
systemctl restart nginx

# 7. Izin Sudo (Cara paling aman)
echo "www-data ALL=(ALL) NOPASSWD: /usr/bin/create-ssh.sh, /usr/bin/create-vmess.sh, /usr/bin/create-vless.sh, /usr/bin/create-trojan.sh, /usr/bin/create-zivpn.sh" > /etc/sudoers.d/bukaolshop

echo -e ""
echo -e "${green}=======================================${nc}"
echo -e "${green}  INSTALASI SELESAI!                   ${nc}"
echo -e "${green}  URL: https://$domain_api/api/bukaolshop.php ${nc}"
echo -e "${green}=======================================${nc}"

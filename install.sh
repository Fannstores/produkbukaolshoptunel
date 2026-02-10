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

# 1. Tanya Data (Input)
echo -e "${cyan}[>] Masukkan data yang diminta:${nc}"
read -p "Token Bot Telegram: " tele_token
read -p "ID Telegram Admin : " tele_id
read -p "API Key BukaOlshop: " bo_api
read -p "Subdomain API (ex: api.domain.com): " domain_api

# 2. Update & Install Dependency
echo -e "${green}[*] Menginstall Nginx & PHP-FPM...${nc}"
apt-get update -y
apt-get install nginx php-fpm php-curl php-cli -y

# 3. Download PHP Script
echo -e "${green}[*] Mengunduh script PHP...${nc}"
mkdir -p /var/www/html/api
wget -O /var/www/html/api/bukaolshop.php "https://raw.githubusercontent.com/Fannstores/produkbukaolshoptunel/main/bukaolshop.php"

# 4. Ganti Variable di PHP
echo -e "${green}[*] Konfigurasi token...${nc}"
sed -i "s/TOKEN_TELE_PLACEHOLDER/$tele_token/g" /var/www/html/api/bukaolshop.php
sed -i "s/ID_TELE_PLACEHOLDER/$tele_id/g" /var/www/html/api/bukaolshop.php
sed -i "s/API_BO_PLACEHOLDER/$bo_api/g" /var/www/html/api/bukaolshop.php
sed -i "s/DOMAIN_PLACEHOLDER/$domain_api/g" /var/www/html/api/bukaolshop.php

# 5. Konfigurasi Nginx (Versi Aman)
echo -e "${green}[*] Menyiapkan konfigurasi Nginx...${nc}"
# Kita hapus file lama jika ada agar tidak bentrok
rm -f /etc/nginx/sites-available/bukaolshop

# Pakai cara echo satu-satu biar nggak error di EOF
echo "server {" > /etc/nginx/sites-available/bukaolshop
echo "    listen 80;" >> /etc/nginx/sites-available/bukaolshop
echo "    server_name $domain_api;" >> /etc/nginx/sites-available/bukaolshop
echo "    root /var/www/html;" >> /etc/nginx/sites-available/bukaolshop
echo "    index index.php index.html;" >> /etc/nginx/sites-available/bukaolshop
echo "    location / {" >> /etc/nginx/sites-available/bukaolshop
echo "        try_files \$uri \$uri/ =404;" >> /etc/nginx/sites-available/bukaolshop
echo "    }" >> /etc/nginx/sites-available/bukaolshop
echo "    location ~ \.php$ {" >> /etc/nginx/sites-available/bukaolshop
echo "        include snippets/fastcgi-php.conf;" >> /etc/nginx/sites-available/bukaolshop
echo "        fastcgi_pass unix:/run/php/php-fpm.sock;" >> /etc/nginx/sites-available/bukaolshop
echo "    }" >> /etc/nginx/sites-available/bukaolshop
echo "}" >> /etc/nginx/sites-available/bukaolshop

# 6. Aktifkan & Restart
ln -sf /etc/nginx/sites-available/bukaolshop /etc/nginx/sites-enabled/
nginx -t && systemctl restart nginx

# 7. Izin Sudo (Tambahkan di baris baru agar tidak rusak)
sed -i '/www-data/d' /etc/sudoers # hapus baris lama jika ada biar nggak dobel
echo "www-data ALL=(ALL) NOPASSWD: /usr/bin/create-ssh.sh, /usr/bin/create-vmess.sh, /usr/bin/create-vless.sh, /usr/bin/create-trojan.sh, /usr/bin/create-zivpn.sh" >> /etc/sudoers

echo -e ""
echo -e "${green}=======================================${nc}"
echo -e "${green}  INSTALASI BERHASIL!                  ${nc}"
echo -e "${green}  URL: https://$domain_api/api/bukaolshop.php ${nc}"
echo -e "${green}=======================================${nc}"

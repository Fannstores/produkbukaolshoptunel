#!/bin/bash
# Script Auto-Install Jembatan BukaOlshop

# Warna
cyan='\e[0;36m'
green='\e[0;32m'
nc='\e[0m'

echo -e "${cyan}=======================================${nc}"
echo -e "${cyan}   INSTALLER OTOMATIS BUKAOLSHOP VPS   ${nc}"
echo -e "${cyan}=======================================${nc}"

# 1. Tanya Data ke User
read -p "Masukkan Token Bot Telegram: " tele_token
read -p "Masukkan ID Telegram Admin: " tele_id
read -p "Masukkan API Key BukaOlshop: " bo_api
read -p "Masukkan Subdomain API (contoh: api.fanstore-vip.pro): " domain_api

# 2. Install Dependency
echo -e "${green}[*] Menginstall Nginx & PHP...${nc}"
apt update && apt install nginx php-fpm php-curl php-cli -y

# 3. Download File PHP Core dari GitHub kamu
echo -e "${green}[*] Mengunduh script PHP...${nc}"
mkdir -p /var/www/html/api
# GANTI URL DI BAWAH INI DENGAN URL GITHUB KAMU SENDIRI
wget -O /var/www/html/api/bukaolshop.php "https://github.com/Fannstores/produkbukaolshoptunel/main/bukaolshop.php"

# 4. Masukkan Token ke File PHP (Otomatis)
sed -i "s/TOKEN_TELE_PLACEHOLDER/$tele_token/g" /var/www/html/api/bukaolshop.php
sed -i "s/ID_TELE_PLACEHOLDER/$tele_id/g" /var/www/html/api/bukaolshop.php
sed -i "s/API_BO_PLACEHOLDER/$bo_api/g" /var/www/html/api/bukaolshop.php
sed -i "s/DOMAIN_PLACEHOLDER/$domain_api/g" /var/www/html/api/bukaolshop.php

# 5. Konfigurasi Nginx (Agar tidak menghapus yang lama)
echo -e "${green}[*] Menyiapkan konfigurasi Nginx...${nc}"
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

ln -sf /etc/nginx/sites-available/bukaolshop /etc/nginx/sites-enabled/
nginx -t && systemctl restart nginx

# 6. Atur Izin Sudo (Penting buat create akun)
echo -e "${green}[*] Mengatur izin sudo...${nc}"
echo "www-data ALL=(ALL) NOPASSWD: /usr/bin/create-ssh.sh, /usr/bin/create-vmess.sh, /usr/bin/create-vless.sh, /usr/bin/create-trojan.sh, /usr/bin/create-zivpn.sh" >> /etc/sudoers

echo -e "${cyan}=======================================${nc}"
echo -e "${green} SELESAI! URL CALLBACK KAMU: ${nc}"
echo -e " https://$domain_api/api/bukaolshop.php "
echo -e "${cyan}=======================================${nc}"


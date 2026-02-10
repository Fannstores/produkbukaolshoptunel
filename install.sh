#!/bin/bash

# Warna
cyan='\e[0;36m'
green='\e[0;32m'
red='\e[0;31m'
nc='\e[0m'

clear
echo -e "${cyan}=======================================${nc}"
echo -e "${cyan}   INSTALLER BUKAOLSHOP + MENU CEK     ${nc}"
echo -e "${cyan}=======================================${nc}"

# 1. Tanya Data
read -p "Token Bot Telegram: " tele_token
read -p "ID Telegram Admin : " tele_id
read -p "API Key BukaOlshop: " bo_api
read -p "Subdomain API (ex: api.domain.com): " domain_api

# 2. Update & Install
echo -e "${green}[*] Menginstall Nginx & PHP...${nc}"
apt-get update -y
apt-get install nginx php-fpm php-curl php-cli -y > /dev/null 2>&1

# 3. Download PHP Utama
echo -e "${green}[*] Mengunduh script PHP...${nc}"
mkdir -p /var/www/html/api
wget -qO /var/www/html/api/bukaolshop.php "https://raw.githubusercontent.com/Fannstores/produkbukaolshoptunel/main/bukaolshop.php"

# 4. Konfigurasi Token (Safe Delimiter)
sed -i "s|TOKEN_TELE_PLACEHOLDER|$tele_token|g" /var/www/html/api/bukaolshop.php
sed -i "s|ID_TELE_PLACEHOLDER|$tele_id|g" /var/www/html/api/bukaolshop.php
sed -i "s|API_BO_PLACEHOLDER|$bo_api|g" /var/www/html/api/bukaolshop.php
sed -i "s|DOMAIN_PLACEHOLDER|$domain_api|g" /var/www/html/api/bukaolshop.php

# 5. Membuat File CEK.PHP (Menu Monitoring)
cat > /var/www/html/api/cek.php <<EOF
<?php
echo "<h2>🔍 Status Sistem BukaOlshop VPS</h2>";
echo "🟢 Web Server: <b>Running</b><br>";
echo "🟢 PHP-FPM: <b>Active</b><br>";
echo "📅 Waktu Server: " . date('Y-m-d H:i:s') . "<br><br>";
echo "📂 Script Path: /var/www/html/api/bukaolshop.php<br>";
echo "🔗 Callback: https://$domain_api/api/bukaolshop.php<br><br>";
echo "🛠 <b>Pengecekan Izin Sudo:</b><br>";
\$check = shell_exec('sudo -n uptime 2>&1');
if (strpos(\$check, 'load average') !== false) {
    echo "✅ Sudo Permission: <b>OKE (Berhasil)</b>";
} else {
    echo "❌ Sudo Permission: <b>GAGAL (Cek Izin Sudoers)</b>";
}
?>
EOF

# 6. Konfigurasi Nginx (Stable Version)
printf "server {\n    listen 80;\n    server_name %s;\n    root /var/www/html;\n    index index.php index.html;\n    location / {\n        try_files \$uri \$uri/ =404;\n    }\n    location ~ \.php$ {\n        include snippets/fastcgi-php.conf;\n        fastcgi_pass unix:/run/php/php-fpm.sock;\n    }\n}\n" "$domain_api" > /etc/nginx/sites-available/bukaolshop

ln -sf /etc/nginx/sites-available/bukaolshop /etc/nginx/sites-enabled/
systemctl restart nginx

# 7. Izin Sudo Khusus
mkdir -p /etc/sudoers.d
echo "www-data ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/bukaolshop
chmod 440 /etc/sudoers.d/bukaolshop

echo -e ""
echo -e "${green}=======================================${nc}"
echo -e "${green}  INSTALASI SELESAI!                   ${nc}"
echo -e "${cyan}  Link Callback: https://$domain_api/api/bukaolshop.php ${nc}"
echo -e "${cyan}  Link Cek Error: https://$domain_api/api/cek.php ${nc}"
echo -e "${green}=======================================${nc}"

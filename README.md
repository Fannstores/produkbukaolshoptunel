# produkbukaolshoptunel
# 🚀 BukaOlshop VPS Tunneling Automation

Script jembatan otomatis (Middleware) untuk menghubungkan **BukaOlshop** dengan **VPS Tunneling**. Akun VPN langsung jadi dalam hitungan detik setelah pembayaran dikonfirmasi!

---

## 🛠 Fitur Utama
* ✅ **Otomatisasi Penuh**: Tidak perlu manual buat akun lagi.
* ✅ **8 Slot Produk**: Mendukung SSH, Vmess, Vless, Trojan, & ZiVPN.
* ✅ **Smart Resource**: Limit 2 IP Login & Kuota GB per user.
* ✅ **Telegram Notif**: Laporan orderan masuk langsung ke HP kamu.
* ✅ **Dual Route**: Mendukung HTTPS Cloudflare (Proxy ON) untuk API.

---

## 📥 Cara Instalasi (Copy & Paste)

Buka terminal VPS kamu (Root), salin kode di bawah ini, lalu tekan **Enter**:

```bash
wget -qO- [https://raw.githubusercontent.com/Fannstores/produkbukaolshoptunel/main/install.sh](https://raw.githubusercontent.com/Fannstores/produkbukaolshoptunel/main/install.sh) | bash

​🔄 Cara Update Paksa (Sync GitHub)
​Jika kamu mengubah ID Produk atau Kuota di GitHub, gunakan perintah ini untuk memperbarui file di VPS tanpa install ulang:
rm -f /var/www/html/api/bukaolshop.php && wget -O /var/www/html/api/bukaolshop.php "[https://raw.githubusercontent.com/Fannstores/produkbukaolshoptunel/main/bukaolshop.php](https://raw.githubusercontent.com/Fannstores/produkbukaolshoptunel/main/bukaolshop.php)" && echo "Berhasil Update dari GitHub!"


⚙️ Cara Penggunaan di BukaOlshop
1. Pastikan Subdomain API kamu di Cloudflare sudah Proxy ON (Orange) 🟠.
2. Set SSL Cloudflare ke mode Flexible.
3. Masukkan URL Callback berikut di Panel BukaOlshop:
[https://api.domainmu.com/api/bukaolshop.php](https://api.domainmu.com/api/bukaolshop.php)

📞 Hubungi Layanan Pelanggan (CS)
Jika ada kendala instalasi atau ingin kustomisasi script, silakan hubungi kami:
| Platform | Link Kontak | Jam Kerja |
|---|---|---|
| Telegram | ✉️ Chat di Telegram | 24/7 Fast Respond |
| WhatsApp | 📱 Chat di WhatsApp | 08:00 - 22:00 WIB |
📋 Catatan Penting
 * Pastikan script pembuat akun kamu berada di /usr/bin/ dengan nama:
   * create-ssh.sh, create-vmess.sh, create-vless.sh, create-trojan.sh, create-zivpn.sh
 * Pastikan izin sudoers sudah terkonfigurasi dengan benar melalui installer.
Dibuat oleh [Fanstore VIP] 🗿

---

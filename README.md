# produkbukaolshoptunel
🚀 BukaOlshop VPS Tunneling Automation
Script jembatan otomatis untuk menghubungkan BukaOlshop dengan VPS Tunneling. Support otomatisasi pembuatan akun SSH, Vmess, Vless, Trojan, dan ZiVPN dengan pembatasan IP serta Kuota GB.
🛠 Fitur Utama
 * ✅ Otomatisasi Penuh: Akun dibuat detik itu juga setelah pembayaran.
 * ✅ Multi-Protocol: Support 8 jenis produk (SSH/Vmess/Vless/Trojan/ZiVPN).
 * ✅ Manajemen Resource: Limit 2 IP Login dan Kuota GB per akun.
 * ✅ Notifikasi Real-time: Laporan transaksi langsung ke Telegram Admin.
 * ✅ Update Tanpa Ribet: Fitur update paksa jika ada perubahan ID Produk.
📥 Cara Instalasi Pertama Kali
Buka terminal VPS kamu (sebagai root), lalu jalankan perintah sakti di bawah ini:
wget -qO- https://github.com/Fannstores/produkbukaolshoptunel/main/install.sh | bash

> Note: Saat instalasi, script akan meminta input Token Bot Telegram, API Key BukaOlshop, dan Domain API kamu.
> 
🔄 Cara Update (Ganti ID Produk / Perbaikan)
Jika kamu ingin mengganti ID produk, menambah kuota, atau melakukan update setelah mengedit file di GitHub, gunakan perintah Update Paksa ini di VPS:  rm -f /var/www/html/api/bukaolshop.php && wget -O /var/www/html/api/bukaolshop.php "https://raw.githubusercontent.com/Fannstores/produkbukaolshoptunel/main/bukaolshop.php" && sed -i "s/TOKEN_TELE_PLACEHOLDER/TOKEN_LAMA_MU/g" /var/www/html/api/bukaolshop.php && echo "Update Berhasil!"

Atau cara paling bersih adalah menjalankan ulang installer (Langkah 📥) agar semua variabel terbaru ikut terpasang.
⚙️ Cara Penggunaan (Callback)
 * Pastikan Proxy Cloudflare di subdomain API kamu sudah ON (Orange) 🟠.
 * Set SSL Cloudflare ke Flexible.
 * Buka Dashboard BukaOlshop > Pengaturan > API & Callback.
 * Masukkan URL berikut di kolom Callback:
   https://api.fanstore-vip.pro/api/bukaolshop.php
 * Klik Simpan. Pastikan muncul notif sukses (Kode 200).
📋 Daftar ID Produk (Mapping)
Edit file bukaolshop.php di GitHub kamu untuk menyesuaikan ID Produk:
| ID Produk | Nama Layanan | Masa Aktif | Limit IP | Kuota GB |
|---|---|---|---|---|
| 101 | SSH Premium | 30 Hari | 2 IP | 50 GB |
| 102 | Vmess VIP | 30 Hari | 2 IP | 100 GB |
| ... | ... | ... | ... | ... |
📞 Hubungi Layanan Pelanggan
Jika mengalami kendala teknis atau butuh bantuan instalasi, silakan hubungi CS kami:
| Platform | Kontak |
|---|---|
| Telegram | @fauziid |
| WhatsApp | +62 812-4758-6568 |
| Owner | [Fanstore VIP Support] |
🛡 Lisensi
Dibuat dengan ❤️ untuk komunitas Tunneling Indonesia. Gunakan dengan bijak!
Tips Tambahan buat Kamu:
 * Ganti Username: Jangan lupa ganti semua tulisan USERNAME_KAMU dan REPO_KAMU dengan data asli GitHub-mu.

<?php
http_response_code(200);

$TOKEN_TELEGRAM = "TOKEN_TELE_PLACEHOLDER"; 
$CHAT_ID_ADMIN  = "ID_TELE_PLACEHOLDER";
$API_KEY_BO     = "API_BO_PLACEHOLDER";
$HOST_VPN       = "vps.DOMAIN_PLACEHOLDER"; 

// DAFTAR 8 PRODUK (Ganti ID angka di bawah ini dengan ID BukaOlshop kamu)
$daftar_produk = [
    "101" => ["nama"=>"SSH 30D 50GB", "type"=>"ssh", "masa"=>30, "ip"=>2, "gb"=>50],
    "102" => ["nama"=>"VMESS 30D 100GB", "type"=>"vmess", "masa"=>30, "ip"=>2, "gb"=>100],
    "103" => ["nama"=>"VLESS 30D 100GB", "type"=>"vless", "masa"=>30, "ip"=>2, "gb"=>100],
    "104" => ["nama"=>"TROJAN 30D 100GB", "type"=>"trojan", "masa"=>30, "ip"=>2, "gb"=>100],
    "105" => ["nama"=>"ZIVPN 30D 50GB", "type"=>"zivpn", "masa"=>30, "ip"=>2, "gb"=>50],
    "106" => ["nama"=>"SSH 7D 10GB", "type"=>"ssh", "masa"=>7, "ip"=>2, "gb"=>10],
    "107" => ["nama"=>"VMESS 7D 20GB", "type"=>"vmess", "masa"=>7, "ip"=>2, "gb"=>20],
    "108" => ["nama"=>"VLESS 7D 20GB", "type"=>"vless", "masa"=>7, "ip"=>2, "gb"=>20],
];

$id_produk    = $_POST['id_produk'] ?? '';
$nama_user    = preg_replace('/\s+/', '', $_POST['catatan_pembeli'] ?? 'user');
$id_transaksi = $_POST['id_transaksi'] ?? '';

if (isset($daftar_produk[$id_produk])) {
    $p = $daftar_produk[$id_produk];
    $cmd = "sudo /usr/bin/create-{$p['type']}.sh $nama_user {$p['ip']} {$p['gb']} {$p['masa']}";
    $hasil_config = shell_exec($cmd);

    // Notif Telegram
    file_get_contents("https://api.telegram.org/bot$TOKEN_TELEGRAM/sendMessage?chat_id=$CHAT_ID_ADMIN&text=".urlencode("✅ Pesanan $nama_user Berhasil!"));

    // Update BukaOlshop
    $exp = date('d-m-Y', strtotime("+{$p['masa']} days"));
    $catatan = "DETAIL AKUN:\nHost: $HOST_VPN\n\n$hasil_config";
    
    $data_post = [
        'auth_key' => $API_KEY_BO,
        'id_transaksi' => $id_transaksi,
        'catatan' => $catatan,
        'sn' => "Exp: $exp | Limit: {$p['ip']} IP | {$p['gb']}GB",
        'status' => 'dikirim'
    ];

    $ch = curl_init("https://pribadi.bukaolshop.com/api/v1/transaksi/update_catatan");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $data_post);
    curl_exec($ch);
    curl_close($ch);
}
?>


<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        // Create demo users
        $customer = \App\Models\User::create([
            'username' => 'pengguna',
            'email' => 'pengguna@trackly.com',
            'password' => \Illuminate\Support\Facades\Hash::make('pengguna123'),
            'full_name' => 'Pengguna Trackly',
            'phone_number' => '081234567890',
            'role' => 'customer',
        ]);

        $courier = \App\Models\User::create([
            'username' => 'kurir',
            'email' => 'kurir@trackly.com',
            'password' => \Illuminate\Support\Facades\Hash::make('kurir123'),
            'full_name' => 'Kurir Trackly',
            'phone_number' => '081298765432',
            'role' => 'courier',
        ]);

        $staff = \App\Models\User::create([
            'username' => 'staff',
            'email' => 'staff@trackly.com',
            'password' => \Illuminate\Support\Facades\Hash::make('staff123'),
            'full_name' => 'Staff Gudang',
            'phone_number' => '081290123456',
            'role' => 'staff',
        ]);

        // Create sample tracking history
        \App\Models\RiwayatPengiriman::create([
            'nomor_resi' => 'JNE123456789',
            'ekspedisi' => 'jne',
            'pengirim' => 'Toko Online',
            'penerima' => 'John Doe',
            'alamat_penerima' => 'Jl. Sudirman No. 123, Jakarta',
            'status_terakhir' => 'DELIVERED',
            'detail_tracking' => [
                ['date' => '2024-01-01', 'status' => 'Package received'],
                ['date' => '2024-01-02', 'status' => 'In transit'],
                ['date' => '2024-01-03', 'status' => 'Delivered'],
            ],
            'tanggal_cek' => now(),
        ]);

        // Create courier deliveries
        \App\Models\CourierDelivery::create([
            'nomor_resi' => 'JNE987654321',
            'ekspedisi' => 'jne',
            'penerima' => 'Jane Smith',
            'alamat_antar' => 'Jl. Thamrin No. 456, Jakarta',
            'status' => 'pending',
            'berat' => 2.5,
            'biaya' => 15000,
            'courier_id' => $courier->id,
        ]);

        \App\Models\CourierDelivery::create([
            'nomor_resi' => 'SICEPAT111222333',
            'ekspedisi' => 'sicepat',
            'penerima' => 'Bob Wilson',
            'alamat_antar' => 'Jl. Gatot Subroto No. 789, Jakarta',
            'status' => 'in_transit',
            'berat' => 1.2,
            'biaya' => 12000,
            'courier_id' => $courier->id,
        ]);

        // Create staff shipments
        \App\Models\StaffShipment::create([
            'resi' => 'JNE555666777',
            'pengirim' => 'Supplier A',
            'tujuan' => 'Jakarta',
            'status' => 'incoming',
            'tanggal_masuk' => now(),
            'staff_id' => $staff->id,
        ]);

        \App\Models\StaffShipment::create([
            'resi' => 'TIKI888999000',
            'pengirim' => 'Supplier B',
            'tujuan' => 'Bandung',
            'status' => 'received',
            'tanggal_masuk' => now()->subDays(1),
            'tanggal_proses' => now(),
            'staff_id' => $staff->id,
        ]);

        // Create inventory items
        \App\Models\InventoryItem::create([
            'nama' => 'Paket Kecil',
            'lokasi' => 'Rak A1',
            'stok' => 50,
            'stok_minimum' => 10,
            'deskripsi' => 'Paket ukuran kecil untuk pengiriman',
        ]);

        \App\Models\InventoryItem::create([
            'nama' => 'Paket Sedang',
            'lokasi' => 'Rak B2',
            'stok' => 5,
            'stok_minimum' => 15,
            'deskripsi' => 'Paket ukuran sedang',
        ]);

        \App\Models\InventoryItem::create([
            'nama' => 'Paket Besar',
            'lokasi' => 'Rak C3',
            'stok' => 25,
            'stok_minimum' => 5,
            'deskripsi' => 'Paket ukuran besar',
        ]);
    }
}

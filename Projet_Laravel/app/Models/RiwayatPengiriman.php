<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RiwayatPengiriman extends Model
{
    use HasFactory;

    protected $table = 'riwayat_pengiriman';

    protected $fillable = [
        'nomor_resi',
        'ekspedisi',
        'pengirim',
        'penerima',
        'alamat_penerima',
        'status_terakhir',
        'detail_tracking',
        'tanggal_cek',
    ];

    protected $casts = [
        'detail_tracking' => 'array',
        'tanggal_cek' => 'datetime',
    ];
}
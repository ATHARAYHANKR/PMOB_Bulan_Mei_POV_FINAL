<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CourierDelivery extends Model
{
    use HasFactory;

    protected $fillable = [
        'nomor_resi',
        'ekspedisi',
        'penerima',
        'alamat_antar',
        'status',
        'berat',
        'biaya',
        'tanggal_pickup',
        'tanggal_antar',
        'catatan',
        'courier_id',
    ];

    protected $casts = [
        'berat' => 'decimal:2',
        'biaya' => 'decimal:2',
        'tanggal_pickup' => 'datetime',
        'tanggal_antar' => 'datetime',
    ];

    public function courier(): BelongsTo
    {
        return $this->belongsTo(User::class, 'courier_id');
    }
}
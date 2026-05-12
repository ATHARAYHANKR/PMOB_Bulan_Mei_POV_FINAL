<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class StaffShipment extends Model
{
    use HasFactory;

    protected $fillable = [
        'resi',
        'pengirim',
        'tujuan',
        'status',
        'tanggal_masuk',
        'tanggal_proses',
        'catatan',
        'staff_id',
    ];

    protected $casts = [
        'tanggal_masuk' => 'datetime',
        'tanggal_proses' => 'datetime',
    ];

    public function staff(): BelongsTo
    {
        return $this->belongsTo(User::class, 'staff_id');
    }
}
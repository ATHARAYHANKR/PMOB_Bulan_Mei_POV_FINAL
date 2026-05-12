<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('riwayat_pengiriman', function (Blueprint $table) {
            $table->id();
            $table->string('nomor_resi');
            $table->string('ekspedisi');
            $table->string('pengirim');
            $table->string('penerima');
            $table->text('alamat_penerima');
            $table->string('status_terakhir');
            $table->json('detail_tracking')->nullable();
            $table->timestamp('tanggal_cek');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('riwayat_pengiriman');
    }
};
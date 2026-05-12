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
        Schema::create('courier_deliveries', function (Blueprint $table) {
            $table->id();
            $table->string('nomor_resi');
            $table->string('ekspedisi');
            $table->string('penerima');
            $table->text('alamat_antar');
            $table->string('status')->default('pending');
            $table->decimal('berat', 8, 2)->nullable();
            $table->decimal('biaya', 10, 2)->nullable();
            $table->timestamp('tanggal_pickup')->nullable();
            $table->timestamp('tanggal_antar')->nullable();
            $table->text('catatan')->nullable();
            $table->unsignedBigInteger('courier_id');
            $table->timestamps();

            $table->foreign('courier_id')->references('id')->on('users');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('courier_deliveries');
    }
};
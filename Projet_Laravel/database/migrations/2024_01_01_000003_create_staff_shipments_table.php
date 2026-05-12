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
        Schema::create('staff_shipments', function (Blueprint $table) {
            $table->id();
            $table->string('resi');
            $table->string('pengirim');
            $table->string('tujuan');
            $table->string('status')->default('incoming');
            $table->timestamp('tanggal_masuk');
            $table->timestamp('tanggal_proses')->nullable();
            $table->text('catatan')->nullable();
            $table->unsignedBigInteger('staff_id');
            $table->timestamps();

            $table->foreign('staff_id')->references('id')->on('users');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('staff_shipments');
    }
};
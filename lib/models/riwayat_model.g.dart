// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riwayat_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RiwayatPengirimanAdapter extends TypeAdapter<RiwayatPengiriman> {
  @override
  final int typeId = 0;

  @override
  RiwayatPengiriman read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RiwayatPengiriman(
      nomorResi: fields[0] as String,
      ekspedisi: fields[1] as String,
      statusTerakhir: fields[2] as String,
      tanggalCek: fields[3] as DateTime,
      pengirim: fields[4] as String,
      penerima: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RiwayatPengiriman obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.nomorResi)
      ..writeByte(1)
      ..write(obj.ekspedisi)
      ..writeByte(2)
      ..write(obj.statusTerakhir)
      ..writeByte(3)
      ..write(obj.tanggalCek)
      ..writeByte(4)
      ..write(obj.pengirim)
      ..writeByte(5)
      ..write(obj.penerima);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RiwayatPengirimanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

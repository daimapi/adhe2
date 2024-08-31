// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'words_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordsAdapter extends TypeAdapter<Words> {
  @override
  final int typeId = 1;

  @override
  Words read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Words(
      voc: fields[0] as String,
      trans: fields[1] as String,
      pos: fields[2] as String,
      timestamp: fields[3] as DateTime,
      pp: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Words obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.voc)
      ..writeByte(1)
      ..write(obj.trans)
      ..writeByte(2)
      ..write(obj.pos)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.pp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

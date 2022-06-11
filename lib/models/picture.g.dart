// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picture.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PictureAdapter extends TypeAdapter<Picture> {
  @override
  final int typeId = 0;


  @override
  Picture read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Picture()
      ..path = fields[0] as String
      ..name = fields[1] as String
      ..confidence = fields[2] as double;
  }

  @override
  void write(BinaryWriter writer, Picture obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.path)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.confidence);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PictureAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BuildingsUA.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BuildingsUAAdapter extends TypeAdapter<BuildingsUA> {
  @override
  final int typeId = 0;

  @override
  BuildingsUA read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BuildingsUA(
      brbBuildingName: fields[0] as String,
      brbBuildingId: fields[1] as int,
      realBuildingName: fields[2] as String,
      lat: fields[3] as double,
      long: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, BuildingsUA obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.brbBuildingName)
      ..writeByte(1)
      ..write(obj.brbBuildingId)
      ..writeByte(2)
      ..write(obj.realBuildingName)
      ..writeByte(3)
      ..write(obj.lat)
      ..writeByte(4)
      ..write(obj.long);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BuildingsUAAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

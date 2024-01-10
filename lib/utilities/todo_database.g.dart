// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_database.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TileDataAdapter extends TypeAdapter<TileData> {
  @override
  final int typeId = 1;

  @override
  TileData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TileData(
      taskNameData: fields[0] as String,
      taskCompletedData: fields[3] as bool,
      taskDateData: fields[2] as DateTime?,
      descrData: fields[1] as String,
      notifActiveData: fields[4] as bool,
      notifSoundData: fields[5] as String,
      idNotifify: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TileData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.taskNameData)
      ..writeByte(1)
      ..write(obj.descrData)
      ..writeByte(2)
      ..write(obj.taskDateData)
      ..writeByte(3)
      ..write(obj.taskCompletedData)
      ..writeByte(4)
      ..write(obj.notifActiveData)
      ..writeByte(5)
      ..write(obj.notifSoundData)
      ..writeByte(6)
      ..write(obj.idNotifify);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TileDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

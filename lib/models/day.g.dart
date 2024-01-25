// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DayAdapter extends TypeAdapter<Day> {
  @override
  final int typeId = 1;

  @override
  Day read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Day(
      id: fields[0] as int,
      english: fields[1] as String,
      burmese: fields[2] as String,
      isFullMoon: fields[3] as bool?,
      holiday: fields[4] as String?,
      fortune: fields[5] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Day obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.english)
      ..writeByte(2)
      ..write(obj.burmese)
      ..writeByte(3)
      ..write(obj.isFullMoon)
      ..writeByte(4)
      ..write(obj.holiday)
      ..writeByte(5)
      ..write(obj.fortune);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

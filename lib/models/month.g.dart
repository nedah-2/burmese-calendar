// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'month.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MonthAdapter extends TypeAdapter<Month> {
  @override
  final int typeId = 0;

  @override
  Month read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Month(
      id: fields[0] as int,
      english: fields[1] as String,
      burmese: fields[2] as String,
      headOne: fields[3] as String,
      headTwo: fields[4] as String,
      dayList: (fields[5] as List).cast<Day>(),
    );
  }

  @override
  void write(BinaryWriter writer, Month obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.english)
      ..writeByte(2)
      ..write(obj.burmese)
      ..writeByte(3)
      ..write(obj.headOne)
      ..writeByte(4)
      ..write(obj.headTwo)
      ..writeByte(5)
      ..write(obj.dayList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

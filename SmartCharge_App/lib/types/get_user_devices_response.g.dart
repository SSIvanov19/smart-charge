// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_devices_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeviceAdapter extends TypeAdapter<Device> {
  @override
  final int typeId = 2;

  @override
  Device read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Device(
      fields[0] as String,
      id: fields[0] as String,
      type: fields[1] as String,
      category: fields[2] as String,
      position: fields[3] as int,
      gen: fields[4] as int,
      channel: fields[5] as int,
      channelsCount: fields[6] as int,
      mode: fields[7] as String,
      name: fields[8] as String,
      roomId: fields[9] as int,
      image: fields[10] as String,
      excludeEventLog: fields[11] as bool,
      bundle: fields[12] as bool,
      ip: fields[13] as String,
      modified: fields[14] as int,
      cloudOnline: fields[15] as bool,
      ssid: fields[16] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Device obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.position)
      ..writeByte(4)
      ..write(obj.gen)
      ..writeByte(5)
      ..write(obj.channel)
      ..writeByte(6)
      ..write(obj.channelsCount)
      ..writeByte(7)
      ..write(obj.mode)
      ..writeByte(8)
      ..write(obj.name)
      ..writeByte(9)
      ..write(obj.roomId)
      ..writeByte(10)
      ..write(obj.image)
      ..writeByte(11)
      ..write(obj.excludeEventLog)
      ..writeByte(12)
      ..write(obj.bundle)
      ..writeByte(13)
      ..write(obj.ip)
      ..writeByte(14)
      ..write(obj.modified)
      ..writeByte(15)
      ..write(obj.cloudOnline)
      ..writeByte(16)
      ..write(obj.ssid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

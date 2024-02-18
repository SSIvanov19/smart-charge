import 'package:hive/hive.dart';
import 'package:yee_mobile_app/types/get_device_status_response.dart';
part 'get_user_devices_response.g.dart';

class GetUserDevicesResponse {
  bool isok;
  Data data;

  GetUserDevicesResponse({required this.isok, required this.data});

  factory GetUserDevicesResponse.fromJson(Map<String, dynamic> json) {
    return GetUserDevicesResponse(
      isok: json['isok'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  Map<String, Device> devices;
  Map<String, Room> rooms;
  Map<String, Group> groups;
  Map<String, Dashboard> dashboards;

  Data(
      {required this.devices,
      required this.rooms,
      required this.groups,
      required this.dashboards});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      devices: (json['devices'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, Device.fromJson(value))),
      rooms: (json['rooms'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, Room.fromJson(value))),
      groups: (json['groups'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, Group.fromJson(value))),
      dashboards: (json['dashboards'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, Dashboard.fromJson(value))),
    );
  }
}

// Define Device, Room, Group, Dashboard classes
@HiveType(typeId: 2)
class Device {
  @HiveField(0)
  String id;

  @HiveField(1)
  String type;

  @HiveField(2)
  String category;

  @HiveField(3)
  int position;

  @HiveField(4)
  int gen;

  @HiveField(5)
  int channel;

  @HiveField(6)
  int channelsCount;
  
  @HiveField(7)
  String mode;

  @HiveField(8)
  String name;

  @HiveField(9)
  int roomId;

  @HiveField(10)
  String image;

  @HiveField(11)
  bool excludeEventLog;

  @HiveField(12)
  bool bundle;

  @HiveField(13)
  String ip;

  @HiveField(14)
  int modified;

  @HiveField(15)
  bool cloudOnline;

  @HiveField(16)
  String ssid;

  @HiveField(17)
  DeviceStatus? deviceStatus;

  Device(
    key, {
    required this.id,
    required this.type,
    required this.category,
    required this.position,
    required this.gen,
    required this.channel,
    required this.channelsCount,
    required this.mode,
    required this.name,
    required this.roomId,
    required this.image,
    required this.excludeEventLog,
    required this.bundle,
    required this.ip,
    required this.modified,
    required this.cloudOnline,
    required this.ssid,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      json['id'],
      id: json['id'],
      type: json['type'],
      category: json['category'],
      position: json['position'],
      gen: json['gen'],
      channel: json['channel'],
      channelsCount: json['channels_count'],
      mode: json['mode'],
      name: json['name'],
      roomId: json['room_id'],
      image: json['image'],
      excludeEventLog: json['exclude_event_log'] ?? false,
      bundle: json['bundle'] ?? false,
      ip: json['ip'],
      modified: json['modified'],
      cloudOnline: json['cloud_online'],
      ssid: json['ssid'],
    );
  }
}

class Room {
  String name;
  String image;
  bool mainSensor;
  bool overviewStyle;
  int position;
  int id;
  int modified;

  Room({
    required this.name,
    required this.image,
    required this.mainSensor,
    required this.overviewStyle,
    required this.position,
    required this.id,
    required this.modified,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      name: json['name'],
      image: json['image'],
      mainSensor: json['main_sensor'],
      overviewStyle: json['overview_style'],
      position: json['position'],
      id: json['id'],
      modified: json['modified'],
    );
  }
}

class Group {
  String name;
  String image;
  String type;
  List<String> devices;
  int roomId;
  int position;
  int id;
  int modified;

  Group({
    required this.name,
    required this.image,
    required this.type,
    required this.devices,
    required this.roomId,
    required this.position,
    required this.id,
    required this.modified,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      name: json['name'],
      image: json['image'],
      type: json['type'],
      devices: List<String>.from(json['devices']),
      roomId: json['room_id'],
      position: json['position'],
      id: json['id'],
      modified: json['modified'],
    );
  }
}

class Dashboard {
  int id;
  String name;
  int position;
  dynamic notification;
  String route;
  Map<String, dynamic> devices;
  List<Room> rooms;
  List<Group> groups;
  List<dynamic> scenes;
  List<dynamic> alarms;
  List<dynamic> tempSchemes;
  String image;
  int modified;

  Dashboard({
    required this.id,
    required this.name,
    required this.position,
    required this.notification,
    required this.route,
    required this.devices,
    required this.rooms,
    required this.groups,
    required this.scenes,
    required this.alarms,
    required this.tempSchemes,
    required this.image,
    required this.modified,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      notification: json['notification'],
      route: json['route'],
      devices: json['devices'],
      rooms: List<Room>.from(json['rooms']),
      groups: List<Group>.from(json['groups']),
      scenes: List<dynamic>.from(json['scenes']),
      alarms: List<dynamic>.from(json['alarms']),
      tempSchemes: List<dynamic>.from(json['temp_schemes']),
      image: json['image'],
      modified: json['modified'],
    );
  }
}
import 'package:yee_mobile_app/types/get_device_status_response.dart';

class StatusOnChangeResponse {
  String event;
  List<int> ul;
  List<String> rl;
  Device device;
  DeviceStatus? status;
  DeviceStatus? oldStatus;
  List<dynamic> integrations;
  List<Metadata> metadata;

  StatusOnChangeResponse({
    required this.event,
    required this.ul,
    required this.rl,
    required this.device,
    required this.status,
    required this.oldStatus,
    required this.integrations,
    required this.metadata,
  });

  factory StatusOnChangeResponse.fromJson(Map<String, dynamic> json) {
    return StatusOnChangeResponse(
      event: json['event'],
      ul: List<int>.from(json['ul'].map((x) => x)),
      rl: List<String>.from(json['rl'].map((x) => x)),
      device: Device.fromJson(json['device']),
      status: DeviceStatus.fromJson(json['status']),
      oldStatus: DeviceStatus.fromJson(json['oldStatus']),
      integrations: List<dynamic>.from(json['integrations'].map((x) => x)),
      metadata: List<Metadata>.from(json['metadata'].map((x) => Metadata.fromJson(x))),
    );
  }
}

class Device {
  String id;
  String type;
  String code;
  String mode;
  bool sleeps;
  double lat;
  double lng;
  String gen;

  Device({
    required this.id,
    required this.type,
    required this.code,
    required this.mode,
    required this.sleeps,
    required this.lat,
    required this.lng,
    required this.gen,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: int.parse(json['id']).toRadixString(16).toLowerCase().padLeft(6, "0"),
      type: json['type'],
      code: json['code'],
      mode: json['mode'],
      sleeps: json['sleeps'],
      lat: json['lat'],
      lng: json['lng'],
      gen: json['gen'],
    );
  }
}

class Metadata {
  String name;
  int rid;
  String purpose;
  bool eld;

  Metadata({
    required this.name,
    required this.rid,
    required this.purpose,
    required this.eld,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      name: json['name'],
      rid: json['rid'],
      purpose: json['purpose'],
      eld: json['eld'],
    );
  }
}

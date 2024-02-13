class GetDeviceStatusResponse {
  bool isOk;
  Data data;

  GetDeviceStatusResponse({
    required this.isOk,
    required this.data,
  });

  factory GetDeviceStatusResponse.fromJson(Map<String, dynamic> json) {
    return GetDeviceStatusResponse(
      isOk: json['isok'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  Map<String, DeviceStatus> devicesStatus;
  Map<String, dynamic> pendingNotifications;

  Data({
    required this.devicesStatus,
    required this.pendingNotifications,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      devicesStatus: (json['devices_status'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, DeviceStatus.fromJson(value)),
      ),
      pendingNotifications: json['pending_notifications'],
    );
  }
}

class DeviceStatus {
  GetInfo getInfo;
  ActionsStats actionsStats;
  double temperature;
  bool hasUpdate;
  bool overtemperature;
  int ramTotal;
  WifiSta wifiSta;
  int serial;
  Cloud cloud;
  Update update;
  Mqtt mqtt;
  int fsFree;
  List<Relay> relays;
  String time;
  int cfgChangedCnt;
  int uptime;
  int ramFree;
  String updated;
  List<Meter> meters;
  String mac;
  int unixtime;
  Tmp tmp;
  int fsSize;

  DeviceStatus({
    required this.getInfo,
    required this.actionsStats,
    required this.temperature,
    required this.hasUpdate,
    required this.overtemperature,
    required this.ramTotal,
    required this.wifiSta,
    required this.serial,
    required this.cloud,
    required this.update,
    required this.mqtt,
    required this.fsFree,
    required this.relays,
    required this.time,
    required this.cfgChangedCnt,
    required this.uptime,
    required this.ramFree,
    required this.updated,
    required this.meters,
    required this.mac,
    required this.unixtime,
    required this.tmp,
    required this.fsSize,
  });

  factory DeviceStatus.fromJson(Map<String, dynamic> json) {
    return DeviceStatus(
      getInfo: GetInfo.fromJson(json['getinfo']),
      actionsStats: ActionsStats.fromJson(json['actions_stats']),
      temperature: json['temperature'],
      hasUpdate: json['has_update'],
      overtemperature: json['overtemperature'],
      ramTotal: json['ram_total'],
      wifiSta: WifiSta.fromJson(json['wifi_sta']),
      serial: json['serial'],
      cloud: Cloud.fromJson(json['cloud']),
      update: Update.fromJson(json['update']),
      mqtt: Mqtt.fromJson(json['mqtt']),
      fsFree: json['fs_free'],
      relays: List<Relay>.from(json['relays'].map((x) => Relay.fromJson(x))),
      time: json['time'],
      cfgChangedCnt: json['cfg_changed_cnt'],
      uptime: json['uptime'],
      ramFree: json['ram_free'],
      updated: (json['_updated'] ?? ""),
      meters: List<Meter>.from(json['meters'].map((x) => Meter.fromJson(x))),
      mac: json['mac'],
      unixtime: json['unixtime'],
      tmp: Tmp.fromJson(json['tmp']),
      fsSize: json['fs_size'],
    );
  }
}

class GetInfo {
  FwInfo fwInfo;

  GetInfo({required this.fwInfo});

  factory GetInfo.fromJson(Map<String, dynamic> json) {
    return GetInfo(
      fwInfo: FwInfo.fromJson(json['fw_info']),
    );
  }
}

class FwInfo {
  String device;
  String fw;

  FwInfo({required this.device, required this.fw});

  factory FwInfo.fromJson(Map<String, dynamic> json) {
    return FwInfo(
      device: json['device'],
      fw: json['fw'],
    );
  }
}

class ActionsStats {
  int skipped;

  ActionsStats({required this.skipped});

  factory ActionsStats.fromJson(Map<String, dynamic> json) {
    return ActionsStats(
      skipped: json['skipped'],
    );
  }
}

class WifiSta {
  bool connected;
  String ssid;
  String ip;
  int rssi;

  WifiSta(
      {required this.connected,
      required this.ssid,
      required this.ip,
      required this.rssi});

  factory WifiSta.fromJson(Map<String, dynamic> json) {
    return WifiSta(
      connected: json['connected'],
      ssid: json['ssid'],
      ip: json['ip'],
      rssi: json['rssi'],
    );
  }
}

class Cloud {
  bool enabled;
  bool connected;

  Cloud({required this.enabled, required this.connected});

  factory Cloud.fromJson(Map<String, dynamic> json) {
    return Cloud(
      enabled: json['enabled'],
      connected: json['connected'],
    );
  }
}

class Update {
  String status;
  bool hasUpdate;
  String newVersion;
  String oldVersion;
  String betaVersion;

  Update(
      {required this.status,
      required this.hasUpdate,
      required this.newVersion,
      required this.oldVersion,
      required this.betaVersion});

  factory Update.fromJson(Map<String, dynamic> json) {
    return Update(
      status: json['status'],
      hasUpdate: json['has_update'],
      newVersion: json['new_version'],
      oldVersion: json['old_version'],
      betaVersion: json['beta_version'] ?? "",
    );
  }
}

class Mqtt {
  bool connected;

  Mqtt({required this.connected});

  factory Mqtt.fromJson(Map<String, dynamic> json) {
    return Mqtt(
      connected: json['connected'],
    );
  }
}

class Relay {
  bool ison;
  bool hasTimer;
  int timerStarted;
  int timerDuration;
  int timerRemaining;
  bool overpower;
  String source;

  Relay(
      {required this.ison,
      required this.hasTimer,
      required this.timerStarted,
      required this.timerDuration,
      required this.timerRemaining,
      required this.overpower,
      required this.source});

  factory Relay.fromJson(Map<String, dynamic> json) {
    return Relay(
      ison: json['ison'],
      hasTimer: json['has_timer'],
      timerStarted: json['timer_started'],
      timerDuration: json['timer_duration'],
      timerRemaining: json['timer_remaining'],
      overpower: json['overpower'],
      source: json['source'],
    );
  }
}

class Meter {
  int power;
  int overpower;
  bool isValid;
  int timestamp;
  List<int> counters;
  int total;

  Meter(
      {required this.power,
      required this.overpower,
      required this.isValid,
      required this.timestamp,
      required this.counters,
      required this.total});

  factory Meter.fromJson(Map<String, dynamic> json) {
    return Meter(
      power: json['power'],
      overpower: json['overpower'],
      isValid: json['is_valid'],
      timestamp: json['timestamp'],
      counters: List<int>.from(json['counters'].map((x) => x)),
      total: json['total'],
    );
  }
}

class Tmp {
  double tC;
  double tF;
  bool isValid;

  Tmp({required this.tC, required this.tF, required this.isValid});

  factory Tmp.fromJson(Map<String, dynamic> json) {
    return Tmp(
      tC: json['tC'],
      tF: (json['tF'] != null ? json['tF'].toDouble() : 0.0),
      isValid: json['is_valid'],
    );
  }
}

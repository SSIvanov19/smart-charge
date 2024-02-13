import 'package:yee_mobile_app/types/get_device_status_response.dart';
import 'package:yee_mobile_app/types/get_user_devices_response.dart';

class GetUserSettingsResponse {
  bool isok;
  Data data;

  GetUserSettingsResponse({required this.isok, required this.data});

  factory GetUserSettingsResponse.fromJson(Map<String, dynamic> json) {
    return GetUserSettingsResponse(
      isok: json['isok'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  Settings settings;

  Data({required this.settings});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      settings: Settings.fromJson(json['settings']),
    );
  }
}

class Settings {
  int pushNotificationsPermissions;
  int mailNotificationsPermissions;
  String lang;
  String timezone;
  int mailValidated;
  int newsletter;
  String name;
  Units units;
  String avatar;
  bool beenPremium;

  Settings({
    required this.pushNotificationsPermissions,
    required this.mailNotificationsPermissions,
    required this.lang,
    required this.timezone,
    required this.mailValidated,
    required this.newsletter,
    required this.name,
    required this.units,
    required this.avatar,
    required this.beenPremium,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      pushNotificationsPermissions: json['push_notifications_permissions'],
      mailNotificationsPermissions: json['mail_notifications_permissions'],
      lang: json['lang'],
      timezone: json['timezone'],
      mailValidated: json['mail_validated'],
      newsletter: json['newsletter'],
      name: json['name'],
      units: Units.fromJson(json['units']),
      avatar: json['avatar'],
      beenPremium: json['been_premium'],
    );
  }
}

class Units {
  String tempUnit;
  String dateFormat;

  Units({required this.tempUnit, required this.dateFormat});

  factory Units.fromJson(Map<String, dynamic> json) {
    return Units(
      tempUnit: json['temp_unit'],
      dateFormat: json['date_format'],
    );
  }
}


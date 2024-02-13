import 'package:hive/hive.dart';

import 'authentication_service.dart';

abstract class WebApiService {
  Map<String, String> generateHeader() {
    var user = Hive.box<User>("user").get("user");

    return {
      'Authorization': 'Bearer ${user?.accessToken ?? ""}',
    };
  }

  String getBaseUrl() {
    return Hive.box<User>("user").get("user")?.userApiUrl ?? "";
  }
}

import 'dart:convert';

import 'package:http/http.dart';
import 'package:yee_mobile_app/services/web_api_service.dart';
import 'package:yee_mobile_app/types/get_user_settings_response.dart';
import 'package:http/http.dart' as http;

class UserService extends WebApiService {
  Future<GetUserSettingsResponse> getUserSettings() async {
    var response = await http.get(
        Uri.parse("${getBaseUrl()}/user/get_settings"),
        headers: generateHeader());

    return GetUserSettingsResponse.fromJson(jsonDecode(response.body));
  }

  Future<Response> setUsername(String username) async {
    return await http.post(
      Uri.parse("${getBaseUrl()}/user/set_screen_name"),
      headers: generateHeader(),
      body: {
        "name": username,
      }
    );
  }
}

import 'dart:convert';

import 'package:yee_mobile_app/services/web_api_service.dart';
import 'package:yee_mobile_app/types/get_device_status_response.dart';
import 'package:yee_mobile_app/types/get_user_devices_response.dart';
import 'package:http/http.dart' as http;

class DeviceService extends WebApiService {
  Future<GetUserDevicesResponse> getDevices() async {
    var response = await http.get(
        Uri.parse("${getBaseUrl()}/interface/device/get_all_lists"),
        headers: generateHeader());

    return GetUserDevicesResponse.fromJson(jsonDecode(response.body));
  }

  Future<GetDeviceStatusResponse> getDeviceStatus() async {
    var response = await http.get(
        Uri.parse("${getBaseUrl()}/device/all_status"),
        headers: generateHeader());

    return GetDeviceStatusResponse.fromJson(jsonDecode(response.body));
  }
}

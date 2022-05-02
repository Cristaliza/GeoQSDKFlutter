import 'dart:async';
import 'package:flutter/services.dart';

abstract class Geoq {
  static const MethodChannel _channel = const MethodChannel('geoq');

  void onGeoQRegisterSuccess(String deviceId);
  void onGeoQRegisterWarning(String deviceId);
  void onGeoQRegisterError(String error);
  void onGeoQGetUserPermissionSuccess(String result);
  void onGeoQGetUserPermissionError(String result);
  void onGeoQSetUserPermissionSuccess(String result);
  void onGeoQSetUserPermissionError(String result);
  void onGeoQUpdateExtraDataSuccess(String result);
  void onGeoQUpdateExtraDataError(String result);
  void locationChangeEvent(String latitude, String longitude);
  void dataEvent(String source, String value);
  void pushEvent(Object data);

  void initialize() {
    var callResult;
    _channel.setMethodCallHandler((call) {
      print(call.method);
      switch (call.method) {
        case 'onGeoQRegisterSuccess':
          onGeoQRegisterSuccess(call.arguments);
          break;
        case 'onGeoQRegisterWarning':
          onGeoQRegisterWarning(call.arguments);
          break;
        case 'onGeoQRegisterError':
          onGeoQRegisterError(call.arguments);
          break;

        case 'onGeoQGetUserPermissionSuccess':
          onGeoQGetUserPermissionSuccess(call.arguments);
          break;
        case 'onGeoQGetUserPermissionError':
          onGeoQGetUserPermissionError(call.arguments);
          break;
        case 'onGeoQSetUserPermissionSuccess':
          onGeoQSetUserPermissionSuccess(call.arguments);
          break;
        case 'onGeoQSetUserPermissionError':
          onGeoQSetUserPermissionError(call.arguments);
          break;
        case 'onGeoQUpdateExtraDataSuccess':
          onGeoQUpdateExtraDataSuccess(call.arguments);
          break;
        case 'onGeoQUpdateExtraDataError':
          onGeoQUpdateExtraDataError(call.arguments);
          break;
        case 'locationChangeEvent':
          locationChangeEvent(
              call.arguments['latitude'], call.arguments['longitude']);
          break;
        case 'locationChangeEvent':
          dataEvent(call.arguments['source'], call.arguments['value']);
          break;
        case 'pushEvent':
          pushEvent(call.arguments);
          break;
        default:
          print(call.method + 'Not found');
      }
      return callResult;
    });
  }

  static Future<String?> initGeoQ(String apiKey, String notificationTitle,
      String notificationDescription) async {
    String? deviceId = await _channel.invokeMethod('initGeoQ', {
      "apiKey": apiKey,
      "notificationTitle": notificationTitle,
      "notificationDescription": notificationDescription
    });
    return deviceId;
  }

  static Future<String?> legalPermissions() async {
    String? result = await _channel.invokeMethod('legalPermissions');
    return result;
  }

  static Future<String?> subscribeToEvents() async {
    String? result = await _channel.invokeMethod('subscribeToEvents');
    return result;
  }

  static Future<String?> getUserPermission(String perm) async {
    String? result =
        await _channel.invokeMethod('getUserPermission', {"perm": perm});
    return result;
  }

  static Future<String?> setUserPermission(String perm, bool value) async {
    String? result = await _channel
        .invokeMethod('setUserPermission', {"perm": perm, "value": value});
    return result;
  }

  static Future<String?> updateExtraData(String extraData) async {
    String? result = await _channel
        .invokeMethod('updateExtraData', {"extraData": extraData});
    return result;
  }

  static Future<String?> getAdIdWithPermission() async {
    String? result = await _channel.invokeMethod('getAdIdWithPermission');
    return result;
  }

  static Future<String?> getProfile() async {
    String? result = await _channel.invokeMethod('getProfile');
    return result;
  }
}

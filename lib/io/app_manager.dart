
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppManager {
  static late SharedPreferences _preferences;
  static Future<void> initAppData() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static String getUsername(){
    return _preferences.getString('username') ?? "";
  }

  static Future<void> setUsername(String name) async {
    await _preferences.setString('username', name);
  }

  static bool isUserLoggedIn(){
    return _preferences.getBool('logged-in') ?? false;
  }

  static bool isLightMode(){
    return _preferences.getBool('light-mode') ?? true;
  }

  static Future<void> setLightMode(bool value) async {
    await _preferences.setBool('light-mode', value);
  }

}




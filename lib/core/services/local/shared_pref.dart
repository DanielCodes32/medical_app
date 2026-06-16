import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medical_app/features/auth/data/models/auth_response/user.dart';

class SharedPref {
  static late final SharedPreferences pref;
  static const ktoken = "token";
  static const kuser = "user";
  static const kotp = "otp";
  static const kfavourite = "favourite";

  static Future<void> init() async {
    pref = await SharedPreferences.getInstance();
  }

  static Future<void> saveWishlist(List<String> ids) async {
    await pref.setStringList(kfavourite, ids);
  }

  static List<String> getWishlist() {
    return pref.getStringList(kfavourite) ?? [];
  }

  static Future<void> savetoken(String? token) async {
    if (token == null) return;
    await pref.setString(ktoken, token);
  }

  static String gettoken() {
    return pref.getString(ktoken) ?? "";
  }

  static Future<void> saveotp(String? otp) async {
    if (otp == null) return;
    await pref.setString(kotp, otp);
  }

  static String getotp() {
    return pref.getString(kotp) ?? "";
  }

  static Future<void> setstring(String key, String value) async {
    await pref.setString(key, value);
  }

  static String getstring(String key) {
    return pref.getString(key) ?? "";
  }

  static Future<void> setbool(String key, bool value) async {
    await pref.setBool(key, value);
  }

  static bool getbool(String key) {
    return pref.getBool(key) ?? false;
  }

  static Future<void> saveuserinfo(User? user) async {
    if (user == null) return;
    await pref.setString(kuser, jsonEncode(user.toJson()));
  }

  static User? getuserinfo() {
    final userStr = pref.getString(kuser);
    if (userStr == null || userStr.isEmpty) return null;
    return User.fromJson(jsonDecode(userStr) as Map<String, dynamic>);
  }
}

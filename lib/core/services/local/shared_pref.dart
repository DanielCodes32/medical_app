import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medical_app/features/auth/data/models/auth_response/user.dart';

class SharedPref {
  static late final SharedPreferences pref;
  static const ktoken = "token";
  static const kuser = "user";
  static const kotp = "otp";
  static const kuserId = "forgot_user_id";
  static const kfavourite = "favourite";

  static const kspecializedId = "specialized_id";
  static const kprofileComplete = "is_patient_profile_complete";
  static const kpatientImage = "patient_image";
  static const kpatientMobile = "patient_mobile";
  static const kpatientGender = "patient_gender";
  static const kpatientDobDay = "patient_dob_day";
  static const kpatientDobMonth = "patient_dob_month";
  static const kpatientDobYear = "patient_dob_year";

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

  static Future<void> saveUserId(int? userId) async {
    if (userId == null) return;
    await pref.setInt(kuserId, userId);
  }

  static int getUserId() {
    return pref.getInt(kuserId) ?? 11;
  }

  static Future<void> saveSpecializedId(int? specializedId) async {
    if (specializedId == null) return;
    await pref.setInt(kspecializedId, specializedId);
  }

  static int getSpecializedId() {
    final specialized = pref.getInt(kspecializedId);
    if (specialized != null) return specialized;
    return getuserinfo()?.id ?? getUserId();
  }

  static Future<void> setProfileComplete(bool value) async {
    await pref.setBool(kprofileComplete, value);
  }

  static bool isProfileComplete() {
    return pref.getBool(kprofileComplete) ?? false;
  }

  static Future<void> savePatientProfileLocal({
    String? image,
    String? mobile,
    String? gender,
    int? day,
    int? month,
    int? year,
  }) async {
    if (image != null) await pref.setString(kpatientImage, image);
    if (mobile != null) await pref.setString(kpatientMobile, mobile);
    if (gender != null) await pref.setString(kpatientGender, gender);
    if (day != null) await pref.setInt(kpatientDobDay, day);
    if (month != null) await pref.setInt(kpatientDobMonth, month);
    if (year != null) await pref.setInt(kpatientDobYear, year);
    await setProfileComplete(true);
  }

  static String getPatientImage() => pref.getString(kpatientImage) ?? "";
  static String getPatientMobile() => pref.getString(kpatientMobile) ?? "";
  static String getPatientGender() => pref.getString(kpatientGender) ?? "";
  static int? getPatientDobDay() => pref.getInt(kpatientDobDay);
  static int? getPatientDobMonth() => pref.getInt(kpatientDobMonth);
  static int? getPatientDobYear() => pref.getInt(kpatientDobYear);

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
    if (user == null) {
      log("user is null");
      return;
    } else {
      log(user.toJson().toString());
    }
    await pref.setString(kuser, jsonEncode(user.toJson()));
    await saveSpecializedId(user.specializedId);
  }

  static User? getuserinfo() {
    final userStr = pref.getString(kuser);
    if (userStr == null || userStr.isEmpty) return null;
    return User.fromJson(jsonDecode(userStr) as Map<String, dynamic>);
  }
}

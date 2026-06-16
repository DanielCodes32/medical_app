import 'dart:developer';

import 'package:medical_app/core/services/apis/apis.dart';
import 'package:medical_app/core/services/apis/dio_provider.dart';
import 'package:medical_app/core/services/local/shared_pref.dart';
import 'package:medical_app/features/auth/data/models/auth_response/auth_response.dart';
import 'package:medical_app/features/auth/data/models/authparams.dart';

class AuthRepo {
  static Future<AuthResponse?> login(Authparams params) async {
    try {
      var response = await DioProvider.post(
        endpoint: Apis.login,
        data: params.toJson(),
      );
      if (response.statusCode == 200) {
        var data = AuthResponse.fromJson(response.data as Map<String, dynamic>);
        SharedPref.savetoken(data.data?.token);
        SharedPref.saveuserinfo(data.data?.user);
        return data;
      } else {
        return null;
      }
    } on Exception catch (err) {
      log(err.toString());
      return null;
    }
  }

  static Future<AuthResponse?> register(Authparams params) async {
    try {
      var response = await DioProvider.post(
        endpoint: Apis.register,
        data: params.toJson(),
      );
      if (response.statusCode == 201) {
        var data = AuthResponse.fromJson(response.data as Map<String, dynamic>);
        SharedPref.savetoken(data.data?.token);
        SharedPref.saveuserinfo(data.data?.user);
        return data;
      } else {
        return null;
      }
    } on Exception catch (err) {
      log(err.toString());
      return null;
    }
  }
}
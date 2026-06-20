import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:medical_app/core/services/apis/apis.dart';
import 'package:medical_app/core/services/apis/dio_provider.dart';
import 'package:medical_app/core/services/local/shared_pref.dart';
import 'package:medical_app/features/auth/data/models/api_result.dart';
import 'package:medical_app/features/auth/data/models/auth_response/auth_response.dart';
import 'package:medical_app/features/auth/data/models/authparams.dart';
import 'package:medical_app/features/auth/data/models/forgot_password_params.dart';

class AuthRepo {
  static Future<AuthResponse?> login(Authparams params) async {
    try {
      var response = await DioProvider.post(
        endpoint: Apis.login,
        data: params.toJson(),
      );
      if (response.statusCode == 200) {
        var data = AuthResponse.fromJson(response.data as Map<String, dynamic>);
        await SharedPref.savetoken(data.data?.token);
        await SharedPref.saveuserinfo(data.data?.user);
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
        return data;
      } else {
        return null;
      }
    } on Exception catch (err) {
      log(err.toString());
      return null;
    }
  }

  static Future<ApiResult> forgotPassword(ForgotPasswordParams params) async {
    try {
      var response = await DioProvider.post(
        endpoint: Apis.forgotPassword,
        data: params.toJson(),
      );
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final dataMap = responseData['data'] as Map<String, dynamic>?;
        
        final userId = dataMap?['userid'] as int?;
        await SharedPref.saveUserId(userId);
        return ApiResult(
          success: true,
          message: dataMap?['message'] as String? ?? responseData['message'] as String?,
          data: responseData,
        );
      } else {
        return ApiResult(success: false, message: "Something went wrong");
      }
    } on DioException catch (err) {
      final errorData = err.response?.data;
      String errorMsg = "Something went wrong";
      if (errorData is Map<String, dynamic>) {
        errorMsg = errorData['message'] as String? ?? errorMsg;
      }
      log(err.toString());
      return ApiResult(success: false, message: errorMsg);
    } on Exception catch (err) {
      log(err.toString());
      return ApiResult(success: false, message: "Something went wrong");
    }
  }

  static Future<ApiResult> verifyOtp(VerifyOtpParams params) async {
    try {
      var response = await DioProvider.post(
        endpoint: Apis.verifyOtp,
        data: params.toJson(),
      );
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final dataMap = responseData['data'] as Map<String, dynamic>?;
        return ApiResult(
          success: true,
          message: dataMap?['message'] as String? ?? responseData['message'] as String?,
          data: responseData,
        );
      } else {
        return ApiResult(success: false, message: "Invalid OTP");
      }
    } on DioException catch (err) {
      final errorData = err.response?.data;
      String errorMsg = "Invalid OTP";
      if (errorData is Map<String, dynamic>) {
        errorMsg = errorData['message'] as String? ?? errorMsg;
      }
      log(err.toString());
      return ApiResult(success: false, message: errorMsg);
    } on Exception catch (err) {
      log(err.toString());
      return ApiResult(success: false, message: "Something went wrong");
    }
  }

  static Future<ApiResult> resetPassword(ResetPasswordParams params) async {
    try {
      var response = await DioProvider.post(
        endpoint: Apis.resetPassword,
        data: params.toJson(),
      );
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final dataMap = responseData['data'] as Map<String, dynamic>?;
        return ApiResult(
          success: true,
          message: dataMap?['message'] as String? ?? responseData['message'] as String?,
          data: responseData,
        );
      } else {
        return ApiResult(success: false, message: "Something went wrong");
      }
    } on DioException catch (err) {
      final errorData = err.response?.data;
      String errorMsg = "Something went wrong";
      if (errorData is Map<String, dynamic>) {
        errorMsg = errorData['message'] as String? ?? errorMsg;
      }
      log(err.toString());
      return ApiResult(success: false, message: errorMsg);
    } on Exception catch (err) {
      log(err.toString());
      return ApiResult(success: false, message: "Something went wrong");
    }
  }
}

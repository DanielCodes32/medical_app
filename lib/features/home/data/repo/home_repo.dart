import 'dart:developer';

import 'package:medical_app/core/services/apis/apis.dart';
import 'package:medical_app/core/services/apis/dio_provider.dart';
import 'package:medical_app/core/services/local/shared_pref.dart';
import 'package:medical_app/features/home/data/models/popular_doctors_response/popular_doctors_response.dart';

class HomeRepo {
  static Future<PopularDoctorsResponse?> getPopularDoctors({int page = 1, int limit = 10}) async {
    try {
      var response = await DioProvider.get(
        endpoint: Apis.popularDoctors,
        headers: {"Authorization": "Bearer ${SharedPref.gettoken()}"},
        queryParameters: {
          "page": page,
          "limit": limit,
        },
      );
      if (response.statusCode == 200) {
        var data = PopularDoctorsResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
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

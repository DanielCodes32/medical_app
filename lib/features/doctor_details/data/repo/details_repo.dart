import 'dart:developer';

import 'package:medical_app/core/services/apis/apis.dart';
import 'package:medical_app/core/services/apis/dio_provider.dart';
import 'package:medical_app/core/services/local/shared_pref.dart';
import 'package:medical_app/features/doctor_details/data/models/doctor_details_response/doctor_details_response.dart';

class DetailsRepo {
  Future<DoctorDetailsResponse?> getDoctorDetails(String id) async {
    try {
      var response = await DioProvider.get(
        endpoint: Apis.doctorDetails.replaceAll(':id', id),
        headers: {"Authorization": "Bearer ${SharedPref.gettoken()}"},
      );
      if (response.statusCode == 200) {
        var data = DoctorDetailsResponse.fromJson(
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

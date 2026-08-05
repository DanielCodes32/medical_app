import 'package:dartz/dartz.dart';
import 'package:medical_app/core/services/apis/apis.dart';
import 'package:medical_app/core/services/apis/dio_provider.dart';
import 'package:medical_app/core/services/apis/failures.dart';
import 'package:medical_app/core/services/local/shared_pref.dart';
import 'package:medical_app/features/doctor_profile/data/models/doctor_profile_model.dart';

class DoctorProfileRepo {
  static Future<Either<Failure, dynamic>> updateDoctorProfile({
    required int doctorId,
    required DoctorProfileModel profileModel,
  }) async {
    final response = await DioProvider().putId(
      endpoint: Apis.updateDoctor,
      id: doctorId.toString(),
      data: profileModel.toJson(),
      headers: {
        'Authorization': 'Bearer ${SharedPref.gettoken()}',
        'Content-Type': 'application/json',
      },
    );

    return response;
  }
}

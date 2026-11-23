import 'package:dartz/dartz.dart';
import 'package:medical_app/core/services/apis/apis.dart';
import 'package:medical_app/core/services/apis/dio_provider.dart';
import 'package:medical_app/core/services/apis/failures.dart';
import 'package:medical_app/core/services/local/shared_pref.dart';
import 'package:medical_app/features/patient_profile/data/models/patient_profile_request.dart';

class PatientProfileRepo {
  static Future<Either<Failure, dynamic>> updatePatientProfile({
    required String patientId,
    required PatientProfileRequest request,
  }) async {
    final response = await DioProvider().putId(
      endpoint: Apis.updatePatient,
      id: patientId,
      data: request.toJson(),
      headers: {
        'Authorization': 'Bearer ${SharedPref.gettoken()}',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }

  static Future<Either<Failure, dynamic>> getPatientProfile(
    String patientId,
  ) async {
    final endpoint = Apis.patientDetails.replaceAll(':id', patientId);
    final response = await DioProvider().getApi(
      endpoint: endpoint,
      headers: {'Authorization': 'Bearer ${SharedPref.gettoken()}'},
    );
    return response;
  }
}

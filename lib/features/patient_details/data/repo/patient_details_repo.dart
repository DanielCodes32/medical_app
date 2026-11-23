import 'package:dartz/dartz.dart';
import 'package:medical_app/core/services/apis/apis.dart';
import 'package:medical_app/core/services/apis/dio_provider.dart';
import 'package:medical_app/core/services/apis/failures.dart';
import 'package:medical_app/core/services/local/shared_pref.dart';
import 'package:medical_app/features/patient_details/data/models/patient_details_model.dart';

class PatientDetailsRepo {
  Future<Either<Failure, PatientDetailsModel>> getPatientDetails(
    String patientId,
  ) async {
    final endpoint = Apis.patientDetails.replaceAll(':id', patientId);
    final token = SharedPref.gettoken();

    final response = await DioProvider().getApi(
      endpoint: endpoint,
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.fold(
      (failure) => Left(failure),
      (data) {
        try {
          if (data is Map<String, dynamic>) {
            return Right(PatientDetailsModel.fromJson(data));
          }
          return Left(
            ParseFailure(message: 'Unexpected patient data format'),
          );
        } catch (e) {
          return Left(ParseFailure(message: e.toString()));
        }
      },
    );
  }
}


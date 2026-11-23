import 'package:dartz/dartz.dart';
import 'package:medical_app/core/services/apis/apis.dart';
import 'package:medical_app/core/services/apis/dio_provider.dart';
import 'package:medical_app/core/services/apis/failures.dart';
import 'package:medical_app/core/services/local/shared_pref.dart';
import 'package:medical_app/features/booking/data/models/doctor_availability_model.dart';

class BookingRepo {
  Future<Either<Failure, List<DoctorAvailabilityModel>>> getDoctorAvailabilities(
    String doctorId,
  ) async {
    final endpoint = Apis.doctorAvailabilities.replaceAll(':id', doctorId);
    final token = SharedPref.gettoken();

    final response = await DioProvider().getApi(
      endpoint: endpoint,
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.fold(
      (failure) => Left(failure),
      (data) {
        try {
          List<dynamic>? rawList;
          if (data is List) {
            rawList = data;
          } else if (data is Map<String, dynamic> && data['data'] is List) {
            rawList = data['data'] as List<dynamic>;
          }

          if (rawList != null) {
            final models = rawList
                .map(
                  (item) => DoctorAvailabilityModel.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList();
            return Right(models);
          }
          return Right(<DoctorAvailabilityModel>[]);
        } catch (e) {
          return Left(ParseFailure(message: e.toString()));
        }
      },
    );
  }

  Future<Either<Failure, dynamic>> confirmAppointment({
    required int patientId,
    required int doctorId,
    required String scheduledAt,
    String notes = "",
    String status = "pending",
  }) async {
    final token = SharedPref.gettoken();
    final body = {
      "patientid": patientId,
      "doctorid": doctorId,
      "scheduledat": scheduledAt,
      "notes": notes,
      "status": status,
    };

    final response = await DioProvider().postApi(
      endpoint: Apis.appointments,
      data: body,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return response.fold(
      (failure) => Left(failure),
      (data) => Right(data),
    );
  }
}

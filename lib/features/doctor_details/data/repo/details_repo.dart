

import 'package:dartz/dartz.dart';
import 'package:medical_app/core/services/apis/apis.dart';
import 'package:medical_app/core/services/apis/dio_provider.dart';
import 'package:medical_app/core/services/apis/failures.dart';
import 'package:medical_app/core/services/local/shared_pref.dart';
import 'package:medical_app/features/doctor_details/data/models/doctor_details_response/data.dart';

class DetailsRepo {
  Future<Either<Failure, DoctorDetailsResponse>> getDoctorDetails(String id) async {
    var response = await DioProvider().getApi(
      endpoint: Apis.doctorDetails.replaceAll(':id', id),
      headers: {'Authorization': 'Bearer ${SharedPref.gettoken()}'},
    );
   return response.fold((l){
      return Left(l);
    }, (r){
      return Right(DoctorDetailsResponse.fromJson(r));
    });
  }
}

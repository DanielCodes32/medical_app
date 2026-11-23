import 'package:medical_app/features/doctor_details/data/models/doctor_details_response/data.dart';

abstract class DoctorHomeState {}

class DoctorHomeInitial extends DoctorHomeState {}

class DoctorHomeLoading extends DoctorHomeState {}

class DoctorHomeSuccess extends DoctorHomeState {
  final DoctorDetailsResponse doctor;
  final String selectedFilter;

  DoctorHomeSuccess({
    required this.doctor,
    required this.selectedFilter,
  });
}

class DoctorHomeError extends DoctorHomeState {
  final String message;

  DoctorHomeError({required this.message});
}

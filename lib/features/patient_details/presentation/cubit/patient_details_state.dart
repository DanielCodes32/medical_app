import 'package:medical_app/features/patient_details/data/models/patient_details_model.dart';

abstract class PatientDetailsState {}

class PatientDetailsInitial extends PatientDetailsState {}

class PatientDetailsLoading extends PatientDetailsState {}

class PatientDetailsSuccess extends PatientDetailsState {
  final PatientDetailsModel patient;

  PatientDetailsSuccess(this.patient);
}

class PatientDetailsError extends PatientDetailsState {
  final String message;

  PatientDetailsError(this.message);
}


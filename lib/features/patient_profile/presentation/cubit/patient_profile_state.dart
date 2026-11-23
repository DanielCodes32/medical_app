abstract class PatientProfileState {}

class PatientProfileInitial extends PatientProfileState {}

class PatientProfileLoading extends PatientProfileState {}

class PatientProfileLoaded extends PatientProfileState {}

class PatientProfileImageUploading extends PatientProfileState {}

class PatientProfileUpdating extends PatientProfileState {}

class PatientProfileSuccess extends PatientProfileState {
  final String message;
  PatientProfileSuccess(this.message);
}

class PatientProfileError extends PatientProfileState {
  final String message;
  PatientProfileError(this.message);
}

abstract class DoctorProfileState {}

class DoctorProfileInitial extends DoctorProfileState {}

class DoctorProfileLoading extends DoctorProfileState {}

class ImageUploadingState extends DoctorProfileState {}

class ImageUploadSuccessState extends DoctorProfileState {
  final String imageUrl;
  ImageUploadSuccessState(this.imageUrl);
}

class ImageUploadErrorState extends DoctorProfileState {
  final String message;
  ImageUploadErrorState(this.message);
}

class DoctorProfileSuccess extends DoctorProfileState {
  final String message;
  DoctorProfileSuccess(this.message);
}

class DoctorProfileError extends DoctorProfileState {
  final String message;
  DoctorProfileError(this.message);
}

class ScheduleUpdatedState extends DoctorProfileState {}

class LocationUpdatedState extends DoctorProfileState {}

class DropdownUpdatedState extends DoctorProfileState {}

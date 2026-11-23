import 'package:medical_app/features/booking/data/models/doctor_availability_model.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final List<DoctorAvailabilityModel> availabilities;
  final String? selectedDay;
  final DoctorAvailabilityModel? selectedSlot;

  BookingSuccess({
    required this.availabilities,
    this.selectedDay,
    this.selectedSlot,
  });
}

class BookingError extends BookingState {
  final String message;

  BookingError({required this.message});
}

class BookingConfirmLoading extends BookingState {}

class BookingConfirmSuccess extends BookingState {
  final String message;
  final String scheduledAt;
  final DoctorAvailabilityModel? confirmedSlot;

  BookingConfirmSuccess({
    required this.message,
    required this.scheduledAt,
    this.confirmedSlot,
  });
}

class BookingConfirmError extends BookingState {
  final String message;

  BookingConfirmError({required this.message});
}

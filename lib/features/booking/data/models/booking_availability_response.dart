import 'doctor_availability_model.dart';

class BookingAvailabilityResponse {
  final List<DoctorAvailabilityModel>? data;
  final String? message;
  final List<dynamic>? error;
  final int? status;

  BookingAvailabilityResponse({
    this.data,
    this.message,
    this.error,
    this.status,
  });

  factory BookingAvailabilityResponse.fromJson(Map<String, dynamic> json) {
    return BookingAvailabilityResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map(
            (e) => DoctorAvailabilityModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      message: json['message'] as String?,
      error: json['error'] as List<dynamic>?,
      status: json['status'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data?.map((e) => e.toJson()).toList(),
    'message': message,
    'error': error,
    'status': status,
  };
}

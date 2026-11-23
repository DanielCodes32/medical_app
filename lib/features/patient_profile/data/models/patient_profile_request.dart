class AgeModel {
  final int? day;
  final int? month;
  final int? year;

  AgeModel({this.day, this.month, this.year});

  factory AgeModel.fromJson(Map<String, dynamic> json) => AgeModel(
        day: json['day'] as int?,
        month: json['month'] as int?,
        year: json['year'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'day': day,
        'month': month,
        'year': year,
      };
}

class PatientProfileRequest {
  final AgeModel age;
  final String gender;
  final String image;
  final String mobileNumber;
  final String patientid;

  PatientProfileRequest({
    required this.age,
    required this.gender,
    required this.image,
    required this.mobileNumber,
    required this.patientid,
  });

  factory PatientProfileRequest.fromJson(Map<String, dynamic> json) =>
      PatientProfileRequest(
        age: json['age'] != null
            ? AgeModel.fromJson(json['age'] as Map<String, dynamic>)
            : AgeModel(),
        gender: (json['gender'] as String?) ?? 'Male',
        image: (json['image'] as String?) ?? '',
        mobileNumber: (json['mobileNumber'] as String?) ?? '',
        patientid: (json['patientid'] as String?) ?? '',
      );

  Map<String, dynamic> toJson() => {
        'age': age.toJson(),
        'gender': gender,
        'image': image,
        'mobileNumber': mobileNumber,
        'patientid': patientid,
      };
}

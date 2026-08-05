class DoctorProfileModel {
  final int userid;
  final String specialization;
  final String department;
  final String licensenumber;
  final String phone;
  final String bio;
  final int experienceyears;
  final String education;
  final num price;
  final String imageurl;
  final ClinicAddressModel clinicaddress;
  final InitialMetricsModel initialmetrics;
  final AppointmentSettingsModel appointmentsettings;
  final List<AvailableScheduleModel> availableschedules;

  DoctorProfileModel({
    required this.userid,
    required this.specialization,
    required this.department,
    required this.licensenumber,
    required this.phone,
    required this.bio,
    required this.experienceyears,
    required this.education,
    required this.price,
    required this.imageurl,
    required this.clinicaddress,
    required this.initialmetrics,
    required this.appointmentsettings,
    required this.availableschedules,
  });

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) {
    return DoctorProfileModel(
      userid: json['userid'] ?? 0,
      specialization: json['specialization'] ?? '',
      department: json['department'] ?? '',
      licensenumber: json['licensenumber'] ?? '',
      phone: json['phone'] ?? '',
      bio: json['bio'] ?? '',
      experienceyears: json['experienceyears'] ?? 0,
      education: json['education'] ?? '',
      price: json['price'] ?? 0,
      imageurl: json['imageurl'] ?? '',
      clinicaddress: ClinicAddressModel.fromJson(json['clinicaddress'] ?? {}),
      initialmetrics: InitialMetricsModel.fromJson(json['initialmetrics'] ?? {}),
      appointmentsettings: AppointmentSettingsModel.fromJson(json['appointmentsettings'] ?? {}),
      availableschedules: (json['availableschedules'] as List<dynamic>?)
              ?.map((e) => AvailableScheduleModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
      'specialization': specialization,
      'department': department,
      'licensenumber': licensenumber,
      'phone': phone,
      'bio': bio,
      'experienceyears': experienceyears,
      'education': education,
      'price': price,
      'imageurl': imageurl,
      'clinicaddress': clinicaddress.toJson(),
      'initialmetrics': initialmetrics.toJson(),
      'appointmentsettings': appointmentsettings.toJson(),
      'availableschedules': availableschedules.map((e) => e.toJson()).toList(),
    };
  }
}

class ClinicAddressModel {
  final String street;
  final String city;
  final String governorate;
  final double latitude;
  final double longitude;

  ClinicAddressModel({
    required this.street,
    required this.city,
    required this.governorate,
    required this.latitude,
    required this.longitude,
  });

  factory ClinicAddressModel.fromJson(Map<String, dynamic> json) {
    return ClinicAddressModel(
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      governorate: json['governorate'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'governorate': governorate,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class InitialMetricsModel {
  final double averagerating;
  final int ratingcount;
  final int totalappointments;
  final int totalpatients;

  InitialMetricsModel({
    this.averagerating = 0.0,
    this.ratingcount = 0,
    this.totalappointments = 0,
    this.totalpatients = 0,
  });

  factory InitialMetricsModel.fromJson(Map<String, dynamic> json) {
    return InitialMetricsModel(
      averagerating: (json['averagerating'] as num?)?.toDouble() ?? 0.0,
      ratingcount: json['ratingcount'] ?? 0,
      totalappointments: json['totalappointments'] ?? 0,
      totalpatients: json['totalpatients'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'averagerating': averagerating,
      'ratingcount': ratingcount,
      'totalappointments': totalappointments,
      'totalpatients': totalpatients,
    };
  }
}

class AppointmentSettingsModel {
  final int slotdurationminutes;
  final int buffertimeminutes;
  final int maxpatientsperday;
  final int advancebookingdays;

  AppointmentSettingsModel({
    required this.slotdurationminutes,
    required this.buffertimeminutes,
    required this.maxpatientsperday,
    required this.advancebookingdays,
  });

  factory AppointmentSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppointmentSettingsModel(
      slotdurationminutes: json['slotdurationminutes'] ?? 30,
      buffertimeminutes: json['buffertimeminutes'] ?? 10,
      maxpatientsperday: json['maxpatientsperday'] ?? 15,
      advancebookingdays: json['advancebookingdays'] ?? 30,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slotdurationminutes': slotdurationminutes,
      'buffertimeminutes': buffertimeminutes,
      'maxpatientsperday': maxpatientsperday,
      'advancebookingdays': advancebookingdays,
    };
  }
}

class AvailableScheduleModel {
  final String dayofweek;
  final int dayindex;
  final bool isworkingday;
  final TimeSlotModel? workinghours;
  final TimeSlotModel? breakhours;

  AvailableScheduleModel({
    required this.dayofweek,
    required this.dayindex,
    required this.isworkingday,
    this.workinghours,
    this.breakhours,
  });

  factory AvailableScheduleModel.fromJson(Map<String, dynamic> json) {
    return AvailableScheduleModel(
      dayofweek: json['dayofweek'] ?? '',
      dayindex: json['dayindex'] ?? 0,
      isworkingday: json['isworkingday'] ?? false,
      workinghours: json['workinghours'] != null
          ? TimeSlotModel.fromJson(json['workinghours'])
          : null,
      breakhours: json['breakhours'] != null
          ? TimeSlotModel.fromJson(json['breakhours'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayofweek': dayofweek,
      'dayindex': dayindex,
      'isworkingday': isworkingday,
      'workinghours': workinghours?.toJson(),
      'breakhours': breakhours?.toJson(),
    };
  }
}

class TimeSlotModel {
  final String starttime;
  final String endtime;

  TimeSlotModel({
    required this.starttime,
    required this.endtime,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      starttime: json['starttime'] ?? '',
      endtime: json['endtime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'starttime': starttime,
      'endtime': endtime,
    };
  }
}

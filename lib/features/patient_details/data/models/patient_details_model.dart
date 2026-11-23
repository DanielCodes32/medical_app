class PatientDetailsModel {
  final int? id;
  final int? userid;
  final String? firstname;
  final String? lastname;
  final String? username;
  final String? email;
  final String? phone;
  final String? gender;
  final String? dateofbirth;
  final int? age;
  final String? bloodgroup;
  final String? address;
  final String? city;
  final String? governorate;
  final String? imageurl;
  final String? emergencycontact;
  final String? medicalhistory;
  final String? allergies;
  final String? chronicdiseases;
  final String? notes;
  final String? createdat;

  PatientDetailsModel({
    this.id,
    this.userid,
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.phone,
    this.gender,
    this.dateofbirth,
    this.age,
    this.bloodgroup,
    this.address,
    this.city,
    this.governorate,
    this.imageurl,
    this.emergencycontact,
    this.medicalhistory,
    this.allergies,
    this.chronicdiseases,
    this.notes,
    this.createdat,
  });

  factory PatientDetailsModel.fromJson(Map<String, dynamic> json) {
    // If the json object is wrapped in { "data": { ... } } or { "patient": { ... } }
    Map<String, dynamic> map = json;
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      map = json['data'] as Map<String, dynamic>;
    } else if (json['patient'] != null && json['patient'] is Map<String, dynamic>) {
      map = json['patient'] as Map<String, dynamic>;
    }

    // Helper for strings/lists to string
    String? parseListOrString(dynamic val) {
      if (val == null) return null;
      if (val is List) {
        return val.map((e) => e.toString()).join(', ');
      }
      return val.toString();
    }

    // Parse age
    int? parsedAge;
    final rawAge = map['age'];
    if (rawAge is int) {
      parsedAge = rawAge;
    } else if (rawAge is String) {
      parsedAge = int.tryParse(rawAge);
    } else if (map['dateofbirth'] != null || map['dob'] != null) {
      final dobStr = (map['dateofbirth'] ?? map['dob'])?.toString();
      final dob = dobStr != null ? DateTime.tryParse(dobStr) : null;
      if (dob != null) {
        final now = DateTime.now();
        parsedAge = now.year - dob.year;
        if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
          parsedAge--;
        }
      }
    }

    return PatientDetailsModel(
      id: map['id'] as int? ?? map['patientid'] as int?,
      userid: map['userid'] as int? ?? map['user_id'] as int?,
      firstname: (map['firstname'] ?? map['first_name']) as String?,
      lastname: (map['lastname'] ?? map['last_name']) as String?,
      username: map['username'] as String?,
      email: map['email'] as String?,
      phone: (map['phone'] ?? map['phonenumber'] ?? map['phone_number']) as String?,
      gender: map['gender'] as String?,
      dateofbirth: (map['dateofbirth'] ?? map['dob'] ?? map['birthdate']) as String?,
      age: parsedAge,
      bloodgroup: (map['bloodgroup'] ?? map['blood_group'] ?? map['bloodtype'] ?? map['blood_type']) as String?,
      address: (map['address'] ?? map['street']) as String?,
      city: map['city'] as String?,
      governorate: map['governorate'] as String?,
      imageurl: (map['imageurl'] ?? map['image'] ?? map['profile_image'] ?? map['avatar']) as String?,
      emergencycontact: (map['emergencycontact'] ?? map['emergency_contact'] ?? map['emergency_phone']) as String?,
      medicalhistory: parseListOrString(map['medicalhistory'] ?? map['medical_history'] ?? map['history']),
      allergies: parseListOrString(map['allergies']),
      chronicdiseases: parseListOrString(map['chronicdiseases'] ?? map['chronic_diseases'] ?? map['chronic_conditions']),
      notes: map['notes'] as String?,
      createdat: (map['createdat'] ?? map['created_at']) as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userid': userid,
        'firstname': firstname,
        'lastname': lastname,
        'username': username,
        'email': email,
        'phone': phone,
        'gender': gender,
        'dateofbirth': dateofbirth,
        'age': age,
        'bloodgroup': bloodgroup,
        'address': address,
        'city': city,
        'governorate': governorate,
        'imageurl': imageurl,
        'emergencycontact': emergencycontact,
        'medicalhistory': medicalhistory,
        'allergies': allergies,
        'chronicdiseases': chronicdiseases,
        'notes': notes,
        'createdat': createdat,
      };

  String get fullName {
    final parts = [firstname, lastname].where((s) => s != null && s.trim().isNotEmpty);
    if (parts.isNotEmpty) {
      return parts.join(' ');
    }
    if (username != null && username!.trim().isNotEmpty) {
      return username!;
    }
    return 'Patient';
  }

  String get fullLocation {
    final parts = [address, city, governorate].where((s) => s != null && s.trim().isNotEmpty);
    if (parts.isNotEmpty) {
      return parts.join(', ');
    }
    return 'Not specified';
  }
}


class Datum {
  int? id;
  int? userid;
  String? firstname;
  String? lastname;
  String? specialization;
  double? price;
  String? licensenumber;
  String? phone;
  String? department;
  String? imageurl;
  int? doctorid;
  int? totalappointments;
  int? completedappointments;
  int? uniquepatients;
  double? averagerating;
  int? ratingcount;
  double? score;

  Datum({
    this.id,
    this.userid,
    this.firstname,
    this.lastname,
    this.specialization,
    this.price,
    this.licensenumber,
    this.phone,
    this.department,
    this.imageurl,
    this.doctorid,
    this.totalappointments,
    this.completedappointments,
    this.uniquepatients,
    this.averagerating,
    this.ratingcount,
    this.score,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    final parsedDoctorId = json['doctorid'] as int?;
    final parsedId = json['id'] as int? ?? parsedDoctorId;
    return Datum(
      id: parsedId,
      userid: json['userid'] as int?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      specialization: json['specialization'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      licensenumber: json['licensenumber'] as String?,
      phone: json['phone'] as String?,
      department: json['department'] as String?,
      imageurl: json['imageurl'] as String?,
      doctorid: parsedDoctorId ?? parsedId,
      totalappointments: json['totalappointments'] as int?,
      completedappointments: json['completedappointments'] as int?,
      uniquepatients: json['uniquepatients'] as int?,
      averagerating: (json['averagerating'] as num?)?.toDouble(),
      ratingcount: json['ratingcount'] as int?,
      score: (json['score'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userid': userid,
    'firstname': firstname,
    'lastname': lastname,
    'specialization': specialization,
    'price': price,
    'licensenumber': licensenumber,
    'phone': phone,
    'department': department,
    'imageurl': imageurl,
    'doctorid': doctorid,
    'totalappointments': totalappointments,
    'completedappointments': completedappointments,
    'uniquepatients': uniquepatients,
    'averagerating': averagerating,
    'ratingcount': ratingcount,
    'score': score,
  };
}

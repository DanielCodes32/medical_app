import 'rating.dart';

class Data {
  int? id;
  int? userid;
  String? firstname;
  String? lastname;
  String? specialization;
  int? price;
  String? licensenumber;
  String? phone;
  String? department;
  String? imageurl;
  double? averagerating;
  int? ratingcount;
  int? appointments;
  int? patients;
  List<Rating>? ratings;

  Data({
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
    this.averagerating,
    this.ratingcount,
    this.appointments,
    this.patients,
    this.ratings,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json['id'] as int?,
    userid: json['userid'] as int?,
    firstname: json['firstname'] as String?,
    lastname: json['lastname'] as String?,
    specialization: json['specialization'] as String?,
    price: json['price'] as int?,
    licensenumber: json['licensenumber'] as String?,
    phone: json['phone'] as String?,
    department: json['department'] as String?,
    imageurl: json['imageurl'] as String?,
    averagerating: (json['averagerating'] as num?)?.toDouble(),
    ratingcount: json['ratingcount'] as int?,
    appointments: json['appointments'] as int?,
    patients: json['patients'] as int?,
    ratings: (json['ratings'] as List<dynamic>?)
        ?.map((e) => Rating.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

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
    'averagerating': averagerating,
    'ratingcount': ratingcount,
    'appointments': appointments,
    'patients': patients,
    'ratings': ratings?.map((e) => e.toJson()).toList(),
  };
}

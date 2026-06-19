class Datum {
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
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
  };
}

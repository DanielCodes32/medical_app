class Rating {
  int? id;
  int? doctorid;
  int? patientid;
  String? firstname;
  String? lastname;
  double? rate;
  String? comment;
  String? createdat;

  Rating({
    this.id,
    this.doctorid,
    this.patientid,
    this.firstname,
    this.lastname,
    this.rate,
    this.comment,
    this.createdat,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    id: json['id'] as int?,
    doctorid: json['doctorid'] as int?,
    patientid: json['patientid'] as int?,
    firstname: json['firstname'] as String?,
    lastname: json['lastname'] as String?,
    rate: (json['rate'] as num?)?.toDouble(),
    comment: json['comment'] as String?,
    createdat: json['createdat'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'doctorid': doctorid,
    'patientid': patientid,
    'firstname': firstname,
    'lastname': lastname,
    'rate': rate,
    'comment': comment,
    'createdat': createdat,
  };
}

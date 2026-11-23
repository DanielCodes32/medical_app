class User {
  int? id;
  int? specializedId;
  String? username;
  String? email;
  String? role;

  User({this.id, this.specializedId, this.username, this.email, this.role});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int?,
    specializedId:
        (json['patientid'] ?? json['doctorid']) as int?,
    username: json['username'] as String?,
    email: json['email'] as String?,
    role: json['role'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'specializedId': specializedId,
    'username': username,
    'email': email,
    'role': role,
  };
}

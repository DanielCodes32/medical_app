class AuthResponse {
  String? email;
  int? id;
  String? role;
  String? username;

  AuthResponse({this.email, this.id, this.role, this.username});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    email: json['email'] as String?,
    id: json['id'] as int?,
    role: json['role'] as String?,
    username: json['username'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'id': id,
    'role': role,
    'username': username,
  };
}

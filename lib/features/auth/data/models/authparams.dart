class Authparams {
  String? username;
  String? email;
  String? password;
  String? role;

  Authparams({
    this.username,
    this.email,
    this.password,
    this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (role != null) 'role': role!.toLowerCase(),
    };
  }
}

class Authparams {
  String? firstname;
  String? lastname;
  String? username;
  String? email;
  String? password;
  String? role;

  Authparams({
    this.username,
    this.email,
    this.password,
    this.role,
    this.firstname,
    this.lastname,
  });

  Map<String, dynamic> toJson() {
    return {
      if (firstname != null) 'firstname': firstname,
      if (lastname != null) 'lastname': lastname,
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (role != null) 'role': role!.toLowerCase(),
    };
  }
}

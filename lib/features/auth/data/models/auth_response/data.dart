import 'user.dart';

class Data {
  String? token;
  User? user;

  Data({this.token, this.user});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json['token'] as String?,
    user: json['user'] != null
        ? User.fromJson(json['user'] as Map<String, dynamic>)
        : (json['id'] != null ? User.fromJson(json) : null),
  );

  Map<String, dynamic> toJson() => {'token': token, 'user': user?.toJson()};
}

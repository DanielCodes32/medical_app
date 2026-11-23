import 'user.dart';

class Data {
  String? token;
  User? user;

  Data({this.token, this.user});

  factory Data.fromJson(Map<String, dynamic> json) {
    User? parsedUser;

    if (json['user'] != null) {
      final userMap = json['user'] as Map<String, dynamic>;

      final merged = {
        ...userMap,
        if (json['patientid'] != null) 'patientid': json['patientid'],
        if (json['doctorid'] != null) 'doctorid': json['doctorid'],
      };
      parsedUser = User.fromJson(merged);
    } else if (json['id'] != null) {
      parsedUser = User.fromJson(json);
    }

    return Data(
      token: json['token'] as String?,
      user: parsedUser,
    );
  }

  Map<String, dynamic> toJson() => {'token': token, 'user': user?.toJson()};
}

bool isEmailValid(String email) {
  return RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  ).hasMatch(email);
}

bool isPasswordValid(String password) {
  return RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
  ).hasMatch(password);
}

bool isEgyptianPhoneValid(String phone) {
  final cleaned = phone.trim().replaceAll(RegExp(r'[\s\-]'), '');
 
  return RegExp(r'^(?:(?:\+20|20)?0?1[0125][0-9]{8})$').hasMatch(cleaned);
}

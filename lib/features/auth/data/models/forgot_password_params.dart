class ForgotPasswordParams {
  final String email;
  final String purpose;

  ForgotPasswordParams({required this.email, this.purpose = "reset_password"});

  Map<String, dynamic> toJson() => {'email': email, 'purpose': purpose};
}

class VerifyOtpParams {
  
   final String email;
  final String otpCode;
  final String purpose;

  VerifyOtpParams({
   required this.email,
    required this.otpCode,
    this.purpose = "reset_password",
  });

  Map<String, dynamic> toJson() => {
    'Email': email,
    'otpcode': otpCode,
    'purpose': purpose,
  };
}

class ResetPasswordParams {
   final String resettoken;
  final String newPassword;

  ResetPasswordParams({required this.resettoken, required this.newPassword});

  Map<String, dynamic> toJson() => {
    'resettoken': resettoken,
    'newpassword': newPassword,
  };
}

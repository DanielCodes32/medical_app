class ForgotPasswordParams {
  final String email;
  final String purpose;

  ForgotPasswordParams({
    required this.email,
    this.purpose = "reset_password",
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'purpose': purpose,
  };
}

class VerifyOtpParams {
  final int userId;
  final String otpCode;
  final String purpose;

  VerifyOtpParams({
    required this.userId,
    required this.otpCode,
    this.purpose = "reset_password",
  });

  Map<String, dynamic> toJson() => {
    'userid': userId,
    'otpcode': otpCode,
    'purpose': purpose,
  };
}

class ResetPasswordParams {
  final int userId;
  final String newPassword;

  ResetPasswordParams({
    required this.userId,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    'userid': userId,
    'newpassword': newPassword,
  };
}

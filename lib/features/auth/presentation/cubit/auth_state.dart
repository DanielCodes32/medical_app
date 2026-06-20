class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {}

class AuthErrorState extends AuthState {}

class ForgotPasswordLoadingState extends AuthState {}

class ForgotPasswordSuccessState extends AuthState {
  final String message;
  ForgotPasswordSuccessState(this.message);
}

class ForgotPasswordErrorState extends AuthState {
  final String message;
  ForgotPasswordErrorState(this.message);
}

class VerifyOtpLoadingState extends AuthState {}

class VerifyOtpSuccessState extends AuthState {
  final String message;
  VerifyOtpSuccessState(this.message);
}

class VerifyOtpErrorState extends AuthState {
  final String message;
  VerifyOtpErrorState(this.message);
}

class ResetPasswordLoadingState extends AuthState {}

class ResetPasswordSuccessState extends AuthState {
  final String message;
  ResetPasswordSuccessState(this.message);
}

class ResetPasswordErrorState extends AuthState {
  final String message;
  ResetPasswordErrorState(this.message);
}

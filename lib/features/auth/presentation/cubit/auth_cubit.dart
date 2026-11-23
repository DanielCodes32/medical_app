import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_app/features/auth/data/models/authparams.dart';
import 'package:medical_app/features/auth/data/models/forgot_password_params.dart';
import 'package:medical_app/features/auth/data/repo/repo.dart';
import 'package:medical_app/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());
  final formKey = GlobalKey<FormState>();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();
  final roleController = TextEditingController(text: 'Patient');
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String resettoken = "";

  Future<void> login() async {
    emit(AuthLoadingState());
    try {
      var params = Authparams(
        email: emailController.text,
        password: passwordController.text,
      );
      var data = await AuthRepo.login(params);
      if (data != null && (data.error == null || data.error!.isEmpty)) {
        emit(AuthSuccessState(role: data.data?.user?.role));
      } else {
        String errorMessage = "Something went wrong";
        if (data?.error != null && data!.error!.isNotEmpty) {
          errorMessage = data.error!.first.toString();
        } else if (data?.message != null && data!.message!.isNotEmpty) {
          errorMessage = data.message!;
        }
        emit(AuthErrorState(message: errorMessage));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> register() async {
    emit(AuthLoadingState());
    try {
      var params = Authparams(
        firstname: firstnameController.text,
        lastname: lastnameController.text,
        username: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
        role: roleController.text,
      );
      var data = await AuthRepo.register(params);
      if (data != null && (data.error == null || data.error!.isEmpty)) {
        emit(AuthSuccessState(role: data.data?.user?.role));
      } else {
        String errorMessage = "Something went wrong";
        if (data?.error != null && data!.error!.isNotEmpty) {
          errorMessage = data.error!.first.toString();
        } else if (data?.message != null && data!.message!.isNotEmpty) {
          errorMessage = data.message!;
        }
        emit(AuthErrorState(message: errorMessage));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> forgotPassword() async {
    emit(ForgotPasswordLoadingState());
    resettoken = "";
    var params = ForgotPasswordParams(email: emailController.text);
    var result = await AuthRepo.forgotPassword(params);
    if (result.success) {
      emit(
        ForgotPasswordSuccessState(
          result.message ?? "OTP has been sent to your email!",
        ),
      );
    } else {
      emit(ForgotPasswordErrorState(result.message ?? "Something went wrong"));
    }
  }

  Future<void> verifyOtp() async {
    emit(VerifyOtpLoadingState());
    
    var params = VerifyOtpParams(
      otpCode: otpController.text,
      email: emailController.text,
    );
    var result = await AuthRepo.verifyOtp(params);
    if (result.success) {
      final data = result.data?['data'];
      if (data is String) {
        resettoken = data;
      } else if (data is Map<String, dynamic>) {
        resettoken = (data['resettoken'] ??
                data['resetToken'] ??
                data['token'] ??
                '')
            .toString();
      }
      if (resettoken.isEmpty && result.data != null) {
        resettoken = (result.data!['resettoken'] ??
                result.data!['resetToken'] ??
                result.data!['token'] ??
                '')
            .toString();
      }
      emit(
        VerifyOtpSuccessState(result.message ?? "OTP verified successfully!"),
      );
    } else {
      emit(VerifyOtpErrorState(result.message ?? "Invalid OTP"));
    }
  }

  Future<void> resetPassword() async {
    emit(ResetPasswordLoadingState());
    
    var params = ResetPasswordParams(
      newPassword: newPasswordController.text,
      resettoken: resettoken,
    );
    var result = await AuthRepo.resetPassword(params);
    if (result.success) {
      emit(
        ResetPasswordSuccessState(
          result.message ?? "Password updated successfully!",
        ),
      );
    } else {
      emit(ResetPasswordErrorState(result.message ?? "Something went wrong"));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_app/core/services/local/shared_pref.dart';
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

  Future<void> login() async {
    emit(AuthLoadingState());
    try {
      var params = Authparams(
        email: emailController.text,
        password: passwordController.text,
      );
      var data = await AuthRepo.login(params);
      if (data != null && (data.error == null || data.error!.isEmpty)) {
        emit(AuthSuccessState());
      } else {
        String errorMessage = "Something went wrong";
        if (data?.error != null && data!.error!.isNotEmpty) {
          errorMessage = data.error!.first.toString();
        } else if (data?.message != null && data!.message!.isNotEmpty) {
          errorMessage = data.message!;
        }
        emit(AuthErrorState(
          message: errorMessage,
        ));
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
        emit(AuthSuccessState());
      } else {
        String errorMessage = "Something went wrong";
        if (data?.error != null && data!.error!.isNotEmpty) {
          errorMessage = data.error!.first.toString();
        } else if (data?.message != null && data!.message!.isNotEmpty) {
          errorMessage = data.message!;
        }
        emit(AuthErrorState(
          message: errorMessage,
        ));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> forgotPassword() async {
    emit(ForgotPasswordLoadingState());
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
    final userId = SharedPref.getUserId();
    var params = VerifyOtpParams(userId: userId, otpCode: otpController.text);
    var result = await AuthRepo.verifyOtp(params);
    if (result.success) {
      emit(
        VerifyOtpSuccessState(result.message ?? "OTP verified successfully!"),
      );
    } else {
      emit(VerifyOtpErrorState(result.message ?? "Invalid OTP"));
    }
  }

  Future<void> resetPassword() async {
    emit(ResetPasswordLoadingState());
    final userId = SharedPref.getUserId();
    var params = ResetPasswordParams(
      userId: userId,
      newPassword: newPasswordController.text,
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

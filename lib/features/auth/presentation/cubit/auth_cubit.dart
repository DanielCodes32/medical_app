import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_app/features/auth/data/models/authparams.dart';
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

  Future<void> login() async {
    emit(AuthLoadingState());
    var params = Authparams(
      email: emailController.text,
      password: passwordController.text,
    );
    var data = await AuthRepo.login(params);
    if (data != null) {
      emit(AuthSuccessState());
    } else {
      emit(AuthErrorState());
    }
  }

  Future<void> register() async {
    emit(AuthLoadingState());
    var params = Authparams(
      firstname: firstnameController.text,
      lastname: lastnameController.text,
      username: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
      role: roleController.text,
    );
    var data = await AuthRepo.register(params);
    if (data != null) {
      emit(AuthSuccessState());
    } else {
      emit(AuthErrorState());
    }
  }
}

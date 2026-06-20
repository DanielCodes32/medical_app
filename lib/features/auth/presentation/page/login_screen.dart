import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:medical_app/core/functions/custom_snake_bar.dart';
import 'package:medical_app/core/functions/navigations.dart';
import 'package:medical_app/core/functions/validation.dart';
import 'package:medical_app/core/routes/routes.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';
import 'package:medical_app/core/widgets/custom_form_field.dart';
import 'package:medical_app/core/widgets/custom_password_field.dart';
import 'package:medical_app/core/widgets/main_button.dart';
import 'package:medical_app/core/widgets/mybodyview.dart';
import 'package:medical_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:medical_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:medical_app/features/auth/presentation/widgets/forgot_password_sheets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccessState) {
            mydiag(context, "Login successful!", AppColors.primaryColor);
            pushReplacement(context, Routes.home);
          } else if (state is AuthErrorState) {
            mydiag(
              context,
              "Login failed. Please try again.",
              AppColors.redcolor,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<AuthCubit>();

          return SafeArea(
            child: Scaffold(
              body: MyBodyView(
                child: Center(
                  child: Form(
                    key: cubit.formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            "Welcome back",
                            style: TextStyles.title.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Gap(15),
                          Text(
                            "Welcome back. Securely access your account and take control of your health with ease.",
                            style: TextStyles.body1,
                          ),
                          const Gap(40),

                          const Gap(18),
                          CustomFormField(
                            controller: cubit.emailController,
                            hintText: "Email",
                            keyboardtype: 1,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              }
                              if (!isEmailValid(value)) {
                                return "Please enter a valid email";
                              }
                              return null;
                            },
                          ),
                          const Gap(18),
                          CustomPassField(
                            controller: cubit.passwordController,
                            hintText: "Password",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your password";
                              }
                              if (!isPasswordValid(value)) {
                                return "Please enter a valid password";
                              }
                              return null;
                            },
                          ),
                          const Gap(24),

                          // Selectable Buttons for Patient / Doctor role
                          const Gap(16),

                          const Gap(24),
                          state is AuthLoadingState
                              ? const CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                )
                              : MainButton(
                                  title: "Log In",
                                  onTap: () {
                                    if (cubit.formKey.currentState!
                                        .validate()) {
                                      cubit.login();
                                    }
                                  },
                                ),
                          const Gap(20),
                          TextButton(
                            onPressed: () {
                              showForgotPasswordBottomSheet(context);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets
                                  .zero, // removes all internal padding
                              minimumSize: Size(
                                0,
                                0,
                              ), // prevents default min size
                              tapTargetSize: MaterialTapTargetSize
                                  .shrinkWrap, // tightens hit area
                            ),
                            child: Text(
                              "Forgot password",
                              style: TextStyles.body1.copyWith(
                                color: AppColors.primaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Gap(120),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don’t have an account?",
                    style: TextStyles.body1.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const Gap(5),
                  TextButton(
                    onPressed: () {
                      pushReplacement(context, "/register");
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // removes all internal padding
                      minimumSize: Size(0, 0), // prevents default min size
                      tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap, // tightens hit area
                    ),
                    child: Text(
                      "Join us",
                      style: TextStyles.body1.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccessState) {
            mydiag(context, "Registration successful!", AppColors.primaryColor);
            pushReplacement(context, Routes.login);
          } else if (state is AuthErrorState) {
            mydiag(
              context,
              "Registration failed. Please try again.",
              AppColors.redcolor,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<AuthCubit>();

          return Scaffold(
            body: MyBodyView(
              child: Center(
                child: Form(
                  key: cubit.formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Join us to start searching",
                          style: TextStyles.title.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Gap(15),
                        Text(
                          "Sign up today to discover top healthcare professionals and schedule appointments in just a few taps.",
                          style: TextStyles.body1,
                        ),
                        const Gap(40),
                        CustomFormField(
                          controller: cubit.firstnameController,
                          hintText: "First Name",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your first name";
                            }
                            return null;
                          },
                        ),
                        const Gap(18),
                        CustomFormField(
                          controller: cubit.lastnameController,
                          hintText: "Last Name",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your Last Name";
                            }
                            return null;
                          },
                        ),
                        const Gap(18),
                        CustomFormField(
                          controller: cubit.usernameController,
                          hintText: "Username",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your name";
                            }
                            return null;
                          },
                        ),
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
                              return "Min 8 characters must contain (A-Z, a-z, 0-9, special)";
                            }
                            return null;
                          },
                        ),
                        const Gap(24),
                        // Selectable Buttons for Patient / Doctor role
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    cubit.roleController.text = 'Patient';
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        cubit.roleController.text == 'Patient'
                                        ? AppColors.primaryColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color:
                                          cubit.roleController.text == 'Patient'
                                          ? AppColors.primaryColor
                                          : AppColors.lightgrey1,
                                      width: 1.5,
                                    ),
                                    boxShadow:
                                        cubit.roleController.text == 'Patient'
                                        ? [
                                            BoxShadow(
                                              color: AppColors.primaryColor
                                                  .withOpacity(0.25),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Patient",
                                      style: TextStyles.body1.copyWith(
                                        color:
                                            cubit.roleController.text ==
                                                'Patient'
                                            ? Colors.white
                                            : AppColors.blackColor,
                                        fontWeight:
                                            cubit.roleController.text ==
                                                'Patient'
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Gap(16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    cubit.roleController.text = 'Doctor';
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: cubit.roleController.text == 'Doctor'
                                        ? AppColors.primaryColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color:
                                          cubit.roleController.text == 'Doctor'
                                          ? AppColors.primaryColor
                                          : AppColors.lightgrey1,
                                      width: 1.5,
                                    ),
                                    boxShadow:
                                        cubit.roleController.text == 'Doctor'
                                        ? [
                                            BoxShadow(
                                              color: AppColors.primaryColor
                                                  .withOpacity(0.25),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Doctor",
                                      style: TextStyles.body1.copyWith(
                                        color:
                                            cubit.roleController.text ==
                                                'Doctor'
                                            ? Colors.white
                                            : AppColors.blackColor,
                                        fontWeight:
                                            cubit.roleController.text ==
                                                'Doctor'
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(24),
                        state is AuthLoadingState
                            ? const CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              )
                            : MainButton(
                                title: "Sign Up",
                                onTap: () {
                                  if (cubit.formKey.currentState!.validate()) {
                                    cubit.register();
                                  }
                                },
                              ),
                        const Gap(25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyles.body1.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const Gap(5),
                            TextButton(
                              onPressed: () {
                                pushReplacement(context, Routes.login);
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
                                "Log In",
                                style: TextStyles.body1.copyWith(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:medical_app/core/functions/custom_snake_bar.dart';
import 'package:medical_app/core/functions/validation.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';
import 'package:medical_app/core/widgets/custom_form_field.dart';
import 'package:medical_app/core/widgets/custom_password_field.dart';
import 'package:medical_app/core/widgets/main_button.dart';
import 'package:medical_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:medical_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:medical_app/features/auth/presentation/widgets/otp_input_widget.dart';
import 'package:pinput/pinput.dart';

void showForgotPasswordBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (modalContext) {
      return BlocProvider.value(
        value: BlocProvider.of<AuthCubit>(context),
        child: const ForgotPasswordBottomSheet(),
      );
    },
  );
}

class ForgotPasswordBottomSheet extends StatefulWidget {
  const ForgotPasswordBottomSheet({super.key});

  @override
  State<ForgotPasswordBottomSheet> createState() =>
      _ForgotPasswordBottomSheetState();
}

class _ForgotPasswordBottomSheetState extends State<ForgotPasswordBottomSheet> {
  int _currentStep = 0; // 0: Email, 1: OTP, 2: Reset Password
  final _emailFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccessState) {
          mydiag(context, state.message, AppColors.primaryColor);
          setState(() {
            _currentStep = 1;
          });
        } else if (state is ForgotPasswordErrorState) {
          mydiag(context, state.message, AppColors.redcolor);
        } else if (state is VerifyOtpSuccessState) {
          mydiag(context, state.message, AppColors.primaryColor);
          setState(() {
            _currentStep = 2;
          });
        } else if (state is VerifyOtpErrorState) {
          mydiag(context, state.message, AppColors.redcolor);
        } else if (state is ResetPasswordSuccessState) {
          mydiag(context, state.message, AppColors.primaryColor);
          Navigator.pop(context); // Close the bottom sheet
        } else if (state is ResetPasswordErrorState) {
          mydiag(context, state.message, AppColors.redcolor);
        }
      },
      builder: (context, state) {
        final cubit = context.read<AuthCubit>();
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top drag handle
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.lightgrey,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              const Gap(24),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildStepContent(cubit, state),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepContent(AuthCubit cubit, AuthState state) {
    switch (_currentStep) {
      case 0:
        return Form(
          key: _emailFormKey,
          child: Column(
            key: const ValueKey('email_step'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Forgot password",
                style: TextStyles.title.copyWith(fontWeight: FontWeight.w600),
              ),
              const Gap(12),
              Text(
                "Enter your email for the verification process, we will send 6 digits code to your email.",
                style: TextStyles.body1,
              ),
              const Gap(24),
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
              const Gap(32),
              state is ForgotPasswordLoadingState
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
                  : MainButton(
                      title: "Continue",
                      onTap: () {
                        if (_emailFormKey.currentState!.validate()) {
                          cubit.forgotPassword();
                        }
                      },
                    ),
            ],
          ),
        );
      case 1:
        return Form(
          key: _otpFormKey,
          child: Column(
            key: const ValueKey('otp_step'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter 6 Digits Code",
                style: TextStyles.title.copyWith(fontWeight: FontWeight.w600),
              ),
              const Gap(12),
              Text(
                "Enter the 6 digits code that you received on your email.",
                style: TextStyles.body1,
              ),
              const Gap(24),
              OtpInputWidget(
                length: 6,
                controller: cubit.otpController,
                onCompleted: (code) {
                  
                },
              ),
              const Gap(32),
              state is VerifyOtpLoadingState
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
                  : MainButton(
                      title: "Continue",
                      onTap: () {
                        if (cubit.otpController.text.length < 6) {
                          mydiag(context, "Please enter all 6 digits", AppColors.redcolor);
                          return;
                        }
                        cubit.verifyOtp();
                      },
                    ),
            ],
          ),
        );
      case 2:
        return Form(
          key: _passwordFormKey,
          child: Column(
            key: const ValueKey('password_step'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reset Password",
                style: TextStyles.title.copyWith(fontWeight: FontWeight.w600),
              ),
              const Gap(12),
              Text(
                "Set the new password for your account so you can login and access all the features.",
                style: TextStyles.body1,
              ),
              const Gap(24),
              CustomPassField(
                controller: cubit.newPasswordController,
                hintText: "New Password",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter new password";
                  }
                  if (!isPasswordValid(value)) {
                    return "Min 8 characters must contain (A-Z, a-z, 0-9, special)";
                  }
                  return null;
                },
              ),
              const Gap(16),
              CustomPassField(
                controller: cubit.confirmPasswordController,
                hintText: "Re-enter Password",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please re-enter password";
                  }
                  if (value != cubit.newPasswordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              const Gap(32),
              state is ResetPasswordLoadingState
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
                  : MainButton(
                      title: "Update Password",
                      onTap: () {
                        if (_passwordFormKey.currentState!.validate()) {
                          cubit.resetPassword();
                        }
                      },
                    ),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }
}

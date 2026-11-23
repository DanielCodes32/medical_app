import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_app/core/constants/app_assets.dart';
import 'package:medical_app/core/functions/custom_snake_bar.dart';
import 'package:medical_app/core/functions/validation.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';
import 'package:medical_app/core/widgets/main_button.dart';
import 'package:medical_app/core/widgets/mybodyview.dart';
import 'package:medical_app/features/patient_profile/presentation/cubit/patient_profile_cubit.dart';
import 'package:medical_app/features/patient_profile/presentation/cubit/patient_profile_state.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  void _pickImage(BuildContext context) async {
    final cubit = context.read<PatientProfileCubit>();
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.lightgrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Gap(16),
              Text(
                "Choose Profile Photo",
                style: TextStyles.title.copyWith(fontSize: 18),
              ),
              const Gap(16),
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded,
                    color: AppColors.primaryColor),
                title: const Text("Take Photo"),
                onTap: () async {
                  Navigator.pop(bottomSheetCtx);
                  final file =
                      await picker.pickImage(source: ImageSource.camera);
                  if (file != null) cubit.setImageFile(File(file.path));
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded,
                    color: AppColors.primaryColor),
                title: const Text("Choose from Gallery"),
                onTap: () async {
                  Navigator.pop(bottomSheetCtx);
                  final file =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (file != null) cubit.setImageFile(File(file.path));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final cubit = context.read<PatientProfileCubit>();
    final initialDate = cubit.selectedDate ?? DateTime(2000, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppColors.blackColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      cubit.setBirthDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkwhite,
      appBar: AppBar(
        title: Text(
          "Patient Profile",
          style: TextStyles.title.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<PatientProfileCubit, PatientProfileState>(
        listener: (context, state) {
          if (state is PatientProfileSuccess) {
            mydiag(context, state.message, AppColors.primaryColor);
            Navigator.pop(context, true);
          } else if (state is PatientProfileError) {
            mydiag(context, state.message, AppColors.redcolor);
          }
        },
        builder: (context, state) {
          final cubit = context.read<PatientProfileCubit>();
          final isUpdating =
              state is PatientProfileUpdating || state is PatientProfileImageUploading;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: MyBodyView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Subtitle Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.lightgrey1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primaryColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_pin_rounded,
                              color: AppColors.primaryColor,
                              size: 26,
                            ),
                          ),
                          const Gap(14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Personal Information",
                                  style: TextStyles.title.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Gap(2),
                                Text(
                                  "Complete your profile info to enable instant appointment bookings.",
                                  style: TextStyles.caption2.copyWith(
                                    color: AppColors.bodycolor,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(24),

                    // Profile Photo Avatar
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          GestureDetector(
                            onTap: () => _pickImage(context),
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.backgroundColor,
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: cubit.pickedImageFile != null
                                    ? Image.file(
                                        cubit.pickedImageFile!,
                                        fit: BoxFit.cover,
                                      )
                                    : (cubit.imageUrl.isNotEmpty
                                        ? Image.network(
                                            cubit.imageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                                Image.asset(
                                              AppAssets.profile,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Image.asset(
                                            AppAssets.profile,
                                            fit: BoxFit.cover,
                                          )),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _pickImage(context),
                            child: Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(8),
                    Center(
                      child: TextButton.icon(
                        onPressed: () => _pickImage(context),
                        icon: const Icon(Icons.edit_rounded, size: 16),
                        label: Text(
                          "Change Photo",
                          style: TextStyles.caption2.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Gap(20),

                    // --- Gender Selector ---
                    Text(
                      "Gender",
                      style: TextStyles.body1.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ),
                    const Gap(8),
                    Row(
                      children: [
                        _buildGenderCard(
                          context: context,
                          label: "Male",
                          icon: Icons.male_rounded,
                          isSelected: cubit.selectedGender.toLowerCase() == "male",
                          onTap: () => cubit.setGender("Male"),
                        ),
                        const Gap(12),
                        _buildGenderCard(
                          context: context,
                          label: "Female",
                          icon: Icons.female_rounded,
                          isSelected:
                              cubit.selectedGender.toLowerCase() == "female",
                          onTap: () => cubit.setGender("Female"),
                        ),
                      ],
                    ),
                    const Gap(22),

                    // --- Date of Birth ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Date of Birth",
                          style: TextStyles.body1.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                          ),
                        ),
                        if (cubit.calculatedAge != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.purple.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "${cubit.calculatedAge} years old",
                              style: TextStyles.caption2.copyWith(
                                color: AppColors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Gap(8),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: cubit.pickedDay != null
                                ? AppColors.primaryColor
                                : AppColors.lightgrey1,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_rounded,
                              color: AppColors.primaryColor,
                              size: 22,
                            ),
                            const Gap(12),
                            Expanded(
                              child: cubit.pickedDay != null
                                  ? Row(
                                      children: [
                                        _buildDateBlock(
                                          title: "Day",
                                          value: cubit.pickedDay
                                              .toString()
                                              .padLeft(2, '0'),
                                        ),
                                        const Gap(8),
                                        _buildDateBlock(
                                          title: "Month",
                                          value: cubit.pickedMonth
                                              .toString()
                                              .padLeft(2, '0'),
                                        ),
                                        const Gap(8),
                                        _buildDateBlock(
                                          title: "Year",
                                          value: cubit.pickedYear.toString(),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      "Select your birth date",
                                      style: TextStyles.body1.copyWith(
                                        color: AppColors.greycolor,
                                      ),
                                    ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down_circle_outlined,
                              color: AppColors.primaryColor,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(22),

                    // --- Mobile Number ---
                    Text(
                      "Mobile Number",
                      style: TextStyles.body1.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ),
                    const Gap(8),
                    TextFormField(
                      controller: cubit.mobileController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-]')),
                      ],
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return "Mobile number is required";
                        }
                        if (!isEgyptianPhoneValid(val)) {
                          return "Please enter a valid Egyptian mobile number (e.g. 01012345678)";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "+201012345678",
                        hintStyle: TextStyles.body1
                            .copyWith(color: AppColors.greycolor),
                        prefixIcon: const Icon(
                          Icons.phone_android_rounded,
                          color: AppColors.primaryColor,
                        ),
                        filled: true,
                        fillColor: AppColors.backgroundColor,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.lightgrey1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.lightgrey1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: AppColors.primaryColor, width: 1.5),
                        ),
                      ),
                    ),
                    const Gap(36),

                    // Save Profile Button
                    isUpdating
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                                const Gap(8),
                                Text(
                                  state is PatientProfileImageUploading
                                      ? "Uploading photo to Cloudinary..."
                                      : "Saving profile...",
                                  style: TextStyles.caption2.copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : MainButton(
                            title: "Save Profile",
                            onTap: () => cubit.saveProfile(),
                          ),
                    const Gap(24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGenderCard({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryColor
                  : AppColors.lightgrey1,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color:
                    isSelected ? Colors.white : AppColors.primaryColor,
                size: 22,
              ),
              const Gap(8),
              Text(
                label,
                style: TextStyles.title.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color:
                      isSelected ? Colors.white : AppColors.blackColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateBlock({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyles.caption2.copyWith(
              fontSize: 9,
              color: AppColors.greycolor,
            ),
          ),
          Text(
            value,
            style: TextStyles.title.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

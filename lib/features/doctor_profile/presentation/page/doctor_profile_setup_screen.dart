import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:medical_app/core/functions/custom_snake_bar.dart';
import 'package:medical_app/core/functions/navigations.dart';
import 'package:medical_app/core/routes/routes.dart';
import 'package:medical_app/core/styles/app_colors.dart';
import 'package:medical_app/core/styles/text_styles.dart';
import 'package:medical_app/core/widgets/custom_form_field.dart';
import 'package:medical_app/core/widgets/custom_image_picker.dart';
import 'package:medical_app/core/widgets/main_button.dart';
import 'package:medical_app/core/widgets/mybodyview.dart';
import 'package:medical_app/features/doctor_profile/data/data_sources/egypt_locations.dart';
import 'package:medical_app/features/doctor_profile/data/models/doctor_profile_model.dart';
import 'package:medical_app/features/doctor_profile/presentation/cubit/doctor_profile_cubit.dart';
import 'package:medical_app/features/doctor_profile/presentation/cubit/doctor_profile_state.dart';

class DoctorProfileSetupScreen extends StatefulWidget {
  const DoctorProfileSetupScreen({super.key});

  @override
  State<DoctorProfileSetupScreen> createState() => _DoctorProfileSetupScreenState();
}

class _DoctorProfileSetupScreenState extends State<DoctorProfileSetupScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorProfileCubit(),
      child: BlocConsumer<DoctorProfileCubit, DoctorProfileState>(
        listener: (context, state) {
          if (state is DoctorProfileSuccess) {
            mydiag(context, state.message, AppColors.primaryColor);
            pushReplacement(context, Routes.home);
          } else if (state is DoctorProfileError) {
            mydiag(context, state.message, AppColors.redcolor);
          } else if (state is ImageUploadingState) {
            mydiag(context, "Uploading image to Cloudinary...", AppColors.primaryColor);
          }
        },
        builder: (context, state) {
          final cubit = context.read<DoctorProfileCubit>();

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                "Doctor Profile Setup",
                style: TextStyles.title.copyWith(fontSize: 22),
              ),
            ),
            body: MyBodyView(
              child: Form(
                key: cubit.formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(10),
                      Text(
                        "Set up your professional profile and clinic details to start accepting patient appointments.",
                        style: TextStyles.body1,
                      ),
                      const Gap(24),

                      // Doctor Profile Image Picker
                      Center(
                        child: CustomImagePicker(
                          onImagePicked: (file) {
                            cubit.setImageFile(file);
                          },
                          initialImagePath: cubit.imageUrl.isNotEmpty ? cubit.imageUrl : null,
                        ),
                      ),
                      const Gap(30),

                      // --- Section 1: Professional Information ---
                      _buildSectionTitle("Professional Information"),
                      const Gap(14),

                      // Specialization Dropdown
                      Text("Specialization", style: TextStyles.body1.copyWith(fontWeight: FontWeight.w600, color: AppColors.blackColor)),
                      const Gap(6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.lightgrey1, width: 1.5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: cubit.selectedSpecialization,
                            items: DoctorProfileDataConstants.specializations.map((spec) {
                              return DropdownMenuItem<String>(
                                value: spec,
                                child: Text(spec, style: TextStyles.body1.copyWith(color: AppColors.blackColor)),
                              );
                            }).toList(),
                            onChanged: (val) => cubit.setSpecialization(val),
                          ),
                        ),
                      ),
                      const Gap(18),

                      // Department
                      Text("Department", style: TextStyles.body1.copyWith(fontWeight: FontWeight.w600, color: AppColors.blackColor)),
                      const Gap(6),
                      CustomFormField(
                        controller: cubit.departmentController,
                        hintText: "Enter Department",
                        validator: (val) => (val == null || val.trim().isEmpty) ? "Department is required" : null,
                      ),
                      const Gap(18),

                      // License Number
                      Text("License Number", style: TextStyles.body1.copyWith(fontWeight: FontWeight.w600, color: AppColors.blackColor)),
                      const Gap(6),
                      CustomFormField(
                        controller: cubit.licenseNumberController,
                        hintText: "e.g. MED-EG-2024-88492",
                        validator: (val) => (val == null || val.trim().isEmpty) ? "License number is required" : null,
                      ),
                      const Gap(18),

                      // Phone Number
                      Text("Phone Number", style: TextStyles.body1.copyWith(fontWeight: FontWeight.w600, color: AppColors.blackColor)),
                      const Gap(6),
                      TextFormField(
                        controller: cubit.phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-]'))],
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return "Phone number is required";
                          if (val.trim().length < 8) return "Please enter a valid phone number";
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "+201012345678",
                          hintStyle: TextStyles.body1.copyWith(color: AppColors.greycolor),
                        ),
                      ),
                      const Gap(18),

                      // Bio
                      Text("Bio", style: TextStyles.body1.copyWith(fontWeight: FontWeight.w600, color: AppColors.blackColor)),
                      const Gap(6),
                      CustomFormField(
                        controller: cubit.bioController,
                        hintText: "Enter bio & medical summary",
                        maxlines: false,
                        validator: (val) => (val == null || val.trim().isEmpty) ? "Bio is required" : null,
                      ),
                      const Gap(18),

                      // Education
                      Text("Education", style: TextStyles.body1.copyWith(fontWeight: FontWeight.w600, color: AppColors.blackColor)),
                      const Gap(6),
                      CustomFormField(
                        controller: cubit.educationController,
                        hintText: "e.g. M.B.B.Ch, M.Sc. Cardiology - Cairo University",
                        validator: (val) => (val == null || val.trim().isEmpty) ? "Education details are required" : null,
                      ),
                      const Gap(18),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Experience (Years)", style: TextStyles.body1.copyWith(fontWeight: FontWeight.w600, color: AppColors.blackColor)),
                                const Gap(6),
                                TextFormField(
                                  controller: cubit.experienceYearsController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) return "Required";
                                    final n = int.tryParse(val);
                                    if (n == null || n < 0 || n > 60) return "Invalid years";
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "8",
                                    hintStyle: TextStyles.body1.copyWith(color: AppColors.greycolor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Consultation Price (EGP)", style: TextStyles.body1.copyWith(fontWeight: FontWeight.w600, color: AppColors.blackColor)),
                                const Gap(6),
                                TextFormField(
                                  controller: cubit.priceController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) return "Required";
                                    final p = num.tryParse(val);
                                    if (p == null || p <= 0) return "Invalid price";
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "300",
                                    hintStyle: TextStyles.body1.copyWith(color: AppColors.greycolor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(30),

                      // --- Section 2: Clinic Address & Location ---
                      _buildSectionTitle("Clinic Address & Location"),
                      const Gap(14),

                      // Governorate Dropdown (Egypt)
                      Text("Governorate (Egypt)", style: TextStyles.body1.copyWith(fontWeight: FontWeight.w600, color: AppColors.blackColor)),
                      const Gap(6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.lightgrey1, width: 1.5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: cubit.selectedGovernorate,
                            items: DoctorProfileDataConstants.egyptGovernoratesWithCities.keys.map((gov) {
                              return DropdownMenuItem<String>(
                                value: gov,
                                child: Text(gov, style: TextStyles.body1.copyWith(color: AppColors.blackColor)),
                              );
                            }).toList(),
                            onChanged: (val) => cubit.setGovernorate(val),
                          ),
                        ),
                      ),
                      const Gap(18),

                      // City Dropdown (Egypt)
                      Text("City (Egypt)", style: TextStyles.body1.copyWith(fontWeight: FontWeight.w600, color: AppColors.blackColor)),
                      const Gap(6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.lightgrey1, width: 1.5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: cubit.selectedCity.isNotEmpty ? cubit.selectedCity : null,
                            items: (DoctorProfileDataConstants.egyptGovernoratesWithCities[cubit.selectedGovernorate] ?? [])
                                .map((city) {
                              return DropdownMenuItem<String>(
                                value: city,
                                child: Text(city, style: TextStyles.body1.copyWith(color: AppColors.blackColor)),
                              );
                            }).toList(),
                            onChanged: (val) => cubit.setCity(val),
                          ),
                        ),
                      ),
                      const Gap(18),

                      // Street Address
                      Text("Street Address", style: TextStyles.body1.copyWith(fontWeight: FontWeight.w600, color: AppColors.blackColor)),
                      const Gap(6),
                      CustomFormField(
                        controller: cubit.streetController,
                        hintText: "e.g. 123 El-Tahrir Street, Floor 3, Suite 302",
                        validator: (val) => (val == null || val.trim().isEmpty) ? "Street address is required" : null,
                      ),
                      const Gap(18),

                      // Google Maps Coordinates Picker
                      Text("Clinic Map Coordinates", style: TextStyles.body1.copyWith(fontWeight: FontWeight.w600, color: AppColors.blackColor)),
                      const Gap(6),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: cubit.latitudeController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                              decoration: const InputDecoration(hintText: "Latitude (30.0444)"),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) return "Lat required";
                                final v = double.tryParse(val);
                                if (v == null || v < -90 || v > 90) return "Invalid Lat";
                                return null;
                              },
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: TextFormField(
                              controller: cubit.longitudeController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                              decoration: const InputDecoration(hintText: "Longitude (31.2357)"),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) return "Lng required";
                                final v = double.tryParse(val);
                                if (v == null || v < -180 || v > 180) return "Invalid Lng";
                                return null;
                              },
                            ),
                          ),
                          const Gap(10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () => _openLocationPickerDialog(context, cubit),
                            child: const Icon(Icons.map, color: Colors.white),
                          ),
                        ],
                      ),
                      const Gap(30),

                      // --- Section 3: Appointment Settings ---
                      _buildSectionTitle("Appointment Settings"),
                      const Gap(14),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Slot Duration (Min)", style: TextStyles.body1.copyWith(fontWeight: FontWeight.w600, color: AppColors.blackColor)),
                                const Gap(6),
                                TextFormField(
                                  controller: cubit.slotDurationController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) return "Required";
                                    final v = int.tryParse(val);
                                    if (v == null || v < 10 || v > 120) return "10-120 min";
                                    return null;
                                  },
                                  decoration: const InputDecoration(hintText: "30"),
                                ),
                              ],
                            ),
                          ),
                          const Gap(16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Buffer Time (Min)", style: TextStyles.body1.copyWith(fontWeight: FontWeight.w600, color: AppColors.blackColor)),
                                const Gap(6),
                                TextFormField(
                                  controller: cubit.bufferTimeController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) return "Required";
                                    final v = int.tryParse(val);
                                    if (v == null || v < 0 || v > 60) return "0-60 min";
                                    return null;
                                  },
                                  decoration: const InputDecoration(hintText: "10"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(18),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Max Patients / Day", style: TextStyles.body1.copyWith(fontWeight: FontWeight.w600, color: AppColors.blackColor)),
                                const Gap(6),
                                TextFormField(
                                  controller: cubit.maxPatientsPerDayController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) return "Required";
                                    final v = int.tryParse(val);
                                    if (v == null || v < 1 || v > 100) return "1-100";
                                    return null;
                                  },
                                  decoration: const InputDecoration(hintText: "15"),
                                ),
                              ],
                            ),
                          ),
                          const Gap(16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Advance Booking (Days)", style: TextStyles.body1.copyWith(fontWeight: FontWeight.w600, color: AppColors.blackColor)),
                                const Gap(6),
                                TextFormField(
                                  controller: cubit.advanceBookingDaysController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) return "Required";
                                    final v = int.tryParse(val);
                                    if (v == null || v < 1 || v > 180) return "1-180 days";
                                    return null;
                                  },
                                  decoration: const InputDecoration(hintText: "30"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(30),

                      // --- Section 4: Weekly Available Schedule ---
                      _buildSectionTitle("Weekly Schedule"),
                      const Gap(14),

                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cubit.availableSchedules.length,
                        separatorBuilder: (context, index) => const Gap(12),
                        itemBuilder: (context, index) {
                          final item = cubit.availableSchedules[index];
                          return _buildScheduleItemCard(context, cubit, index, item);
                        },
                      ),
                      const Gap(35),

                      // Submit Button
                      state is DoctorProfileLoading
                          ? const Center(
                              child: CircularProgressIndicator(color: AppColors.primaryColor),
                            )
                          : MainButton(
                              title: "Save Doctor Profile",
                              onTap: () {
                                cubit.submitProfile();
                              },
                            ),
                      const Gap(30),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(width: 4, height: 18, color: AppColors.primaryColor),
          const Gap(8),
          Text(
            title,
            style: TextStyles.title.copyWith(fontSize: 17, color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItemCard(
      BuildContext context, DoctorProfileCubit cubit, int index, AvailableScheduleModel item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: item.isworkingday ? AppColors.primaryColor : AppColors.lightgrey1,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.dayofweek,
                style: TextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: item.isworkingday ? AppColors.blackColor : AppColors.greycolor,
                ),
              ),
              Row(
                children: [
                  Text(
                    item.isworkingday ? "Working" : "Off",
                    style: TextStyles.caption2.copyWith(
                      color: item.isworkingday ? AppColors.primaryColor : AppColors.redcolor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Switch(
                    value: item.isworkingday,
                    activeTrackColor: AppColors.primaryColor,
                    onChanged: (val) => cubit.toggleDayWorking(index, val),
                  ),

                ],
              ),
            ],
          ),
          if (item.isworkingday) ...[
            const Divider(),
            const Gap(6),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 10, minute: 0),
                      );
                      if (time != null) {
                        final formatted = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
                        final end = item.workinghours?.endtime ?? "18:00";
                        cubit.updateWorkingHours(index, formatted, end);
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: "Work Start", contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                      child: Text(item.workinghours?.starttime ?? "10:00", style: TextStyles.body1),
                    ),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 18, minute: 0),
                      );
                      if (time != null) {
                        final formatted = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
                        final start = item.workinghours?.starttime ?? "10:00";
                        cubit.updateWorkingHours(index, start, formatted);
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: "Work End", contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                      child: Text(item.workinghours?.endtime ?? "18:00", style: TextStyles.body1),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 14, minute: 0),
                      );
                      if (time != null) {
                        final formatted = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
                        final end = item.breakhours?.endtime ?? "15:00";
                        cubit.updateBreakHours(index, formatted, end);
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: "Break Start", contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                      child: Text(item.breakhours?.starttime ?? "None", style: TextStyles.body1),
                    ),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 15, minute: 0),
                      );
                      if (time != null) {
                        final formatted = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
                        final start = item.breakhours?.starttime ?? "14:00";
                        cubit.updateBreakHours(index, start, formatted);
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: "Break End", contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                      child: Text(item.breakhours?.endtime ?? "None", style: TextStyles.body1),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _openLocationPickerDialog(BuildContext context, DoctorProfileCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        final latCtrl = TextEditingController(text: cubit.latitudeController.text);
        final lngCtrl = TextEditingController(text: cubit.longitudeController.text);
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text("Select Location Coordinates", style: TextStyles.title.copyWith(fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Extract coordinates from Google Maps or enter clinic Latitude & Longitude:",
                style: TextStyles.body1,
              ),
              const Gap(14),
              TextField(
                controller: latCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                decoration: const InputDecoration(labelText: "Latitude (e.g. 30.0444)"),
              ),
              const Gap(10),
              TextField(
                controller: lngCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                decoration: const InputDecoration(labelText: "Longitude (e.g. 31.2357)"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text("Cancel", style: TextStyles.body1.copyWith(color: AppColors.greycolor)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
              onPressed: () {
                final lat = double.tryParse(latCtrl.text.trim());
                final lng = double.tryParse(lngCtrl.text.trim());
                if (lat != null && lng != null) {
                  cubit.setLocationCoordinates(lat, lng);
                  Navigator.pop(dialogCtx);
                }
              },
              child: Text("Set Coordinates", style: TextStyles.button.copyWith(fontSize: 14)),
            ),
          ],
        );
      },
    );
  }
}

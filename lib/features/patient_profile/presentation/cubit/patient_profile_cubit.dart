import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_app/core/functions/upload.dart';
import 'package:medical_app/core/services/local/shared_pref.dart';
import 'package:medical_app/features/patient_profile/data/models/patient_profile_request.dart';
import 'package:medical_app/features/patient_profile/data/repo/patient_profile_repo.dart';
import 'package:medical_app/features/patient_profile/presentation/cubit/patient_profile_state.dart';

class PatientProfileCubit extends Cubit<PatientProfileState> {
  PatientProfileCubit() : super(PatientProfileInitial()) {
    init();
  }

  final formKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();

  String selectedGender = "Male";
  int? pickedDay;
  int? pickedMonth;
  int? pickedYear;
  DateTime? selectedDate;

  File? pickedImageFile;
  String imageUrl = "";
  String patientId = "";

  void init() {
    patientId = SharedPref.getSpecializedId().toString();

    // Pre-fill from local storage if available
    final cachedImage = SharedPref.getPatientImage();
    final cachedMobile = SharedPref.getPatientMobile();
    final cachedGender = SharedPref.getPatientGender();
    final cachedDay = SharedPref.getPatientDobDay();
    final cachedMonth = SharedPref.getPatientDobMonth();
    final cachedYear = SharedPref.getPatientDobYear();

    if (cachedImage.isNotEmpty) imageUrl = cachedImage;
    if (cachedMobile.isNotEmpty) mobileController.text = cachedMobile;
    if (cachedGender.isNotEmpty) selectedGender = cachedGender;
    if (cachedDay != null && cachedMonth != null && cachedYear != null) {
      pickedDay = cachedDay;
      pickedMonth = cachedMonth;
      pickedYear = cachedYear;
      selectedDate = DateTime(cachedYear, cachedMonth, cachedDay);
    }

    // Also fetch remote profile to ensure freshest data
    fetchRemoteProfile();
  }

  Future<void> fetchRemoteProfile() async {
    if (patientId.isEmpty) return;

    final result = await PatientProfileRepo.getPatientProfile(patientId);
    result.fold(
      (failure) {
        // Fall back quietly to local cache
        emit(PatientProfileLoaded());
      },
      (data) {
        try {
          Map<String, dynamic>? map;
          if (data is Map<String, dynamic>) {
            if (data['data'] is Map<String, dynamic>) {
              map = data['data'] as Map<String, dynamic>;
            } else if (data['patient'] is Map<String, dynamic>) {
              map = data['patient'] as Map<String, dynamic>;
            } else {
              map = data;
            }
          }

          if (map != null) {
            final remoteGender = map['gender'] as String?;
            final remotePhone = (map['mobileNumber'] ??
                map['phone'] ??
                map['phonenumber']) as String?;
            final remoteImage = (map['image'] ??
                map['imageurl'] ??
                map['profile_image']) as String?;

            if (remoteGender != null && remoteGender.isNotEmpty) {
              selectedGender = remoteGender;
            }
            if (remotePhone != null &&
                remotePhone.isNotEmpty &&
                mobileController.text.isEmpty) {
              mobileController.text = remotePhone;
            }
            if (remoteImage != null &&
                remoteImage.isNotEmpty &&
                imageUrl.isEmpty) {
              imageUrl = remoteImage;
            }

            // Check age / dob
            if (map['age'] is Map<String, dynamic>) {
              final ageMap = map['age'] as Map<String, dynamic>;
              pickedDay = ageMap['day'] as int? ?? pickedDay;
              pickedMonth = ageMap['month'] as int? ?? pickedMonth;
              pickedYear = ageMap['year'] as int? ?? pickedYear;
              if (pickedYear != null &&
                  pickedMonth != null &&
                  pickedDay != null) {
                selectedDate = DateTime(pickedYear!, pickedMonth!, pickedDay!);
              }
            } else if (map['dateofbirth'] != null || map['dob'] != null) {
              final dobStr = (map['dateofbirth'] ?? map['dob'])?.toString();
              final parsed = dobStr != null ? DateTime.tryParse(dobStr) : null;
              if (parsed != null) {
                selectedDate = parsed;
                pickedDay = parsed.day;
                pickedMonth = parsed.month;
                pickedYear = parsed.year;
              }
            }

            // If remote profile already has all required info, mark complete locally
            final isComplete = selectedGender.isNotEmpty &&
                mobileController.text.isNotEmpty &&
                pickedDay != null &&
                pickedMonth != null &&
                pickedYear != null;

            if (isComplete) {
              SharedPref.savePatientProfileLocal(
                image: imageUrl,
                mobile: mobileController.text.trim(),
                gender: selectedGender,
                day: pickedDay,
                month: pickedMonth,
                year: pickedYear,
              );
            }
          }
        } catch (_) {}
        emit(PatientProfileLoaded());
      },
    );
  }

  void setGender(String gender) {
    selectedGender = gender;
    emit(PatientProfileLoaded());
  }

  void setBirthDate(DateTime date) {
    selectedDate = date;
    pickedDay = date.day;
    pickedMonth = date.month;
    pickedYear = date.year;
    emit(PatientProfileLoaded());
  }

  void setImageFile(File? file) {
    pickedImageFile = file;
    emit(PatientProfileLoaded());
  }

  int? get calculatedAge {
    if (selectedDate == null) return null;
    final now = DateTime.now();
    int age = now.year - selectedDate!.year;
    if (now.month < selectedDate!.month ||
        (now.month == selectedDate!.month && now.day < selectedDate!.day)) {
      age--;
    }
    return age >= 0 ? age : 0;
  }

  Future<void> saveProfile() async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return;
    }

    if (pickedDay == null || pickedMonth == null || pickedYear == null) {
      emit(PatientProfileError("Please select your birth date"));
      return;
    }

    emit(PatientProfileUpdating());

    try {
      String finalImageUrl = imageUrl;

      // Step 1: Upload image to Cloudinary if new image picked
      if (pickedImageFile != null) {
        emit(PatientProfileImageUploading());
        final uploadedUrl = await uploadToCloudinary(pickedImageFile!);
        if (uploadedUrl == null || uploadedUrl.isEmpty) {
          emit(PatientProfileError(
              "Failed to upload profile image to Cloudinary. Please try again."));
          return;
        }
        finalImageUrl = uploadedUrl;
        imageUrl = finalImageUrl;
      }

      // Step 2: Build PatientProfileRequest payload
      final request = PatientProfileRequest(
        age: AgeModel(
          day: pickedDay,
          month: pickedMonth,
          year: pickedYear,
        ),
        gender: selectedGender,
        image: finalImageUrl,
        mobileNumber: mobileController.text.trim(),
        patientid: patientId,
      );

      // Step 3: Call Repo PUT /api/patients/:id
      final result = await PatientProfileRepo.updatePatientProfile(
        patientId: patientId,
        request: request,
      );

      result.fold(
        (failure) {
          emit(PatientProfileError(
              failure.message ?? "Failed to update patient profile"));
        },
        (data) async {
          // Step 4: Persist locally
          await SharedPref.savePatientProfileLocal(
            image: finalImageUrl,
            mobile: mobileController.text.trim(),
            gender: selectedGender,
            day: pickedDay,
            month: pickedMonth,
            year: pickedYear,
          );

          emit(PatientProfileSuccess("Profile updated successfully!"));
        },
      );
    } catch (e) {
      emit(PatientProfileError("An unexpected error occurred: $e"));
    }
  }

  @override
  Future<void> close() {
    mobileController.dispose();
    return super.close();
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_app/core/functions/upload.dart';
import 'package:medical_app/core/services/local/shared_pref.dart';
import 'package:medical_app/features/doctor_profile/data/data_sources/egypt_locations.dart';
import 'package:medical_app/features/doctor_profile/data/models/doctor_profile_model.dart';
import 'package:medical_app/features/doctor_profile/data/repo/doctor_profile_repo.dart';
import 'package:medical_app/features/doctor_profile/presentation/cubit/doctor_profile_state.dart';

class DoctorProfileCubit extends Cubit<DoctorProfileState> {
  DoctorProfileCubit() : super(DoctorProfileInitial()) {
    _initDefaultSchedules();
  }

  final formKey = GlobalKey<FormState>();

  // Controllers
  final departmentController = TextEditingController(text: "Cardiovascular Medicine");
  final licenseNumberController = TextEditingController(text: "MED-EG-2024-88492");
  final phoneController = TextEditingController(text: "+201012345678");
  final bioController = TextEditingController(
      text: "Consultant Cardiologist with over 8 years of experience in interventional cardiology and preventative heart care.");
  final experienceYearsController = TextEditingController(text: "8");
  final educationController = TextEditingController(text: "M.B.B.Ch, M.Sc. Cardiology - Cairo University");
  final priceController = TextEditingController(text: "300");
  final streetController = TextEditingController(text: "123 El-Tahrir Street, Floor 3, Suite 302");
  final latitudeController = TextEditingController(text: "30.0444");
  final longitudeController = TextEditingController(text: "31.2357");

  // Appointment Settings Controllers
  final slotDurationController = TextEditingController(text: "30");
  final bufferTimeController = TextEditingController(text: "10");
  final maxPatientsPerDayController = TextEditingController(text: "15");
  final advanceBookingDaysController = TextEditingController(text: "30");

  // State Selections
  String selectedSpecialization = "Cardiology";
  String selectedGovernorate = "Cairo";
  String selectedCity = "Cairo";

  File? pickedImageFile;
  String imageUrl = "";

  List<AvailableScheduleModel> availableSchedules = [];

  void _initDefaultSchedules() {
    availableSchedules = [
      AvailableScheduleModel(
        dayofweek: "Sunday",
        dayindex: 1,
        isworkingday: true,
        workinghours: TimeSlotModel(starttime: "10:00", endtime: "18:00"),
        breakhours: TimeSlotModel(starttime: "14:00", endtime: "15:00"),
      ),
      AvailableScheduleModel(
        dayofweek: "Monday",
        dayindex: 2,
        isworkingday: true,
        workinghours: TimeSlotModel(starttime: "10:00", endtime: "18:00"),
        breakhours: TimeSlotModel(starttime: "14:00", endtime: "15:00"),
      ),
      AvailableScheduleModel(
        dayofweek: "Tuesday",
        dayindex: 3,
        isworkingday: true,
        workinghours: TimeSlotModel(starttime: "12:00", endtime: "20:00"),
        breakhours: null,
      ),
      AvailableScheduleModel(
        dayofweek: "Wednesday",
        dayindex: 4,
        isworkingday: true,
        workinghours: TimeSlotModel(starttime: "10:00", endtime: "18:00"),
        breakhours: TimeSlotModel(starttime: "14:00", endtime: "15:00"),
      ),
      AvailableScheduleModel(
        dayofweek: "Thursday",
        dayindex: 5,
        isworkingday: true,
        workinghours: TimeSlotModel(starttime: "10:00", endtime: "16:00"),
        breakhours: null,
      ),
      AvailableScheduleModel(
        dayofweek: "Friday",
        dayindex: 6,
        isworkingday: false,
        workinghours: null,
        breakhours: null,
      ),
      AvailableScheduleModel(
        dayofweek: "Saturday",
        dayindex: 7,
        isworkingday: false,
        workinghours: null,
        breakhours: null,
      ),
    ];
  }

  void setImageFile(File? file) {
    pickedImageFile = file;
    emit(DropdownUpdatedState());
  }

  void setSpecialization(String? val) {
    if (val != null) {
      selectedSpecialization = val;
      emit(DropdownUpdatedState());
    }
  }

  void setGovernorate(String? val) {
    if (val != null) {
      selectedGovernorate = val;
      final cities = DoctorProfileDataConstants.egyptGovernoratesWithCities[val] ?? [];
      selectedCity = cities.isNotEmpty ? cities.first : '';
      emit(DropdownUpdatedState());
    }
  }

  void setCity(String? val) {
    if (val != null) {
      selectedCity = val;
      emit(DropdownUpdatedState());
    }
  }

  void setLocationCoordinates(double lat, double lng) {
    latitudeController.text = lat.toStringAsFixed(4);
    longitudeController.text = lng.toStringAsFixed(4);
    emit(LocationUpdatedState());
  }

  void toggleDayWorking(int index, bool isWorking) {
    final current = availableSchedules[index];
    availableSchedules[index] = AvailableScheduleModel(
      dayofweek: current.dayofweek,
      dayindex: current.dayindex,
      isworkingday: isWorking,
      workinghours: isWorking
          ? (current.workinghours ?? TimeSlotModel(starttime: "10:00", endtime: "18:00"))
          : null,
      breakhours: isWorking ? current.breakhours : null,
    );
    emit(ScheduleUpdatedState());
  }

  void updateWorkingHours(int index, String start, String end) {
    final current = availableSchedules[index];
    availableSchedules[index] = AvailableScheduleModel(
      dayofweek: current.dayofweek,
      dayindex: current.dayindex,
      isworkingday: current.isworkingday,
      workinghours: TimeSlotModel(starttime: start, endtime: end),
      breakhours: current.breakhours,
    );
    emit(ScheduleUpdatedState());
  }

  void updateBreakHours(int index, String? start, String? end) {
    final current = availableSchedules[index];
    availableSchedules[index] = AvailableScheduleModel(
      dayofweek: current.dayofweek,
      dayindex: current.dayindex,
      isworkingday: current.isworkingday,
      workinghours: current.workinghours,
      breakhours: (start != null && end != null && start.isNotEmpty && end.isNotEmpty)
          ? TimeSlotModel(starttime: start, endtime: end)
          : null,
    );
    emit(ScheduleUpdatedState());
  }

  Future<void> submitProfile() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    emit(DoctorProfileLoading());

    try {
      // Step 1: Upload image to Cloudinary if a local file was picked
      String finalImageUrl = imageUrl;
      if (pickedImageFile != null) {
        emit(ImageUploadingState());
        final uploadedUrl = await uploadToCloudinary(pickedImageFile!);
        if (uploadedUrl == null || uploadedUrl.isEmpty) {
          emit(DoctorProfileError("Failed to upload profile image to Cloudinary. Please try again."));
          return;
        }
        finalImageUrl = uploadedUrl;
        imageUrl = uploadedUrl;
      } else if (finalImageUrl.isEmpty) {
        finalImageUrl = "https://example.com/uploads/doctors/dr_ahmed.jpg";
      }

      // Step 2: Get user ID from SharedPref
      final userId = SharedPref.getuserinfo()?.id ?? SharedPref.getUserId();

      // Step 3: Build DoctorProfileModel payload
      final profileModel = DoctorProfileModel(
        userid: userId,
        specialization: selectedSpecialization,
        department: departmentController.text.trim(),
        licensenumber: licenseNumberController.text.trim(),
        phone: phoneController.text.trim(),
        bio: bioController.text.trim(),
        experienceyears: int.tryParse(experienceYearsController.text.trim()) ?? 0,
        education: educationController.text.trim(),
        price: num.tryParse(priceController.text.trim()) ?? 0,
        imageurl: finalImageUrl,
        clinicaddress: ClinicAddressModel(
          street: streetController.text.trim(),
          city: selectedCity,
          governorate: selectedGovernorate,
          latitude: double.tryParse(latitudeController.text.trim()) ?? 30.0444,
          longitude: double.tryParse(longitudeController.text.trim()) ?? 31.2357,
        ),
        initialmetrics: InitialMetricsModel(
          averagerating: 0.0,
          ratingcount: 0,
          totalappointments: 0,
          totalpatients: 0,
        ),
        appointmentsettings: AppointmentSettingsModel(
          slotdurationminutes: int.tryParse(slotDurationController.text.trim()) ?? 30,
          buffertimeminutes: int.tryParse(bufferTimeController.text.trim()) ?? 10,
          maxpatientsperday: int.tryParse(maxPatientsPerDayController.text.trim()) ?? 15,
          advancebookingdays: int.tryParse(advanceBookingDaysController.text.trim()) ?? 30,
        ),
        availableschedules: availableSchedules,
      );

      // Step 4: Call Repo PUT doctor/:id
      final result = await DoctorProfileRepo.updateDoctorProfile(
        doctorId: userId,
        profileModel: profileModel,
      );

      result.fold(
        (failure) => emit(DoctorProfileError(failure.message ?? "Failed to update profile")),
        (data) => emit(DoctorProfileSuccess("Doctor profile updated successfully!")),
      );
    } catch (e) {
      emit(DoctorProfileError(e.toString()));
    }
  }

}

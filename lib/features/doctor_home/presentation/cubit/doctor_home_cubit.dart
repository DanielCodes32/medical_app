import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_app/core/services/local/shared_pref.dart';
import 'package:medical_app/features/doctor_details/data/models/doctor_details_response/availability.dart';
import 'package:medical_app/features/doctor_details/data/models/doctor_details_response/data.dart';
import 'package:medical_app/features/doctor_details/data/repo/details_repo.dart';
import 'package:medical_app/features/doctor_home/presentation/cubit/doctor_home_state.dart';

class DoctorHomeCubit extends Cubit<DoctorHomeState> {
  final String doctorId;
  final DetailsRepo _detailsRepo;

  DoctorDetailsResponse? doctor;
  String selectedFilter = 'All';

  final List<String> filterOptions = const ['All', 'Pending', 'Confirmed'];

  DoctorHomeCubit({
    String? doctorId,
    DetailsRepo? detailsRepo,
  })  : doctorId = doctorId ??
            (SharedPref.getSpecializedId().toString()),
        _detailsRepo = detailsRepo ?? DetailsRepo(),
        super(DoctorHomeInitial()) {
    getDoctorData();
  }

  Future<void> getDoctorData() async {
    emit(DoctorHomeLoading());
    final result = await _detailsRepo.getDoctorDetails(doctorId);

    result.fold(
      (failure) {
        emit(
          DoctorHomeError(
            message: failure.message ?? 'Failed to load doctor appointments',
          ),
        );
      },
      (data) {
        doctor = data;
        emit(
          DoctorHomeSuccess(
            doctor: data,
            selectedFilter: selectedFilter,
          ),
        );
      },
    );
  }

  void setFilter(String filter) {
    if (selectedFilter == filter) return;
    selectedFilter = filter;
    if (doctor != null) {
      emit(
        DoctorHomeSuccess(
          doctor: doctor!,
          selectedFilter: selectedFilter,
        ),
      );
    }
  }

  List<Availability> get allAppointments => doctor?.availabilities ?? [];

  List<Availability> get filteredAppointments {
    final list = allAppointments;
    if (selectedFilter == 'All') {
      return list;
    }
    return list
        .where(
          (a) => a.status?.toLowerCase() == selectedFilter.toLowerCase(),
        )
        .toList();
  }

  int get pendingCount =>
      allAppointments.where((a) => a.isPending).length;

  int get confirmedCount =>
      allAppointments.where((a) => a.isConfirmed).length;

  int getCountForFilter(String filter) {
    if (filter == 'All') return allAppointments.length;
    if (filter == 'Pending') return pendingCount;
    if (filter == 'Confirmed') return confirmedCount;
    return 0;
  }
}

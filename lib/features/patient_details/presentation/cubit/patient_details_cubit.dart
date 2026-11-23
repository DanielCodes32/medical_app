import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_app/features/patient_details/data/models/patient_details_model.dart';
import 'package:medical_app/features/patient_details/data/repo/patient_details_repo.dart';
import 'package:medical_app/features/patient_details/presentation/cubit/patient_details_state.dart';

class PatientDetailsCubit extends Cubit<PatientDetailsState> {
  final String patientId;
  final PatientDetailsRepo _repo;

  PatientDetailsModel? patient;

  PatientDetailsCubit({
    required this.patientId,
    PatientDetailsRepo? repo,
  })  : _repo = repo ?? PatientDetailsRepo(),
        super(PatientDetailsInitial()) {
    getPatientDetails();
  }

  Future<void> getPatientDetails() async {
    if (patientId.isEmpty) {
      emit(PatientDetailsError("Invalid patient ID"));
      return;
    }

    emit(PatientDetailsLoading());
    final result = await _repo.getPatientDetails(patientId);

    result.fold(
      (failure) {
        emit(
          PatientDetailsError(
            failure.message ?? 'Failed to load patient information',
          ),
        );
      },
      (data) {
        patient = data;
        emit(PatientDetailsSuccess(data));
      },
    );
  }
}


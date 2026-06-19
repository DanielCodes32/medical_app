import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_app/features/home/data/models/popular_doctors_response/datum.dart';
import 'package:medical_app/features/home/data/repo/home_repo.dart';
import 'package:medical_app/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(InitalHomeState());
  List<Datum> popularDoctors = [];
  Future<void> getPopularDoctors() async {
    emit(LoadingHomeState());
    var data = await HomeRepo.getPopularDoctors();
    if (data != null) {
      emit(SuccessHomeState());
      popularDoctors = data.data ?? [];
    } else {
      emit(ErrorHomeState(message: data?.message));
    }
  }
}

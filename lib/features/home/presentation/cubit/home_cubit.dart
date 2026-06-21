import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_app/features/home/data/models/popular_doctors_response/datum.dart';
import 'package:medical_app/features/home/data/repo/home_repo.dart';
import 'package:medical_app/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(InitalHomeState());
  
  List<Datum> popularDoctors = [];
  int currentPage = 1;
  int totalPages = 1;
  bool isLoadingMore = false;

  Future<void> getPopularDoctors({bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore || currentPage > totalPages) return;
      isLoadingMore = true;
      emit(LoadingMoreHomeState());
    } else {
      currentPage = 1;
      totalPages = 1;
      popularDoctors.clear();
      emit(LoadingHomeState());
    }

    var data = await HomeRepo.getPopularDoctors(page: currentPage, limit: 10);
    isLoadingMore = false;

    if (data != null) {
      var newDoctors = data.data ?? [];
      popularDoctors.addAll(newDoctors);
      totalPages = data.totalpages ?? (newDoctors.length == 10 ? currentPage + 1 : currentPage);
      currentPage++;
      emit(SuccessHomeState());
    } else {
      if (loadMore) {
        emit(SuccessHomeState());
      } else {
        emit(ErrorHomeState(message: data?.message ?? "Failed to load doctors"));
      }
    }
  }
}

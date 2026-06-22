import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_app/features/home/data/models/popular_doctors_response/datum.dart';
import 'package:medical_app/features/search/data/repo/search_repo.dart';
import 'package:medical_app/features/search/presentation/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final String? initialQuery;

  SearchCubit({this.initialQuery}) : super(SearchInitial()) {
    searchController.addListener(_onTextChanged);
    if (initialQuery != null && initialQuery!.isNotEmpty) {
      searchController.text = initialQuery!;
    }
  }

  final searchController = TextEditingController();
  List<Datum> books = [];
  int currentPage = 1;
  int totalPages = 1;
  bool isLoadingMore = false;

  void _onTextChanged() {
    final query = searchController.text;
    if (query.isNotEmpty) {
      search(query);
    } else {
      emit(SearchInitial());
      books = [];
    }
  }

  Future<void> search(String query, {bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore || currentPage > totalPages) return;
      isLoadingMore = true;
      emit(SearchLoadingMore());
    } else {
      currentPage = 1;
      totalPages = 1;
      books.clear();
      emit(SearchLoading());
    }

    var data = await SearchRepo().search(
      query,
      currentPage.toString(),
      limit: 10,
    );
    isLoadingMore = false;

    // Guard against race conditions for different query responses
    if (searchController.text != query && !loadMore) return;

    if (data != null) {
      var newDoctors = data.data ?? [];
      books.addAll(newDoctors);
      totalPages =
          data.totalpages ??
          (newDoctors.length == 10 ? currentPage + 1 : currentPage);
      currentPage++;
      emit(SearchSuccess());
    } else {
      if (loadMore) {
        emit(SearchSuccess());
      } else {
        emit(SearchError());
      }
    }
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}

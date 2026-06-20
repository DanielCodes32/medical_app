import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_app/features/home/data/models/popular_doctors_response/datum.dart';
import 'package:medical_app/features/search/data/repo/search_repo.dart';
import 'package:medical_app/features/search/presentation/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial()) {
    // Attach the listener once in the constructor
    searchController.addListener(_onTextChanged);
  }

  final searchController = TextEditingController();
  List<Datum> books = [];

  void _onTextChanged() {
    final query = searchController.text;
    if (query.isNotEmpty) {
      search(query);
    } else {
      emit(SearchInitial());
      books = [];
    }
  }

  Future<void> search(String query) async {
    emit(SearchLoading());
    var data = await SearchRepo().search(query, "1");

    if (data != null) {
      books = data.data?.toList() ?? [];
      emit(SearchSuccess());
    } else {
      emit(SearchError());
    }
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}

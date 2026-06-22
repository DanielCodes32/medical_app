import 'dart:developer';

import 'package:medical_app/core/services/apis/apis.dart';
import 'package:medical_app/core/services/apis/dio_provider.dart';
import 'package:medical_app/core/services/local/shared_pref.dart';
import 'package:medical_app/features/search/data/models/search_response/search_response.dart';

class SearchRepo {
  Future<SearchResponse?> search(
    String q,
    String page, {
    int limit = 10,
  }) async {
    var response = await DioProvider.get(
      endpoint: Apis.searchDoctors,
      headers: {"Authorization": "Bearer ${SharedPref.gettoken()}"},
      queryParameters: {"q": q, "page": page, "limit": limit},
    );
    try {
      if (response.statusCode == 200) {
        return SearchResponse.fromJson(response.data);
      } else {
        return null;
      }
    } on Exception catch (err) {
      log(err.toString());
      return null;
    }
  }
}

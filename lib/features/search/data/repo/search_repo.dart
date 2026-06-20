

import 'dart:developer';

import 'package:medical_app/core/services/apis/apis.dart';
import 'package:medical_app/core/services/apis/dio_provider.dart';
import 'package:medical_app/features/search/data/models/search_response/search_response.dart';

class SearchRepo {

  Future<SearchResponse?> search(String name,String page) async {
    var response = await DioProvider.get(
      endpoint: Apis.search,
      
      queryParameters: {name: name, page: 1},
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

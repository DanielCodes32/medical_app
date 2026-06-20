import 'package:medical_app/features/home/data/models/popular_doctors_response/datum.dart';



class SearchResponse {
  List<Datum>? data;
  int? total;
  int? page;
  int? limit;
  int? totalpages;

  SearchResponse({
    this.data,
    this.total,
    this.page,
    this.limit,
    this.totalpages,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int?,
      page: json['page'] as int?,
      limit: json['limit'] as int?,
      totalpages: json['totalpages'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data?.map((e) => e.toJson()).toList(),
    'total': total,
    'page': page,
    'limit': limit,
    'totalpages': totalpages,
  };
}

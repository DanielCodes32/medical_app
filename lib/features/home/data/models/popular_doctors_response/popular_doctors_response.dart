import 'datum.dart';

class PopularDoctorsResponse {
  List<Datum>? data;
  String? message;
  List<dynamic>? error;
  int? status;
  int? total;
  int? page;
  int? limit;
  int? totalpages;

  PopularDoctorsResponse({
    this.data,
    this.message,
    this.error,
    this.status,
    this.total,
    this.page,
    this.limit,
    this.totalpages,
  });

  factory PopularDoctorsResponse.fromJson(Map<String, dynamic> json) {
    return PopularDoctorsResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
      error: json['error'] as List<dynamic>?,
      status: json['status'] as int?,
      total: json['total'] as int?,
      page: json['page'] as int?,
      limit: json['limit'] as int?,
      totalpages: json['totalpages'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data?.map((e) => e.toJson()).toList(),
    'message': message,
    'error': error,
    'status': status,
    'total': total,
    'page': page,
    'limit': limit,
    'totalpages': totalpages,
  };
}

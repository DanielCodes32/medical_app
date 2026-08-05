class BaseResponse {
  int? status;
  String? message;
  List<dynamic>? error;
  dynamic data;

  BaseResponse({this.status, this.message, this.error, this.data});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    error = json['error'];
    data = json['data'];
  }
 Map<String, dynamic> toJson() => {'status': status, 'message': message, 'error': error, 'data': data}; 
  
}
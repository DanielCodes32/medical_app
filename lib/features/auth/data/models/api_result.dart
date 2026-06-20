class ApiResult {
  final bool success;
  final String? message;
  final Map<String, dynamic>? data;

  ApiResult({required this.success, this.message, this.data});
}

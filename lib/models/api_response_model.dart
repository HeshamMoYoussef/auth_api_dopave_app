class ApiResponse {
  final bool status;
  final String? message;
  final dynamic errors;
  final dynamic data;

  ApiResponse({required this.status, this.message, this.errors, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'] ?? false,
      message: json['message'],
      errors: json['errors'],
      data: json['data'],
    );
  }
}

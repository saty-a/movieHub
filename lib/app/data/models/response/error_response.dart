/// ErrorResponse is a model for error responses.
/// It includes a message, success status, code and optionally error details.

class ErrorResponse {
  late String? message;
  late bool? success;
  late int? code;

  ErrorResponse({required this.message});

  ErrorResponse.fromJson(Map<String, dynamic>? json) {
    message = json == null ? "" : json['message'];
    success = json?['success'];
    code = json?['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['success'] = success;
    data['code'] = code;
    return data;
  }
}

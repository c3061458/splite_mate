///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class RegisterResponseModel {
/*
{
  "message": "User registered successfully",
  "error": "(1062, \"Duplicate entry '1234567890' for key 'users.mobile_UNIQUE'\")",
  "statusCode": 400
}
*/

  String? message;
  String? error;
  int? statusCode;

  RegisterResponseModel({
    this.message,
    this.error,
    this.statusCode,
  });
  RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message']?.toString();
    error = json['error']?.toString();
    statusCode = json['statusCode']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['message'] = message;
    data['error'] = error;
    data['statusCode'] = statusCode;
    return data;
  }
}

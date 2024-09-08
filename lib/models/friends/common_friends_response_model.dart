///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class CommonFriendsResponseModel {
  String? message;
  String? error;

  CommonFriendsResponseModel({
    this.message,
    this.error,
  });
  CommonFriendsResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message']?.toString();
    error = json['error']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['message'] = message;
    data['error'] = error;
    return data;
  }
}

///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class LoginRequestModel {
/*
{
  "mobile": "6353291308",
  "password": "123456"
}
*/

  String? mobile;
  String? password;

  LoginRequestModel({
    this.mobile,
    this.password,
  });
  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile']?.toString();
    password = json['password']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['mobile'] = mobile;
    data['password'] = password;
    return data;
  }
}

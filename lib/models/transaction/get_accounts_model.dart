///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class GetAccountsModelData {
/*
{
  "gender": "male",
  "involved_user_id": 2,
  "involved_user_name": "User 2",
  "total_amount": "2800.00",
  "user_id": 1,
  "user_name": "Test User"
}
*/

  String? gender;
  int? involvedUserId;
  String? involvedUserName;
  String? totalAmount;
  int? userId;
  String? userName;

  GetAccountsModelData({
    this.gender,
    this.involvedUserId,
    this.involvedUserName,
    this.totalAmount,
    this.userId,
    this.userName,
  });
  GetAccountsModelData.fromJson(Map<String, dynamic> json) {
    gender = json['gender']?.toString();
    involvedUserId = json['involved_user_id']?.toInt();
    involvedUserName = json['involved_user_name']?.toString();
    totalAmount = json['total_amount']?.toString();
    userId = json['user_id']?.toInt();
    userName = json['user_name']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['gender'] = gender;
    data['involved_user_id'] = involvedUserId;
    data['involved_user_name'] = involvedUserName;
    data['total_amount'] = totalAmount;
    data['user_id'] = userId;
    data['user_name'] = userName;
    return data;
  }
}

class GetAccountsModel {
/*
{
  "data": [
    {
      "gender": "male",
      "involved_user_id": 2,
      "involved_user_name": "User 2",
      "total_amount": "2800.00",
      "user_id": 1,
      "user_name": "Test User"
    }
  ]
}
*/

  List<GetAccountsModelData?>? data;

  GetAccountsModel({
    this.data,
  });
  GetAccountsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <GetAccountsModelData>[];
      v.forEach((v) {
        arr0.add(GetAccountsModelData.fromJson(v));
      });
      data = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.data != null) {
      final v = this.data;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['data'] = arr0;
    }
    return data;
  }
}

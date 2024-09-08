///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class AddPaymentRequestModelSplits {
  List<int?>? userId;
  int? groupId;
  double? amount;

  AddPaymentRequestModelSplits({
    this.userId,
    this.groupId,
    this.amount,
  });
  AddPaymentRequestModelSplits.fromJson(Map<String, dynamic> json) {
    if (json['user_id'] != null) {
      final v = json['user_id'];
      final arr0 = <int>[];
      v.forEach((v) {
        arr0.add(v.toInt());
      });
      userId = arr0;
    }
    groupId = json['group_id']?.toInt();
    amount = json['amount']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (userId != null) {
      final v = userId;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v);
      }
      data['user_id'] = arr0;
    }
    data['group_id'] = groupId;
    data['amount'] = amount;
    return data;
  }
}

class AddPaymentRequestModel {
  double? amount;
  String? description;
  List<AddPaymentRequestModelSplits>? splits;

  AddPaymentRequestModel({
    this.amount,
    this.description,
    this.splits,
  });
  AddPaymentRequestModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount']?.toInt();
    description = json['description']?.toString();
    if (json['splits'] != null) {
      final v = json['splits'];
      final arr0 = <AddPaymentRequestModelSplits>[];
      v.forEach((v) {
        arr0.add(AddPaymentRequestModelSplits.fromJson(v));
      });
      splits = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['amount'] = amount;
    data['description'] = description;
    if (splits != null) {
      final v = splits;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['splits'] = arr0;
    }
    return data;
  }
}
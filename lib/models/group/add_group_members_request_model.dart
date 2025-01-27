///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class AddGroupMembersRequestModel {
  int? groupId;
  List<int?>? memberIds;

  AddGroupMembersRequestModel({
    this.groupId,
    this.memberIds,
  });
  AddGroupMembersRequestModel.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id']?.toInt();
    if (json['member_ids'] != null) {
      final v = json['member_ids'];
      final arr0 = <int>[];
      v.forEach((v) {
        arr0.add(v.toInt());
      });
      memberIds = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['group_id'] = groupId;
    if (memberIds != null) {
      final v = memberIds;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v);
      }
      data['member_ids'] = arr0;
    }
    return data;
  }
}

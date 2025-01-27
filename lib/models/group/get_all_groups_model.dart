///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class GetAllGroupsModelGroups {
  String? createdAt;
  String? creatorEmail;
  int? creatorId;
  int? creatorMobile;
  String? creatorName;
  int? groupId;
  String? groupName;
  int? memberCount;

  GetAllGroupsModelGroups({
    this.createdAt,
    this.creatorEmail,
    this.creatorId,
    this.creatorMobile,
    this.creatorName,
    this.groupId,
    this.groupName,
    this.memberCount,
  });
  GetAllGroupsModelGroups.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at']?.toString();
    creatorEmail = json['creator_email']?.toString();
    creatorId = json['creator_id']?.toInt();
    creatorMobile = json['creator_mobile']?.toInt();
    creatorName = json['creator_name']?.toString();
    groupId = json['group_id']?.toInt();
    groupName = json['group_name']?.toString();
    memberCount = json['member_count']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['created_at'] = createdAt;
    data['creator_email'] = creatorEmail;
    data['creator_id'] = creatorId;
    data['creator_mobile'] = creatorMobile;
    data['creator_name'] = creatorName;
    data['group_id'] = groupId;
    data['group_name'] = groupName;
    data['member_count'] = memberCount;
    return data;
  }
}

class GetAllGroupsModel {
  List<GetAllGroupsModelGroups?>? groups;

  GetAllGroupsModel({
    this.groups,
  });
  GetAllGroupsModel.fromJson(Map<String, dynamic> json) {
    if (json['groups'] != null) {
      final v = json['groups'];
      final arr0 = <GetAllGroupsModelGroups>[];
      v.forEach((v) {
        arr0.add(GetAllGroupsModelGroups.fromJson(v));
      });
      groups = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (groups != null) {
      final v = groups;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['groups'] = arr0;
    }
    return data;
  }
}

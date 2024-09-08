import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:splite_mate/models/group/add_group_member_request_model.dart';
import 'package:splite_mate/models/group/add_group_members_request_model.dart';
import 'package:splite_mate/models/group/common_groups_response_model.dart';
import 'package:splite_mate/models/group/create_groups_response_model.dart';
import 'package:splite_mate/models/group/get_all_groups_model.dart';
import 'package:splite_mate/models/group/get_groups_details_model.dart';
import 'package:splite_mate/utils/api.dart';

class GroupAPIServices {
  static var client = http.Client();

  static Future<CreateGroupsResponseModel> createGroup(
      String groupName, String token) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var url = Uri.parse(MyAPI.createGroup);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode({"group_name": groupName}),
    );

    if (response.statusCode != 500) {
      if (response.statusCode == 201) {
        CreateGroupsResponseModel responseModel =
        CreateGroupsResponseModel.fromJson(jsonDecode(response.body));
        return responseModel;
      }
      return CreateGroupsResponseModel(groupId: -1);
    } else {
      return CreateGroupsResponseModel(groupId: -1);
    }
  }

  static Future<GetAllGroupsModel> getAllGroups(String token) async {
    var headers = {'Authorization': 'Bearer $token'};

    var url = Uri.parse(MyAPI.getAllGroups);

    var response = await http.get(url, headers: headers);

    if (response.statusCode != 500) {
      if (response.statusCode == 200) {
        GetAllGroupsModel responseModel =
        GetAllGroupsModel.fromJson(jsonDecode(response.body));
        return responseModel;
      }
      return GetAllGroupsModel(groups: null);
    } else {
      return GetAllGroupsModel(groups: null);
    }
  }

  static Future<GetGroupsDetailsModel> getGroupsDetails(
      String token, String id) async {
    var headers = {'Authorization': 'Bearer $token'};

    var url = Uri.parse(MyAPI.getGroupDetails + id);

    var response = await http.get(url, headers: headers);

    if (response.statusCode != 500) {
      if (response.statusCode == 200) {
        GetGroupsDetailsModel responseModel =
        GetGroupsDetailsModel.fromJson(jsonDecode(response.body));
        return responseModel;
      }
      return GetGroupsDetailsModel(groupDetails: null);
    } else {
      return GetGroupsDetailsModel(groupDetails: null);
    }
  }

  static Future<CommonGroupsResponseModel> addMember(
      AddGroupMemberRequestModel data, String token) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var url = Uri.parse(MyAPI.addMember);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(data),
    );

    if (response.statusCode != 500) {
      if (response.statusCode == 200) {
        CommonGroupsResponseModel responseModel =
        CommonGroupsResponseModel.fromJson(jsonDecode(response.body));
        return responseModel;
      }
      return CommonGroupsResponseModel(error: response.reasonPhrase);
    } else {
      return CommonGroupsResponseModel(error: response.reasonPhrase);
    }
  }

  static Future<CommonGroupsResponseModel> addMembers(
      AddGroupMembersRequestModel data, String token) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var url = Uri.parse(MyAPI.addMembers);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(data),
    );

    if (response.statusCode != 500) {
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 207) {
        CommonGroupsResponseModel responseModel =
        CommonGroupsResponseModel.fromJson(jsonDecode(response.body));
        return responseModel;
      }
      return CommonGroupsResponseModel(error: response.reasonPhrase);
    } else {
      return CommonGroupsResponseModel(error: response.reasonPhrase);
    }
  }

  static Future<CommonGroupsResponseModel> deleteGroup(
      int id, String token) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var url = Uri.parse(MyAPI.deleteGroup);

    var response = await client.delete(
      url,
      headers: requestHeaders,
      body: jsonEncode({
        "group_id": id
      }),
    );

    if (response.statusCode != 500) {
      if (response.statusCode == 200) {
        CommonGroupsResponseModel responseModel =
        CommonGroupsResponseModel.fromJson(jsonDecode(response.body));
        return responseModel;
      }
      return CommonGroupsResponseModel(error: response.reasonPhrase);
    } else {
      return CommonGroupsResponseModel(error: response.reasonPhrase);
    }
  }

  static Future<CommonGroupsResponseModel> removeMember(
      AddGroupMemberRequestModel data, String token) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var url = Uri.parse(MyAPI.removeMember);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(data),
    );

    if (response.statusCode != 500) {
      if (response.statusCode == 200) {
        CommonGroupsResponseModel responseModel =
        CommonGroupsResponseModel.fromJson(jsonDecode(response.body));
        return responseModel;
      }
      return CommonGroupsResponseModel(error: response.reasonPhrase);
    } else {
      return CommonGroupsResponseModel(error: response.reasonPhrase);
    }
  }

}
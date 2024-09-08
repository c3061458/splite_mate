import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:splite_mate/models/friends/common_friends_response_model.dart';
import 'package:splite_mate/models/friends/get_all_friends_model.dart';
import 'package:splite_mate/models/friends/get_friends_by_mobile_response_model.dart';
import 'package:splite_mate/models/friends/non_group_member_friends_model.dart';
import 'package:splite_mate/utils/api.dart';

class FriendAPIServices {
  static var client = http.Client();

  static Future<CommonFriendsResponseModel> addFriend(
      String mobile, String token) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var url = Uri.parse(MyAPI.addFriend);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode({"mobile": mobile}),
    );

    if (response.statusCode != 500) {
      if (response.statusCode == 201 || response.statusCode == 200) {
        CommonFriendsResponseModel responseModel =
            CommonFriendsResponseModel.fromJson(jsonDecode(response.body));
        return responseModel;
      }
      return CommonFriendsResponseModel(error: response.reasonPhrase);
    } else {
      return CommonFriendsResponseModel(error: response.reasonPhrase);
    }
  }

  static Future<GetAllFriendsModel> getFriends(String token) async {
    var headers = {'Authorization': 'Bearer $token'};

    var url = Uri.parse(MyAPI.getFriends);

    var response = await http.get(url, headers: headers);

    if (response.statusCode != 500) {
      if (response.statusCode == 200) {
        GetAllFriendsModel responseModel =
            GetAllFriendsModel.fromJson(jsonDecode(response.body));
        return responseModel;
      }
      return GetAllFriendsModel(friends: null);
    } else {
      return GetAllFriendsModel(friends: null);
    }
  }

  static Future<NonGroupMemberFriendsModel> nonGroupMemberFriends(String token, String groupId) async {
    var headers = {'Authorization': 'Bearer $token'};

    var url = Uri.parse(MyAPI.nonGroupMemberFriends + groupId);

    var response = await http.get(url, headers: headers);

    if (response.statusCode != 500) {
      NonGroupMemberFriendsModel responseModel =
      NonGroupMemberFriendsModel.fromJson(jsonDecode(response.body));
      return responseModel;
    } else {
      return NonGroupMemberFriendsModel(friends: null);
    }
  }

  static Future<GetFriendsByMobileResponseModel> getFriendsByMobile(
      String token, String mobile) async {
    var headers = {'Authorization': 'Bearer $token'};

    var url = Uri.parse(MyAPI.getFriendByMobile + mobile);

    var response = await http.get(url, headers: headers);

    if (response.statusCode != 500) {
      if (response.statusCode == 200) {
        GetFriendsByMobileResponseModel responseModel =
            GetFriendsByMobileResponseModel.fromJson(jsonDecode(response.body));
        return responseModel;
      }
      return GetFriendsByMobileResponseModel(friend: null);
    } else {
      return GetFriendsByMobileResponseModel(friend: null);
    }
  }
}

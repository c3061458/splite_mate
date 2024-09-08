import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:splite_mate/models/auth/login/login_response_model.dart';
import 'package:splite_mate/models/friends/non_group_member_friends_model.dart';
import 'package:splite_mate/models/group/add_group_members_request_model.dart';
import 'package:splite_mate/services/api/friend.dart';
import 'package:splite_mate/services/api/group.dart';
import 'package:splite_mate/services/shared_services.dart';
import 'package:splite_mate/themes/my_theme.dart';
import 'package:splite_mate/utils/routes.dart';
import 'package:splite_mate/utils/styles/button_style.dart';
import 'package:splite_mate/utils/styles/input_style.dart';
import 'package:splite_mate/utils/styles/text_style.dart';
import 'package:splite_mate/widgets/loading.dart';
import 'package:splite_mate/widgets/my_app_bar2.dart';

class AddGroupMemberPage extends StatefulWidget {
  const AddGroupMemberPage({super.key});

  @override
  State<AddGroupMemberPage> createState() => _AddGroupMemberPageState();
}

class _AddGroupMemberPageState extends State<AddGroupMemberPage> {
  String groupName = "";
  String groupId = "";
  String mobile = "";
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  SharedServices sharedServices = SharedServices();
  LoginResponseModel loginResponseModel = LoginResponseModel();
  NonGroupMemberFriendsModel friendsModel = NonGroupMemberFriendsModel();
  List<int> memberId = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedServices.getData("user").then((user) {
      if (user != null) {
        loginResponseModel = LoginResponseModel.fromJson(jsonDecode(user));
        final args = ModalRoute.of(context)!.settings.arguments as Map;
        groupName = args['group_name']!;
        groupId = args['group_id']!.toString();
        setState(() {});
        getFriends();
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, MyRoutes.loginRoute, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar2.myAppBar(context, "Create Group"),
        body: _isLoading
            ? const Center(
                child: Loading(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                "Group Name: $groupName",
                                textAlign: TextAlign.center,
                                style: MyTextStyle.heading2(),
                              ),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              "Friend Mobile Number",
                              style: MyTextStyle.formLabel(),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.phone,
                              cursorColor: MyThemes.customPrimary,
                              decoration: MyInputStyle.textFormField(),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value == "" || value.isEmpty) {
                                  return "Please enter mobile number";
                                } else if (value.length < 10 || value.length > 10) {
                                  return "Please enter a valid mobile number";
                                }
                                return null;
                              },
                              onChanged: (value) => setState(() {
                                mobile = value;
                              }),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            ElevatedButton(
                              onPressed: () => addFriend(),
                              style: MyButtonStyle.elevatedButton(),
                              child: Text(
                                "Add Friend",
                                style: MyTextStyle.elevatedButtonText(),
                              ),),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text("Friends", style: MyTextStyle.heading2(),),
                      const SizedBox(
                        height: 10.0,
                      ),
                      if (friendsModel.friends != null)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: friendsModel.friends!.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 3,
                                              blurRadius: 7,
                                              offset: const Offset(
                                                0,
                                                0,
                                              ), // Changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          child: friendsModel
                                                      .friends![index]!.gender! ==
                                                  "male"
                                              ? Image.asset(
                                                  "assets/images/male.jpg",
                                                  height: 50.0,
                                                )
                                              : Image.asset(
                                                  "assets/images/female.jpg",
                                                  height: 50.0,
                                                ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            friendsModel
                                                .friends![index]!.userName!,
                                            style:
                                                MyTextStyle.elevatedButtonText(),
                                          ),
                                          Text(
                                            friendsModel.friends![index]!.mobile!
                                                .toString(),
                                            style: MyTextStyle.lightSubHeading3(),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Checkbox(
                                  value: memberId.contains(friendsModel.friends![index]!.userId),
                                  onChanged: (value) {
                                    if (value == true) {
                                      setState(() {
                                        if (!memberId.contains(friendsModel.friends![index]!.userId)) {
                                          memberId.add(friendsModel.friends![index]!.userId!);
                                        }
                                      });
                                    } else {
                                      setState(() {
                                        memberId.remove(friendsModel.friends![index]!.userId);
                                      });
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      const SizedBox(height: 20.0,),
                      ElevatedButton(
                          onPressed: () => addMembers(),
                          style: MyButtonStyle.elevatedButton(),
                          child: Text(
                            "Add Members",
                            style: MyTextStyle.elevatedButtonText(),
                          ),),
                      const SizedBox(height: 20.0,),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void getFriends() {
    FriendAPIServices.nonGroupMemberFriends(loginResponseModel.token!, groupId)
        .then(
      (response) {
        if (response.message == "success") {
          friendsModel = response;
          setState(() {
            _isLoading = false;
          });
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Sorry",
            text: response.message,
            backgroundColor: Colors.white,
            titleColor: Colors.black,
            textColor: Colors.black,
            confirmBtnText: "Okay",
            confirmBtnColor: MyThemes.customPrimary,
            disableBackBtn: true,
            onConfirmBtnTap: () {
              setState(() {
                _isLoading = false;
              });
              Navigator.pop(context);
            },
          );
        }
      },
    );
  }

  addMembers() {
    setState(() {
      _isLoading = true;
    });

    if (memberId.isNotEmpty) {
      AddGroupMembersRequestModel model = AddGroupMembersRequestModel(
          groupId: int.parse(groupId),
          memberIds: memberId
      );
      GroupAPIServices.addMembers(model, loginResponseModel.token!).then((response) {
        if (response.message == "Some members could not be added to the group" || response.message == "All members added to the group successfully") {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: "Success",
            text: response.message,
            backgroundColor: Colors.white,
            titleColor: Colors.black,
            textColor: Colors.black,
            confirmBtnText: "Okay",
            confirmBtnColor: MyThemes.customPrimary,
            disableBackBtn: true,
            onConfirmBtnTap: () {
              setState(() {
                _isLoading = false;
              });
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Sorry",
            text: response.message ?? response.error ?? "Something went wrong",
            backgroundColor: Colors.white,
            titleColor: Colors.black,
            textColor: Colors.black,
            confirmBtnText: "Okay",
            confirmBtnColor: MyThemes.customPrimary,
            disableBackBtn: true,
            onConfirmBtnTap: () {
              setState(() {
                _isLoading = false;
              });
              Navigator.pop(context);
            },
          );
        }
      },);
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Sorry",
        text: "Please select friends to add",
        backgroundColor: Colors.white,
        titleColor: Colors.black,
        textColor: Colors.black,
        confirmBtnText: "Okay",
        confirmBtnColor: MyThemes.customPrimary,
        disableBackBtn: true,
        onConfirmBtnTap: () {
          setState(() {
            _isLoading = false;
          });
          Navigator.pop(context);
        },
      );
    }
  }

  addFriend() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      FriendAPIServices.addFriend(mobile, loginResponseModel.token!).then((response) {
        if (response.message == "Friend added successfully") {
          getFriends();
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Sorry",
            text: response.message ?? response.error ?? "Something went wrong",
            backgroundColor: Colors.white,
            titleColor: Colors.black,
            textColor: Colors.black,
            confirmBtnText: "Okay",
            confirmBtnColor: MyThemes.customPrimary,
            disableBackBtn: true,
            onConfirmBtnTap: () {
              setState(() {
                _isLoading = false;
              });
              Navigator.pop(context);
            },
          );
        }
      },);
    }
  }
}
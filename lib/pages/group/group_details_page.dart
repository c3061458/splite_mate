import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:splite_mate/models/auth/login/login_response_model.dart';
import 'package:splite_mate/models/group/add_group_member_request_model.dart';
import 'package:splite_mate/models/group/get_groups_details_model.dart';
import 'package:splite_mate/services/api/group.dart';
import 'package:splite_mate/services/shared_services.dart';
import 'package:splite_mate/themes/my_theme.dart';
import 'package:splite_mate/utils/routes.dart';
import 'package:splite_mate/utils/styles/button_style.dart';
import 'package:splite_mate/utils/styles/text_style.dart';
import 'package:splite_mate/widgets/loading.dart';
import 'package:splite_mate/widgets/my_app_bar2.dart';

class GroupDetailsPage extends StatefulWidget {
  const GroupDetailsPage({super.key});

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  bool _isLoading = true;
  GetGroupsDetailsModel model = GetGroupsDetailsModel();
  SharedServices sharedServices = SharedServices();
  LoginResponseModel loginResponseModel = LoginResponseModel();
  String groupId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedServices.getData("user").then((user) {
      if (user != null) {
        loginResponseModel = LoginResponseModel.fromJson(jsonDecode(user));
        final args = ModalRoute.of(context)!.settings.arguments as Map;
        groupId = args['groupID']!;
        setState(() {});
        getData();
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
        appBar: MyAppBar2.myAppBar(context, "Group Details"),
        body: _isLoading
            ? const Center(
                child: Loading(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Group Name: ${model.groupDetails!.groupName!}",
                          textAlign: TextAlign.center,
                          style: MyTextStyle.heading2(),
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(
                            context, MyRoutes.addGroupMemberRoute,
                            arguments: {
                              "group_name": model.groupDetails!.groupName!,
                              "group_id": model.groupDetails!.groupId!,
                            }),
                        style: MyButtonStyle.elevatedButton(),
                        child: Text(
                          "Add New Member",
                          style: MyTextStyle.elevatedButtonText2(),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            deleteGroup(model.groupDetails!.groupId!),
                        style: MyButtonStyle.deleteElevatedButton(),
                        child: Text(
                          "Delete Group",
                          style: MyTextStyle.elevatedButtonText2(),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Members:",
                        textAlign: TextAlign.center,
                        style: MyTextStyle.heading2(),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      if (model.groupDetails!.members != null)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: model.groupDetails!.members!.length,
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
                                              color:
                                                  Colors.grey.withOpacity(0.5),
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
                                          child: model
                                                      .groupDetails!
                                                      .members![index]!
                                                      .gender! ==
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
                                            model.groupDetails!.members![index]!
                                                .userName!,
                                            style: MyTextStyle
                                                .elevatedButtonText(),
                                          ),
                                          Text(
                                            model.groupDetails!.members![index]!
                                                .mobile!
                                                .toString(),
                                            style:
                                                MyTextStyle.lightSubHeading3(),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                if (index != 0)
                                  IconButton(
                                      onPressed: () => deleteMember(
                                          model.groupDetails!.members![index]!
                                              .memberId!,
                                          model.groupDetails!.groupId!),
                                      icon: const Icon(
                                        CupertinoIcons.delete,
                                        color: Colors.red,
                                      ))
                              ],
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void getData() {
    GroupAPIServices.getGroupsDetails(loginResponseModel.token!, groupId).then(
      (response) {
        if (response.groupDetails != null) {
          model = response;
          _isLoading = false;
          setState(() {});
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Sorry",
            text: "Something went wrong",
            backgroundColor: Colors.white,
            titleColor: Colors.black,
            textColor: Colors.black,
            confirmBtnText: "Okay",
            confirmBtnColor: MyThemes.customPrimary,
            disableBackBtn: true,
            onConfirmBtnTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        }
      },
    );
  }

  deleteGroup(int id) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: "Are you sure",
      text: "You want to delete this group",
      confirmBtnText: "Yes",
      cancelBtnText: "No",
      confirmBtnColor: Colors.redAccent,
      onConfirmBtnTap: () {
        setState(() {
          _isLoading = true;
        });
        GroupAPIServices.deleteGroup(id, loginResponseModel.token!).then(
          (response) {
            if (response.message == "Group deleted successfully") {
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
                text: response.message ??
                    response.error ??
                    "Something went wrong",
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
      },
    );
  }

  deleteMember(int memberId, int groupId) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: "Are you sure",
      text: "You want to remove this member",
      confirmBtnText: "Yes",
      cancelBtnText: "No",
      confirmBtnColor: Colors.redAccent,
      onConfirmBtnTap: () {
        setState(() {
          _isLoading = true;
        });
        AddGroupMemberRequestModel memberRequestModel = AddGroupMemberRequestModel(
          groupId: groupId,
          memberId: memberId
        );
        GroupAPIServices.removeMember(memberRequestModel, loginResponseModel.token!).then(
              (response) {
            if (response.message == "Member removed from the group successfully") {
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
                    _isLoading = true;
                  });
                  Navigator.pop(context);
                  Navigator.pop(context);
                  getData();
                },
              );
            } else {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                title: "Sorry",
                text: response.message ??
                    response.error ??
                    "Something went wrong",
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
      },
    );
  }
}

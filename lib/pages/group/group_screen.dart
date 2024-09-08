import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:splite_mate/models/auth/login/login_response_model.dart';
import 'package:splite_mate/models/group/get_all_groups_model.dart';
import 'package:splite_mate/services/api/group.dart';
import 'package:splite_mate/services/shared_services.dart';
import 'package:splite_mate/themes/my_theme.dart';
import 'package:splite_mate/utils/routes.dart';
import 'package:splite_mate/utils/styles/text_style.dart';
import 'package:splite_mate/widgets/loading.dart';
import 'package:splite_mate/widgets/my_app_bar.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  bool _isLoading = true;
  GetAllGroupsModel model = GetAllGroupsModel();

  SharedServices sharedServices = SharedServices();

  LoginResponseModel loginResponseModel = LoginResponseModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedServices.getData("user").then((user) {
      if (user != null) {
        loginResponseModel = LoginResponseModel.fromJson(jsonDecode(user));
        getData(loginResponseModel);
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
        appBar: MyAppBar.myAppBar(context, "Group"),
        body: _isLoading
            ? const Center(
                child: Loading(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: model.groups!.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () async {
                      await Navigator.pushNamed(
                          context, MyRoutes.groupDetailsRoute,
                          arguments: {
                            "groupID": model.groups![index]!.groupId.toString()
                          });
                      getData(loginResponseModel);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 75.0,
                              width: 75.0,
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              child: const Icon(
                                CupertinoIcons.group,
                                size: 40.0,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model.groups![index]!.groupName!,
                                  style: MyTextStyle.elevatedButtonText(),
                                ),
                                Text(
                                  "${model.groups![index]!.memberCount!.toString()} members",
                                  style: MyTextStyle.lightSubHeading(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, MyRoutes.addGroupRoute),
          backgroundColor: MyThemes.customPrimary,
          child: const Icon(
            CupertinoIcons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void getData(LoginResponseModel loginResponseModel) {
    setState(() {
      _isLoading = true;
    });
    GroupAPIServices.getAllGroups(loginResponseModel.token!).then(
      (response) {
        if (response.groups != null) {
          model = response;
          setState(() {
            _isLoading = false;
          });
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Sorry",
            text: "No Groups found",
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
}

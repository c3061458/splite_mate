import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:splite_mate/models/auth/login/login_response_model.dart';
import 'package:splite_mate/services/api/group.dart';
import 'package:splite_mate/services/shared_services.dart';
import 'package:splite_mate/themes/my_theme.dart';
import 'package:splite_mate/utils/routes.dart';
import 'package:splite_mate/utils/styles/button_style.dart';
import 'package:splite_mate/utils/styles/input_style.dart';
import 'package:splite_mate/utils/styles/text_style.dart';
import 'package:splite_mate/widgets/loading.dart';
import 'package:splite_mate/widgets/my_app_bar2.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  String groupName = "";
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  SharedServices sharedServices = SharedServices();
  LoginResponseModel loginResponseModel = LoginResponseModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedServices.getData("user").then((user) {
      if (user != null) {
        loginResponseModel = LoginResponseModel.fromJson(jsonDecode(user));
        setState(() {

        });
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Group Name",
                          style: MyTextStyle.formLabel(),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          cursorColor: MyThemes.customPrimary,
                          decoration: MyInputStyle.textFormField(),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value == "" || value.isEmpty) {
                              return "Please group name";
                            }
                            return null;
                          },
                          onChanged: (value) => setState(() {
                            groupName = value;
                          }),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        ElevatedButton(
                          onPressed: () => addGroup(),
                          style: MyButtonStyle.elevatedButton(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                CupertinoIcons.person_add,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "Create Group",
                                style: MyTextStyle.elevatedButtonText(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  addGroup() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      GroupAPIServices.createGroup(groupName, loginResponseModel.token!).then(
        (response) {
          if (response.groupId != null) {
            setState(() {
              _isLoading = false;
            });
            Navigator.pushNamed(context, MyRoutes.addGroupMemberRoute,
                arguments: {
                  "group_name": groupName,
                  "group_id": response.groupId,
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
  }
}

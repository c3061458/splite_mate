import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:splite_mate/services/shared_services.dart';
import 'package:splite_mate/themes/my_theme.dart';
import 'package:splite_mate/utils/styles/button_style.dart';
import 'package:splite_mate/utils/styles/input_style.dart';
import 'package:splite_mate/utils/styles/text_style.dart';
import 'package:splite_mate/widgets/loading.dart';
import 'package:splite_mate/widgets/my_app_bar2.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  SharedServices sharedServices = SharedServices();
  String oldPassword = "";
  String newPassword = "";
  String confirmPassword = "";
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;

  // LoginResponseModel loginResponseModel = LoginResponseModel();

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = false;
    });
    // sharedServices.getData("user").then((user) {
    //   if (user != null) {
    //     loginResponseModel = LoginResponseModel.fromJson(jsonDecode(user));
    //     setState(() {
    //       isLoading = false;
    //     });
    //   } else {
    //     Navigator.pushNamedAndRemoveUntil(
    //         context, MyRoutes.loginRoute, (route) => false);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar2.myAppBar(context, "Change Password"),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: Loading(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create New Password",
                        style: MyTextStyle.heading1(),
                      ),
                      Text(
                        "Your new password must be unique from those previously used",
                        style: MyTextStyle.lightSubHeading(),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      formFields(context),
                      const SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  formFields(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Old Password",
            style: MyTextStyle.formLabel(),
          ),
          TextFormField(
            obscureText: true,
            cursorColor: MyThemes.customPrimary,
            decoration: MyInputStyle.textFormField(),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value == "" || value.isEmpty) {
                return "Please enter your old password";
              } else if (value.length < 6) {
                return "Password must contain at least 6 characters";
              } else if (value.length > 12) {
                return "Password cannot contain more than 12 characters";
              }
              return null;
            },
            onChanged: (value) => oldPassword = value,
          ),
          const SizedBox(
            height: 15.0,
          ),
          Text(
            "New Password",
            style: MyTextStyle.formLabel(),
          ),
          TextFormField(
            obscureText: true,
            cursorColor: MyThemes.customPrimary,
            decoration: MyInputStyle.textFormField(),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value == "" || value.isEmpty) {
                return "Please enter a new password";
              } else if (value.length < 6) {
                return "Password must contain at least 6 characters";
              } else if (value.length > 12) {
                return "Password cannot contain more than 12 characters";
              }
              return null;
            },
            onChanged: (value) => newPassword = value,
          ),
          const SizedBox(
            height: 15.0,
          ),
          Text(
            "Confirm Password",
            style: MyTextStyle.formLabel(),
          ),
          TextFormField(
            obscureText: true,
            cursorColor: MyThemes.customPrimary,
            decoration: MyInputStyle.textFormField(),
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value == "" || value.isEmpty) {
                return "Please re-enter the password";
              } else if (value != newPassword) {
                return "Password must same new password";
              }
              return null;
            },
            onChanged: (value) => confirmPassword = value,
          ),
          const SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  isLoading = true;
                  changePassword();
                });
              }
            },
            style: MyButtonStyle.elevatedButton(),
            child: Text(
              "Change Password",
              style: MyTextStyle.elevatedButtonText(),
            ),
          )
        ],
      ),
    );
  }

  void changePassword() {
    // AuthAPIServices.changePassword(
    //         oldPassword, newPassword, loginResponseModel.data!.accessToken!)
    //     .then((response) {
    //   if (response.success != null && response.success == true) {
    //     QuickAlert.show(
    //       context: context,
    //       type: QuickAlertType.success,
    //       title: "Success",
    //       text: response.message,
    //       backgroundColor: Colors.white,
    //       titleColor: Colors.black,
    //       textColor: Colors.black,
    //       confirmBtnText: "Okay",
    //       confirmBtnColor: MyThemes.customPrimary,
    //       disableBackBtn: true,
    //       onConfirmBtnTap: () {
    //         setState(() {
    //           isLoading = false;
    //         });
    //         Navigator.pop(context);
    //       },
    //     );
    //   } else {
    //     QuickAlert.show(
    //       context: context,
    //       type: QuickAlertType.error,
    //       title: "Sorry",
    //       text: response.message,
    //       backgroundColor: Colors.white,
    //       titleColor: Colors.black,
    //       textColor: Colors.black,
    //       confirmBtnText: "Okay",
    //       confirmBtnColor: MyThemes.customPrimary,
    //       disableBackBtn: true,
    //       onConfirmBtnTap: () {
    //         setState(() {
    //           isLoading = false;
    //         });
    //         Navigator.pop(context);
    //       },
    //     );
    //   }
    // });
  }
}

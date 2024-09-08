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

class ChangeSecurityPinPage extends StatefulWidget {
  const ChangeSecurityPinPage({super.key});

  @override
  State<ChangeSecurityPinPage> createState() => _ChangeSecurityPinPageState();
}

class _ChangeSecurityPinPageState extends State<ChangeSecurityPinPage> {
  SharedServices sharedServices = SharedServices();
  String oldSecurityPin = "";
  String newSecurityPin = "";
  String confirmSecurityPin = "";
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
      appBar: MyAppBar2.myAppBar(context, "Change Security Pin"),
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
                        "Create New Security Pin",
                        style: MyTextStyle.heading1(),
                      ),
                      Text(
                        "Your new Security Pin must be unique from those previously used",
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
            "Old Security Pin",
            style: MyTextStyle.formLabel(),
          ),
          TextFormField(
            obscureText: true,
            keyboardType: TextInputType.number,
            cursorColor: MyThemes.customPrimary,
            decoration: MyInputStyle.textFormField(),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value == "" || value.isEmpty) {
                return "Please enter your old Security Pin";
              } else if (value.length != 6) {
                return "Security Pin must contain of 6 characters";
              }
              return null;
            },
            onChanged: (value) => oldSecurityPin = value,
          ),
          const SizedBox(
            height: 15.0,
          ),
          Text(
            "New Security Pin",
            style: MyTextStyle.formLabel(),
          ),
          TextFormField(
            obscureText: true,
            keyboardType: TextInputType.number,
            cursorColor: MyThemes.customPrimary,
            decoration: MyInputStyle.textFormField(),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value == "" || value.isEmpty) {
                return "Please enter a new Security Pin";
              } else if (value.length != 6) {
                return "Security Pin must contain of 6 characters";
              }
              return null;
            },
            onChanged: (value) => newSecurityPin = value,
          ),
          const SizedBox(
            height: 15.0,
          ),
          Text(
            "Confirm Security Pin",
            style: MyTextStyle.formLabel(),
          ),
          TextFormField(
            obscureText: true,
            keyboardType: TextInputType.number,
            cursorColor: MyThemes.customPrimary,
            decoration: MyInputStyle.textFormField(),
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value == "" || value.isEmpty) {
                return "Please re-enter the Security Pin";
              } else if (value != newSecurityPin) {
                return "Security Pin must same new Security Pin";
              }
              return null;
            },
            onChanged: (value) => confirmSecurityPin = value,
          ),
          const SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  isLoading = true;
                  changeSecurityPin();
                });
              }
            },
            style: MyButtonStyle.elevatedButton(),
            child: Text(
              "Change Security Pin",
              style: MyTextStyle.elevatedButtonText(),
            ),
          )
        ],
      ),
    );
  }

  void changeSecurityPin() {
    // AuthAPIServices.changeSecurity Pin(
    //         oldSecurity Pin, newSecurity Pin, loginResponseModel.data!.accessToken!)
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

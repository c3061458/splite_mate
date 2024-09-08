import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:splite_mate/themes/my_theme.dart';
import 'package:splite_mate/utils/routes.dart';
import 'package:splite_mate/utils/styles/button_style.dart';
import 'package:splite_mate/utils/styles/input_style.dart';
import 'package:splite_mate/utils/styles/text_style.dart';
import 'package:splite_mate/widgets/loading.dart';

class UpdateForgotPasswordPage extends StatefulWidget {
  const UpdateForgotPasswordPage({super.key});

  @override
  State<UpdateForgotPasswordPage> createState() => _UpdateForgotPasswordPageState();
}

class _UpdateForgotPasswordPageState extends State<UpdateForgotPasswordPage> {
  String password = "";
  String confirmPassword = "";
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    isLoading = false;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.back),
        ),
      ),
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
                        "Create new password",
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
            onChanged: (value) => password = value,
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
                return "Please enter a password";
              } else if (value != password) {
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
                    // isLoading = true;
                    changePassword();
                  });
                }
              },
              style: MyButtonStyle.elevatedButton(),
              child: Text(
                "Reset Password",
                style: MyTextStyle.elevatedButtonText(),
              ))
        ],
      ),
    );
  }

  void changePassword() {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    // AuthAPIServices.updateForgotPassword(args['email'], password, args['otp']).then((response) {
    //   if (response.success != null && response.success == true) {
    //     // _services.setData("user", jsonEncode(response));
    //     QuickAlert.show(
    //       context: context,
    //       type: QuickAlertType.success,
    //       title: "Success",
    //       text: "Password changed successfully",
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
    //         Navigator.pushNamedAndRemoveUntil(context, MyRoutes.loginRoute, (route) => false);
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

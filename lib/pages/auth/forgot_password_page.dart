import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:splite_mate/themes/my_theme.dart';
import 'package:splite_mate/utils/routes.dart';
import 'package:splite_mate/utils/styles/button_style.dart';
import 'package:splite_mate/utils/styles/input_style.dart';
import 'package:splite_mate/utils/styles/text_style.dart';
import 'package:splite_mate/widgets/loading.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Image.asset("assets/images/password.png"),
                        ),
                        Text(
                          "Forgot Password?",
                          style: MyTextStyle.heading1(),
                        ),
                        Text(
                          "Don't worry! It occurs. Please enter the mobile number linked with your account.",
                          // translation(context).forgotPasswordMessage,
                          style: MyTextStyle.lightSubHeading(),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          // "Mobile Number",
                          "Email",
                          style: MyTextStyle.formLabel(),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        TextFormField(
                          // keyboardType: TextInputType.phone,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: MyThemes.customPrimary,
                          decoration: MyInputStyle.textFormField(),
                          validator: (value) {
                            final emailRegExp = RegExp(
                                r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                            if (value == null || value == "" || value.isEmpty) {
                              return "Please enter your email";
                            } else if (!emailRegExp.hasMatch(value)) {
                              return "Enter a valid email address";
                            }
                            return null;
                          },
                          onChanged: (value) => email = value,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                                sendOTP();
                              });
                            }
                          },
                          style: MyButtonStyle.elevatedButton(),
                          child: Text(
                            "Send OTP",
                            style: MyTextStyle.elevatedButtonText(),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void sendOTP() {
    Navigator.pushNamed(context, MyRoutes.otpVerificationRoute, arguments: {
      "email": email,
      "fp": "fp",
    });
    // AuthAPIServices.forgotPassword(email).then((response) {
    //   if (response.success != null && response.success == true) {
    //     Navigator.pushNamed(context, MyRoutes.otpVerificationRoute, arguments: {
    //       "email": email,
    //       "fp": "fp",
    //     });
    //     setState(() {
    //       isLoading = false;
    //     });
    //   } else {
    //     QuickAlert.show(
    //       context: context,
    //       type: QuickAlertType.error,
    //       title: 'Sorry',
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:splite_mate/models/auth/login/login_request_model.dart';
import 'package:splite_mate/services/api/auth.dart';
import 'package:splite_mate/services/shared_services.dart';
import 'package:splite_mate/themes/my_theme.dart';
import 'package:splite_mate/utils/routes.dart';
import 'package:splite_mate/utils/styles/button_style.dart';
import 'package:splite_mate/utils/styles/input_style.dart';
import 'package:splite_mate/utils/styles/text_style.dart';
import 'package:splite_mate/widgets/loading.dart';
import 'package:splite_mate/widgets/logo_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final SharedServices _services = SharedServices();
  bool isLoading = false;
  String mobile = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: LogoWidget(),
                    ),
                    Text(
                      "Login",
                      style: MyTextStyle.heading1(),
                    ),
                    Text(
                      "Login to continue",
                      style: MyTextStyle.lightSubHeading(),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    formWidget(context),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Doesn't have an account? ",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15.0,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, MyRoutes.registerRoute);
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 15.0,
                              color: MyThemes.customPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              child: isLoading
                  ? Container(
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(50, 0, 0, 0)),
                      child: const Loading(),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  formWidget(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mobile Number",
            style: MyTextStyle.formLabel(),
          ),
          TextFormField(
            keyboardType: TextInputType.phone,
            cursorColor: MyThemes.customPrimary,
            textInputAction: TextInputAction.next,
            decoration: MyInputStyle.textFormField(),
            onChanged: (value) => mobile = value,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            "Password",
            style: MyTextStyle.formLabel(),
          ),
          TextFormField(
            obscureText: true,
            cursorColor: MyThemes.customPrimary,
            decoration: MyInputStyle.textFormField(),
            onChanged: (value) => password = value,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MyRoutes.forgotPasswordRoute,
                );
              },
              child: Text(
                "Forgot Password",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15.0,
                    color: MyThemes.customPrimary),
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
            onPressed: () => isLoading ? null : login(),
            style: MyButtonStyle.elevatedButton(),
            child: Text(
              "Login",
              style: MyTextStyle.elevatedButtonText(),
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }

  void login() {
    setState(() {
      isLoading = true;
    });
    LoginRequestModel requestModel = LoginRequestModel(
      mobile: mobile,
      password: password,
    );

    AuthAPIServices.login(requestModel).then((response) {
      if (response.token != null) {
        _services.setData("user", jsonEncode(response));
        Navigator.pushNamedAndRemoveUntil(
            context, MyRoutes.homeRoute, (route) => false);
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Sorry',
          text: response.message,
          backgroundColor: Colors.white,
          titleColor: Colors.black,
          textColor: Colors.black,
          confirmBtnText: "Try Again",
          confirmBtnColor: MyThemes.customPrimary,
          disableBackBtn: true,
          onConfirmBtnTap: () {
            setState(() {
              isLoading = false;
            });
            Navigator.pop(context);
          },
        );
      }
    });
  }
}

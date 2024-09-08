import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splite_mate/themes/my_theme.dart';
import 'package:splite_mate/utils/routes.dart';
import 'package:splite_mate/utils/styles/button_style.dart';
import 'package:splite_mate/utils/styles/input_style.dart';
import 'package:splite_mate/utils/styles/text_style.dart';
import 'package:splite_mate/widgets/logo_widget.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String name = "";
  int mobileNumber = 0;
  String password = "";
  final _formKey = GlobalKey<FormState>();

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: LogoWidget()),
                Text(
                  "Register",
                  style: MyTextStyle.heading1(),
                ),
                Text(
                  "Create an account to get started.",
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
                      "Already have an Account?",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, MyRoutes.loginRoute);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15.0,
                            color: MyThemes.customPrimary),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  formWidget(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Full Name",
            style: MyTextStyle.formLabel(),
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            cursorColor: MyThemes.customPrimary,
            textInputAction: TextInputAction.next,
            decoration: MyInputStyle.textFormField(),
            validator: (value) {
              if (value == null || value == "" || value.isEmpty) {
                return "Please enter your name";
              }

              return null;
            },
            onChanged: (value) => name = value,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            "Mobile Number",
            style: MyTextStyle.formLabel(),
          ),
          TextFormField(
            keyboardType: TextInputType.phone,
            cursorColor: MyThemes.customPrimary,
            textInputAction: TextInputAction.next,
            decoration: MyInputStyle.textFormField(),
            validator: (value) {
              if (value == null || value == "" || value.isEmpty) {
                return "Please enter your mobile number";
              } else if (value.length < 10 || value.length > 10) {
                return "Please enter a valid mobile number";
              }
              return null;
            },
            onChanged: (value) => mobileNumber = int.parse(value),
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
            textInputAction: TextInputAction.done,
            decoration: MyInputStyle.textFormField(),
            validator: (value) {
              if (value == null || value == "" || value.isEmpty) {
                return "Please enter a password";
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
            height: 10.0,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pushNamed(context, MyRoutes.completeProfileRoute, arguments: {
                  "name": name,
                  "mobileNumber": mobileNumber,
                  "password": password,
                });
              }
            },
            style: MyButtonStyle.elevatedButton(),
            child: Text(
              "Continue",
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
}

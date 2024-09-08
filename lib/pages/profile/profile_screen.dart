import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splite_mate/models/auth/login/login_response_model.dart';
import 'package:splite_mate/services/shared_services.dart';
import 'package:splite_mate/themes/my_theme.dart';
import 'package:splite_mate/utils/routes.dart';
import 'package:splite_mate/utils/styles/text_style.dart';
import 'package:splite_mate/widgets/loading.dart';
import 'package:splite_mate/widgets/my_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SharedServices sharedServices = SharedServices();
  LoginResponseModel userModel = LoginResponseModel();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    sharedServices.getData("user").then((user) {
      if (user != null) {
        userModel = LoginResponseModel.fromJson(jsonDecode(user));
        setState(() {
          isLoading = false;
        });
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, MyRoutes.loginRoute, (route) => false);
      }
    });
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar.myAppBar(context, "Profile"),
      body: SafeArea(
        child: isLoading
            ? const Loading()
            : Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30.0),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100.0),
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
                      borderRadius: BorderRadius.circular(81.0),
                      child: userModel.user!.gender == "male"
                          ? Image.asset(
                        "assets/images/male.jpg",
                        height: 135.0,
                      )
                          : Image.asset(
                        "assets/images/female.jpg",
                        height: 135.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Text(
                    userModel.user!.userName!,
                    // "Test User",
                    style: MyTextStyle.heading2(),
                  ),
                  const SizedBox(height: 30.0),
                  menuItem(
                    () {
                      // Navigator.pushNamed(
                      //     context, MyRoutes.comingSoonRoute);
                    },
                    Icons.account_circle_outlined,
                    "My Account",
                  ),
                  // const SizedBox(height: 15.0),
                  // menuItem(
                  //       () {
                  //     Navigator.pushNamed(
                  //         context, MyRoutes.changeLanguageRoute);
                  //   },
                  //   Icons.language_outlined,
                  //   translation(context).changeLanguage,
                  // ),
                  const SizedBox(height: 15.0),
                  menuItem(
                        () {
                      Navigator.pushNamed(
                          context, MyRoutes.changeSecurityPinRoute);
                    },
                    Icons.lock_outline,
                    "Change Security Pin",
                  ),
                  const SizedBox(height: 15.0),
                  menuItem(
                        () {
                      Navigator.pushNamed(
                          context, MyRoutes.changePasswordRoute);
                    },
                    Icons.lock_outline,
                    "Change Password",
                  ),
                  const SizedBox(height: 15.0),
                  menuItem(() {
                    logout();
                    Navigator.pushNamedAndRemoveUntil(context, MyRoutes.loginRoute, (route) => false);
                  }, Icons.logout, "Log Out"),
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  menuItem(VoidCallback onPress, IconData iconData, String s) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 0), // Changes position of shadow
              ),
            ]),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  color: MyThemes.customPrimary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(7.0)),
              child: Icon(iconData, size: 24.0),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Text(
              s,
              style: MyTextStyle.formLabel(),
            ),
          ],
        ),
      ),
    );
  }
}

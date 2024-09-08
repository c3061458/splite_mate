import 'dart:async';

import 'package:flutter/material.dart';
import 'package:splite_mate/services/shared_services.dart';
import 'package:splite_mate/utils/routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SharedServices sharedServices = SharedServices();

  @override
  void initState() {
    super.initState();
    sharedServices.getData("user").then((user) {
      // if (user != null) {
      //   Navigator.of(context)
      //       .pushNamedAndRemoveUntil(MyRoutes.homeRoute, (route) => false);
      // }
      Navigator.of(context)
          .pushNamedAndRemoveUntil(MyRoutes.loginRoute, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Image.asset(
          "assets/icons/logo.png",
          width: MediaQuery.of(context).size.width * 0.85,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:splite_mate/utils/styles/button_style.dart';
import 'package:splite_mate/widgets/my_app_bar2.dart';

class ViewNotificationPage extends StatelessWidget {
  const ViewNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar2.myAppBar(context, "Notifications"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: noNotification(context),
        ),
      ),
    );
  }

  noNotification(context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          "assets/lottie/no-notifications.json",
        ),
        const SizedBox(
          height: 15,
        ),
         const Text(
          "No Notifications",
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 15,
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: MyButtonStyle.elevatedButton2(),
          child:  const Text(
            "Go Back",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

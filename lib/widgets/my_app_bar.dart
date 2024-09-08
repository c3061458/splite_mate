import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splite_mate/themes/my_theme.dart';
import 'package:splite_mate/utils/routes.dart';

class MyAppBar {
  static PreferredSizeWidget myAppBar(context, title) {
    return AppBar(
      backgroundColor: MyThemes.customPrimary,
      title: Row(
        children: [
          // ClipRRect(
          //     borderRadius: BorderRadius.circular(10.0),
          //     child: const Image(
          //       image: AssetImage("assets/icons/sn.jpg"),
          //       height: 35.0,
          //     )),
          // const SizedBox(
          //   width: 10.0,
          // ),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () =>
              Navigator.pushNamed(context, MyRoutes.notificationRoute),
          icon: const Icon(
            CupertinoIcons.bell,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

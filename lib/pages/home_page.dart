import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:splite_mate/pages/group/group_screen.dart';
import 'package:splite_mate/pages/home/home_screen.dart';
import 'package:splite_mate/pages/payment/payment_screen.dart';
import 'package:splite_mate/pages/profile/profile_screen.dart';
import 'package:splite_mate/pages/transactions/transaction_screen.dart';
import 'package:splite_mate/themes/my_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.confirm,
          title: "Are you sure",
          text: "You want to exit the app",
          confirmBtnText: "Yes",
          cancelBtnText: "No",
          confirmBtnColor: Colors.redAccent,
          onConfirmBtnTap: () {
            exit(0);
          },
        );
      },
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          height: 80.0,
          elevation: 0.0,
          indicatorColor: MyThemes.customPrimary.withOpacity(0.3),
          selectedIndex: currentPageIndex,
          onDestinationSelected: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(icon: Icon(CupertinoIcons.home), label: "Home"),
            NavigationDestination(icon: Icon(CupertinoIcons.group), label: "Group"),
            NavigationDestination(icon: Icon(CupertinoIcons.plus_app), label: "Pay"),
            NavigationDestination(icon: Icon(CupertinoIcons.rectangle_on_rectangle), label: "Transactions"),
            NavigationDestination(icon: Icon(CupertinoIcons.profile_circled), label: "Profile"),
          ],
        ),
        body: [
          const HomeScreen(),
          const GroupScreen(),
          const PaymentScreen(),
          const TransactionScreen(),
          const ProfileScreen()
        ][currentPageIndex],
      ),
    );
  }
}


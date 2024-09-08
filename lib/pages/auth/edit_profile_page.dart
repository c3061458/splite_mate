import 'package:flutter/material.dart';
import 'package:splite_mate/widgets/my_app_bar2.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar2.myAppBar(context, "Edit Profile"),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}

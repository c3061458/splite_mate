import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:splite_mate/models/auth/register/register_request_model.dart';
import 'package:splite_mate/services/api/auth.dart';
import 'package:splite_mate/themes/my_theme.dart';
import 'package:splite_mate/utils/routes.dart';
import 'package:splite_mate/utils/styles/button_style.dart';
import 'package:splite_mate/utils/styles/input_style.dart';
import 'package:splite_mate/utils/styles/text_style.dart';
import 'package:splite_mate/widgets/loading.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  String _selectedGender = 'Select Gender';
  TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime(2000, 1);
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String pin = "";
  bool isValidTaluka = true;
  bool isValidVillage = true;
  bool isValidGender = true;
  bool isLoading = true;

  String language = "en";

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = false;
    });
    // getData();
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

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
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Complete Profile",
                        style: MyTextStyle.heading1(),
                      ),
                      Text(
                        "Complete your profile to continue",
                        style: MyTextStyle.lightSubHeading(),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      formWidget(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  formWidget() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Email",
            style: MyTextStyle.formLabel(),
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            cursorColor: MyThemes.customPrimary,
            textInputAction: TextInputAction.next,
            decoration: MyInputStyle.textFormField(),
            validator: (value) {
              final emailRegExp =
                  RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
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
          Text(
            "Security Pin",
            style: MyTextStyle.formLabel(),
          ),
          TextFormField(
            obscureText: true,
            cursorColor: MyThemes.customPrimary,
            decoration: MyInputStyle.textFormField(),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value == "" || value.isEmpty) {
                return "Please enter a new Security Pin";
              } else if (value.length < 6) {
                return "Security Pin must contain at least 6 characters";
              } else if (value.length > 12) {
                return "Security Pin cannot contain more than 6 characters";
              }
              return null;
            },
            onChanged: (value) => pin = value,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            "Gender",
            style: MyTextStyle.formLabel(),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: isValidGender ? MyThemes.customPrimary : Colors.red,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: DropdownButton(
              value: _selectedGender,
              underline: const SizedBox(),
              isDense: true,
              isExpanded: true,
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 19.0),
              items: [
                "Select Gender",
                "Male",
                "Female",
                "Other"
              ].map((String value) {
                if (value == "Select Gender") {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
          ),
          isValidGender
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                  child: Text(
                    "Select Valid Gender",
                    style:
                        TextStyle(color: Colors.red.shade900, fontSize: 12.0),
                  ),
                ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            "Date of Birth",
            style: MyTextStyle.formLabel(),
          ),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
              decoration: BoxDecoration(
                border: Border.all(color: MyThemes.customPrimary, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year}",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
            onPressed: () {
              if (_selectedGender == "Select Gender") {
                setState(() {
                  isValidGender = false;
                });
              } else {
                setState(() {
                  isValidGender = true;
                });
              }
              if (_formKey.currentState!.validate() &&
                  isValidTaluka &&
                  isValidVillage &&
                  isValidGender) {
                final args = ModalRoute.of(context)!.settings.arguments as Map;

                String dob = dateController.text;

                RegisterRequestModel model = RegisterRequestModel(
                  userName: args['name']!,
                  mobile: args['mobileNumber']!.toString(),
                  password: args['password']!,
                  email: email,
                  birthDate: dob.substring(0, 10),
                  securityPin: int.parse(pin),
                  gender: _selectedGender,
                );

                setState(() {
                  isLoading = true;
                  register(model, context);
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
            height: 30.0,
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1947, 1),
      lastDate: DateTime(2023, 12),
      currentDate: DateTime(2000, 1),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = picked.toString();
      });
    }
  }

  void register(RegisterRequestModel model, BuildContext context) {
    AuthAPIServices.register(model).then((response) {
      if (response.statusCode == 201) {
        Navigator.pushNamed(context, MyRoutes.otpVerificationRoute, arguments: {
          "email": email,
        });
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Sorry",
          text: response.message,
          backgroundColor: Colors.white,
          titleColor: Colors.black,
          textColor: Colors.black,
          confirmBtnText: "Okay",
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

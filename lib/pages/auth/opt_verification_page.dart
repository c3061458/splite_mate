import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:splite_mate/pages/auth/widget/otp_timer_widget.dart';
import 'package:splite_mate/services/api/auth.dart';
import 'package:splite_mate/services/shared_services.dart';
import 'package:splite_mate/themes/my_theme.dart';
import 'package:splite_mate/utils/routes.dart';
import 'package:splite_mate/utils/styles/button_style.dart';
import 'package:splite_mate/utils/styles/input_style.dart';
import 'package:splite_mate/utils/styles/text_style.dart';
import 'package:splite_mate/widgets/loading.dart';

class OTPVerificationPage extends StatefulWidget {
  const OTPVerificationPage({super.key});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final SharedServices _services = SharedServices();
  final _formKey = GlobalKey<FormState>();
  String otp = "";
  bool isLoading = true;
  late String email;
  var fp;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = (ModalRoute.of(context)?.settings.arguments ??
          <String, dynamic>{}) as Map;

      email = args['email'];
      fp = args['fp'];

      setState(() {
        isLoading = false;
      });
    });
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Image.asset("assets/images/otp2.png"),
                        ),
                        Text(
                          "OTP Verification",
                          style: MyTextStyle.heading1(),
                        ),
                        RichText(
                          text: TextSpan(
                              text:
                              "Enter the verification code we just sent on your email address: ",
                              style: MyTextStyle.lightSubHeading(),
                              children: [
                                TextSpan(
                                    text: email,
                                    style: TextStyle(color: MyThemes.customPrimary))
                              ]),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          cursorColor: MyThemes.customPrimary,
                          decoration: MyInputStyle.textFormField(),
                          validator: (value) {
                            if (value == null || value == "" || value.isEmpty) {
                              return "Please enter OTP";
                            } else if (value.length != 6) {
                              return "Please enter a valid OTP number";
                            }
                            return null;
                          },
                          onChanged: (value) => otp = value,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                                verify();
                              });
                            }
                          },
                          style: MyButtonStyle.elevatedButton(),
                          child: Text(
                            "Verify",
                            style: MyTextStyle.elevatedButtonText(),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't received code? ",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 15.0,
                              ),
                            ),
                            OTPTimerWidget(),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void verify() {
    AuthAPIServices.verifyOtp(email, otp).then((response) {
      if (response.statusCode == 200) {
        if (fp == null) {
          // _services.setData("user", jsonEncode(response));
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: "Success",
            text: "Registration Successful",
            backgroundColor: Colors.white,
            titleColor: Colors.black,
            textColor: Colors.black,
            confirmBtnText: "Okay",
            confirmBtnColor: MyThemes.customPrimary,
            disableBackBtn: true,
            onConfirmBtnTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, MyRoutes.loginRoute, (route) => false);
            },
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, MyRoutes.updateForgotPasswordRoute, (route) => false,
              arguments: {"email": email, "otp": otp});
        }
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Sorry",
          text: response.error,
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

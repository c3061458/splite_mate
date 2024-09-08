import 'package:flutter/material.dart';
import 'package:splite_mate/utils/export_pages.dart';
import 'package:splite_mate/utils/routes.dart';

void main() {
  runApp(const SpliteMate());
}

class SpliteMate extends StatelessWidget {
  const SpliteMate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      initialRoute: MyRoutes.splashRoute,
      routes: {
        "/": (context) => const SplashPage(),
        MyRoutes.splashRoute: (context) => const SplashPage(),
        MyRoutes.homeRoute: (context) => const HomePage(),
        MyRoutes.loginRoute: (context) => const LoginPage(),
        MyRoutes.registerRoute: (context) => const RegistrationPage(),
        MyRoutes.completeProfileRoute: (context) => const CompleteProfilePage(),
        MyRoutes.otpVerificationRoute: (context) => const OTPVerificationPage(),
        MyRoutes.forgotPasswordRoute: (context) => const ForgotPasswordPage(),
        MyRoutes.updateForgotPasswordRoute: (context) =>
        const UpdateForgotPasswordPage(),
        MyRoutes.changePasswordRoute: (context) => const ChangePasswordPage(),
        MyRoutes.changeSecurityPinRoute: (context) => const ChangeSecurityPinPage(),
        MyRoutes.cratePasswordRoute: (context) => const CreatePasswordPage(),
        MyRoutes.notificationRoute: (context) => const ViewNotificationPage(),
        MyRoutes.paymentRoute: (context) => const PaymentPage(),
        MyRoutes.groupDetailsRoute: (context) => const GroupDetailsPage(),
        MyRoutes.addGroupRoute: (context) => const CreateGroupPage(),
        MyRoutes.addGroupMemberRoute: (context) => const AddGroupMemberPage(),

      },
    );
  }
}

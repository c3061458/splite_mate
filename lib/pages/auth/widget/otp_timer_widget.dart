import 'dart:async';

import 'package:flutter/material.dart';
import 'package:splite_mate/themes/my_theme.dart';

class OTPTimerWidget extends StatefulWidget {
  const OTPTimerWidget({super.key});

  @override
  State<OTPTimerWidget> createState() => _OTPTimerWidgetState();
}

class _OTPTimerWidgetState extends State<OTPTimerWidget> {
  late Timer _timer;
  int _remainingSeconds = 30;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        // Handle timer completion (e.g., show a message)
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');

    return GestureDetector(
      onTap: () {
        setState(() {
          if (seconds == "00") {
            _remainingSeconds = 30;
            startTimer();
          }
        });
      },
      child: Text(
        seconds != "00" ? seconds : "Resend",
        style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 15.0,
            color: MyThemes.customPrimary),
      ),
    );
  }
}

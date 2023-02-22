import 'dart:async';
import 'package:flutter/material.dart';
import 'package:job_manager/presentation/screens/signin_screen.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    // Timer.run(() { })
    Timer(
        Duration(seconds: 1),
        () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()))
            });
  }
}

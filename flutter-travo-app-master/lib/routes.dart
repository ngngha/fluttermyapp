import 'package:flutter/material.dart';
import 'package:travo_app_source/data/model/project_model.dart';
import 'package:travo_app_source/representation/screen/add_project_screen.dart';
import 'package:travo_app_source/representation/screen/intro_screen.dart';
import 'package:travo_app_source/representation/widgets/list_project.dart';
import 'package:travo_app_source/representation/widgets/login_check.dart';
import 'package:travo_app_source/representation/screen/logout_screen.dart';
import 'package:travo_app_source/representation/screen/main_app.dart';
import 'package:travo_app_source/representation/screen/signin_screen.dart';
import 'package:travo_app_source/representation/screen/signup_screen.dart';

final Map<String, WidgetBuilder> routes = {
  IntroScreen.routeName: (context) => const IntroScreen(),
  LoginCheck.routeName: (context) => const LoginCheck(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  MainApp.routeName: (context) => MainApp(),
  ListProject.routeName: (context) => ListProject(),
  // AddProject.routeName: (context) => AddProject(),
  LogOut.routeName: (context) => LogOut(),
};

MaterialPageRoute<dynamic>? generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case (IntroScreen.routeName):
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => IntroScreen(),
      );
    case (LoginCheck.routeName):
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => LoginCheck(),
      );
    case (SignInScreen.routeName):
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => SignInScreen(),
      );
    case (SignUpScreen.routeName):
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => SignUpScreen(),
      );
    case (ListProject.routeName):
      final project =
          settings.arguments == null ? null : (settings.arguments as Project);
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => AddProject(
          projectModal: project,
        ),
      );
    // case CheckOutScreen.routeName:
    //   final RoomModel roomModel = (settings.arguments as RoomModel);
    //   return MaterialPageRoute<dynamic>(
    //     settings: settings,
    //     builder: (context) => CheckOutScreen(
    //       roomModel: roomModel,
    //     ),
    //   );

    // case HotelBookingScreen.routeName:
    //   final String? destination = (settings.arguments as String?);
    //   return MaterialPageRoute<dynamic>(
    //     settings: settings,
    //     builder: (context) => HotelBookingScreen(
    //       destination: destination,
    //     ),
    //   );
    default:
      return null;
  }
}

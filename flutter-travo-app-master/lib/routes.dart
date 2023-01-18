import 'package:flutter/material.dart';
import 'package:travo_app_source/representation/screen/intro_screen.dart';
import 'package:travo_app_source/representation/screen/loginHome.dart';
import 'package:travo_app_source/representation/screen/logout_screen.dart';
import 'package:travo_app_source/representation/screen/main_app.dart';
import 'package:travo_app_source/representation/screen/profile.dart';
import 'package:travo_app_source/representation/screen/signin_screen.dart';
import 'package:travo_app_source/representation/screen/signup_screen.dart';

final Map<String, WidgetBuilder> routes = {
  IntroScreen.routeName: (context) => const IntroScreen(),
  LogInhome.routeName: (context) => const LogInhome(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  MainApp.routeName: (context) => MainApp(),
  LogOut.routeName: (context) => LogOut(),
};

MaterialPageRoute<dynamic>? generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    // case DetailHotelScreen.routeName:
    //   final HotelModel hotelModel = (settings.arguments as HotelModel);
    //   return MaterialPageRoute<dynamic>(
    //     settings: settings,
    //     builder: (context) => DetailHotelScreen(
    //       hotelModel: hotelModel,
    //     ),
    //   );
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

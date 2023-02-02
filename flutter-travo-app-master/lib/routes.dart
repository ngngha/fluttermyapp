
import 'package:flutter/material.dart';
import 'package:travo_app_source/data/model/project_model.dart';
import 'package:travo_app_source/data/model/user_model.dart';
import 'package:travo_app_source/representation/screen/add_project_screen.dart';
import 'package:travo_app_source/representation/screen/edit_profile_screen.dart';
import 'package:travo_app_source/representation/screen/intro_screen.dart';
import 'package:travo_app_source/representation/screen/list_project_screen.dart';
import 'package:travo_app_source/representation/screen/profile_screen.dart';
import 'package:travo_app_source/representation/widgets/login_check.dart';
import 'package:travo_app_source/representation/screen/main_app.dart';
import 'package:travo_app_source/representation/screen/signin_screen.dart';
import 'package:travo_app_source/representation/screen/signup_screen.dart';

final Map<String, WidgetBuilder> routes = {
  IntroScreen.routeName: (context) => IntroScreen(),
  LoginCheck.routeName: (context) => LoginCheck(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  MainApp.routeName: (context) => MainApp(),
  ListProject.routeName: (context) => ListProject(),
  // AddProject.routeName: (context) => AddProject(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  EditProfileScreen.routeName: (context) => EditProfileScreen(),
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
    case (AddProject.routeName):
      final project =
          settings.arguments == null ? null : (settings.arguments as Project);
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => AddProject(
          projectModal: project,
        ),
      );
    case (ProfileScreen.routeName):
      final users =
          settings.arguments == null ? null : (settings.arguments as Users);
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => ProfileScreen(
          usersModal: users,
        ),
      );
    case (EditProfileScreen.routeName):
      final users =
          settings.arguments == null ? null : (settings.arguments as Users);
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => EditProfileScreen(
          usersModal: users,
        ),
      );
    default:
      return null;
  }
}

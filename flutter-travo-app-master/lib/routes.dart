import 'package:flutter/material.dart';
import 'package:travo_app_source/data/model/project_model.dart';
import 'package:travo_app_source/data/model/task_model.dart';
import 'package:travo_app_source/data/model/user_model.dart';
import 'package:travo_app_source/presentation/screens/add_project_screen.dart';
import 'package:travo_app_source/presentation/screens/edit_profile_screen.dart';
import 'package:travo_app_source/presentation/screens/intro_screen.dart';
import 'package:travo_app_source/presentation/screens/list_project_screen.dart';
import 'package:travo_app_source/presentation/screens/list_task_screen.dart';
import 'package:travo_app_source/presentation/screens/profile_screen.dart';
import 'package:travo_app_source/presentation/screens/task_screen_service.dart';
import 'package:travo_app_source/presentation/widgets/login_check.dart';
import 'package:travo_app_source/presentation/screens/main_app.dart';
import 'package:travo_app_source/presentation/screens/signin_screen.dart';
import 'package:travo_app_source/presentation/screens/signup_screen.dart';

final Map<String, WidgetBuilder> routes = {
  IntroScreen.routeName: (context) => IntroScreen(),
  LoginCheck.routeName: (context) => LoginCheck(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  MainApp.routeName: (context) => MainApp(),
};

MaterialPageRoute<dynamic>? generateRoutes(RouteSettings settings) {
  switch (settings.name) {
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
    case (ListTask.routeName):
      final task =
          settings.arguments == null ? null : (settings.arguments as Task);
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => ListTask(
          taskModal: task,
        ),
      );
    case (TaskService.routeName):
      final task =
          settings.arguments == null ? null : (settings.arguments as Task);
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => TaskService(
          taskModal: task,
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

import 'package:flutter/material.dart';
import 'package:job_manager/data/model/project_model.dart';
import 'package:job_manager/data/model/task_model.dart';
import 'package:job_manager/data/model/user_model.dart';
import 'package:job_manager/presentation/screens/add_project_screen.dart';
import 'package:job_manager/presentation/screens/attendance_screen.dart';
import 'package:job_manager/presentation/screens/edit_profile_screen.dart';
import 'package:job_manager/presentation/screens/forgot_password.dart';
import 'package:job_manager/presentation/screens/intro_screen.dart';
import 'package:job_manager/presentation/screens/list_project_screen.dart';
import 'package:job_manager/presentation/screens/list_task_screen.dart';
import 'package:job_manager/presentation/screens/profile_screen.dart';
import 'package:job_manager/presentation/screens/task_screen_service.dart';
import 'package:job_manager/presentation/widgets/login_check.dart';
import 'package:job_manager/presentation/screens/main_app.dart';
import 'package:job_manager/presentation/screens/signin_screen.dart';
import 'package:job_manager/presentation/screens/signup_screen.dart';

final Map<String, WidgetBuilder> routes = {
  IntroScreen.routeName: (context) => IntroScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  // LoginCheck.routeName: (context) => LoginCheck(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  MainApp.routeName: (context) => MainApp(),
  CalendarScreen.routeName: (context) => CalendarScreen(),
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
      final user =
          settings.arguments == null ? null : (settings.arguments as UserModel);
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => ProfileScreen(
          userModel: user,
        ),
      );
    case (EditProfileScreen.routeName):
      final user =
          settings.arguments == null ? null : (settings.arguments as UserModel);
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => EditProfileScreen(
          userModel: user,
        ),
      );
    default:
      return null;
  }
}
 
import 'package:flutter/material.dart';
import 'package:job_manager/core/constants/color_palatte.dart';
import 'package:job_manager/presentation/screens/list_project_screen.dart';
import 'package:job_manager/presentation/screens/list_task_screen.dart';
import 'package:job_manager/presentation/screens/profile_screen.dart';
import 'package:job_manager/presentation/screens/signin_screen.dart';

import 'home_screen.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  static const routeName = '/main_app';

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(
          () => _currentIndex = i,
        ),
        selectedItemColor: ColorPalette.primaryColor,
        unselectedItemColor: ColorPalette.primaryColor.withOpacity(0.4),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Project',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeScreen(),
          SignInScreen(),
          ListTask(),
          ProfileScreen(),
        ],
      ),
    );
  }
}

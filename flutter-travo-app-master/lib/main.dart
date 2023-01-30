import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:travo_app_source/core/constants/color_palatte.dart';
import 'package:travo_app_source/representation/screen/home_screen.dart';
import 'package:travo_app_source/representation/screen/main_app.dart';
import 'package:travo_app_source/representation/screen/opening_screen.dart';
import 'package:travo_app_source/routes.dart';

import 'core/helpers/size_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      runApp(const MyApp(auth: false));
    } else {
      runApp(const MyApp(auth: true));
    }
  });
}
//   options: DefaultFirebaseOptions.currentPlatform,
// );
// await Hive.initFlutter();
// await LocalStorageHelper.initLocalStorageHelper();
// runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.auth}) : super(key: key);
  final bool auth;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        primaryColor: ColorPalette.primaryColor,
        scaffoldBackgroundColor: ColorPalette.backgroundScaffoldColor,
        backgroundColor: ColorPalette.backgroundScaffoldColor,
      ),
      routes: routes,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: generateRoutes,
      home:  auth ? MainApp() :
      Builder(
        builder: (context) {
          SizeConfig.init(context);
          return  OpeningView();
        }, 
      ),
    );
  }
}

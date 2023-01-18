import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:travo_app_source/core/constants/color_palatte.dart';
import 'package:travo_app_source/firebase_options.dart';
import 'package:travo_app_source/representation/screen/opening_screen.dart';
import 'package:travo_app_source/routes.dart';

import 'core/helpers/size_config.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // await Hive.initFlutter();
  // await LocalStorageHelper.initLocalStorageHelper();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primaryColor: ColorPalette.primaryColor,
        scaffoldBackgroundColor: ColorPalette.backgroundScaffoldColor,
        backgroundColor: ColorPalette.backgroundScaffoldColor,
      ),
      routes: routes,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: generateRoutes,
      home: Builder(
        builder: (context) {
          SizeConfig.init(context);
          return OpeningView();
        },
      ),
    );
  }
}

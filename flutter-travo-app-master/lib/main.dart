import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:job_manager/core/constants/color_palatte.dart';
import 'package:job_manager/presentation/screens/main_app.dart';
import 'package:job_manager/presentation/screens/splash_screen.dart';
import 'package:job_manager/routes.dart';

import 'core/helpers/size_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOption\.currentPlatform,
      );
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
          brightness: Brightness.light,
          primarySwatch: Colors.teal,
          primaryColor: ColorPalette.primaryColor,
          scaffoldBackgroundColor: ColorPalette.backgroundScaffoldColor,
          dialogBackgroundColor: ColorPalette.backgroundScaffoldColor,
          textTheme: TextTheme(
            titleLarge: TextStyle(color: Colors.teal),
            headlineSmall: TextStyle(color: Colors.white)
          )),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      routes: routes,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: generateRoutes,
      home: auth
          ? MainApp()
          : Builder(
              builder: (context) {
                SizeConfig.init(context);
                return SplashScreen();
              },
            ),
      localizationsDelegates: const [MonthYearPickerLocalizations.delegate],
    );
  }
}

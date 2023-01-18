import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:travo_app_source/representation/screen/signin_screen.dart';

class LogInhome extends StatefulWidget {
  const LogInhome({Key? key}) : super(key: key);
  static String routeName = '/login_screen';

  @override
  State<LogInhome> createState() => _LogInhomeState();
}

class _LogInhomeState extends State<LogInhome> {
  
Future<FirebaseApp> _initializeFirebase() async {

    FirebaseApp firebaseApp = await Firebase.initializeApp();

    return firebaseApp;

  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(

      body: FutureBuilder(

        future: _initializeFirebase(),

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.done) {

            return const SignInScreen();

          }

          return const Center(

            child: CircularProgressIndicator(),

          );

        },

      ),

    );
  }
}